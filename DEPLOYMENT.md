# CampusIQ — Deploying the live demo

Goal: one public URL where the React app and the Express API are served together,
backed by a cloud MySQL database instead of local XAMPP.

**Stack:** Render (web service) + Aiven (free MySQL). No credit card required.

Local development is unaffected — with `DB_SSL` unset the app still talks to XAMPP exactly as before.

---

## What already changed in the code

| File | Change |
|---|---|
| `backend/src/db/sslConfig.js` | **New.** Builds TLS options for cloud MySQL from `DB_SSL` / `DB_SSL_CA` / `DB_SSL_REJECT_UNAUTHORIZED`. |
| `backend/src/db/connection.js` | Pool now applies those TLS options. |
| `backend/src/db/initDb.js` | TLS support, `DB_SKIP_CREATE` for hosts that pre-create the database, returns a result instead of only setting an exit code. |
| `backend/src/db/seedDb.js` | Same TLS + result handling. |
| `backend/src/routes/adminRoutes.js` | **New.** `POST /api/admin/migrate` and `/api/admin/seed`, locked behind a `MIGRATION_SECRET` header. This is how the cloud database gets its schema — Render's free tier gives you no shell. |
| `backend/src/app.js` | Loads dotenv first; `CLIENT_URL` is now a comma-separated allowlist; optional `SERVE_CLIENT=true` serves `frontend/dist` from the same service; mounts `/api/admin`; adds `GET /` for health probes. |
| `backend/src/server.js` | Binds `0.0.0.0` (cloud hosts reject loopback-only servers). |
| `package.json` (root) | Replaced Windows-only `npm.cmd` calls with `npm` so the build runs on Linux; added `render-build` and `start`. |
| `render.yaml` | **New.** Render Blueprint describing the service and its environment variables. |
| `.env.example`, `backend/.env.example` | Documented the new variables. |

Nothing in your SQL, controllers, or React code was touched.

---

## Step 1 — Create the MySQL database (Aiven)

1. Go to **https://console.aiven.io** and sign up (Google sign-in is fine).
2. **Create service → MySQL**.
3. Under plan, pick the one labelled **Free** (1 GB). Note which **cloud region** it offers —
   you'll want Render in a nearby region in Step 3.
4. Name it `campusiq-db` and create it. Provisioning takes about 3–5 minutes;
   wait until the status is **Running**.
5. On the service **Overview** tab, copy these — you need all of them shortly:

   - **Host** — something like `campusiq-db-xxxx.a.aivencloud.com`
   - **Port** — usually a 5-digit number, *not* 3306
   - **User** — `avnadmin`
   - **Password** — click to reveal
   - **Database** — `defaultdb`
   - **CA certificate** — click **Download** and open `ca.pem` in Notepad

> Aiven only accepts TLS connections, which is why the CA certificate matters.

---

## Step 2 — Push the code to GitHub

Render deploys from a repository. In PowerShell, from the project folder:

```powershell
cd "I:\Eiman Asmat Mughal\Pak Angles Cohort Certificate\Hackathon\CampusIQ"
git add -A
git commit -m "Add cloud deployment support: TLS MySQL, migration endpoint, Render blueprint"
git push
```

If `git push` is rejected because you don't have write access to `Waleed2412/CampusIQ.v2`,
create your own repo instead:

```powershell
git remote add mine https://github.com/ImanAsmatMughal/CampusIQ.git
git push mine main
```

(Create the empty `CampusIQ` repo on GitHub first, without a README.)

`.env` is gitignored, so your local credentials do not leave your machine.

---

## Step 3 — Deploy on Render

1. Go to **https://render.com** and sign up **with GitHub**, so it can see your repos.
2. **New → Blueprint**, then select the CampusIQ repository.
   Render reads `render.yaml` and pre-fills most of the configuration.
3. Before it deploys, it will ask you for the values marked as secrets. Fill in:

   | Variable | Value |
   |---|---|
   | `DB_HOST` | Aiven host |
   | `DB_PORT` | Aiven port |
   | `DB_USER` | `avnadmin` |
   | `DB_PASSWORD` | Aiven password |
   | `DB_NAME` | `defaultdb` |
   | `DB_SSL_CA` | paste the **entire** contents of `ca.pem`, including the `-----BEGIN CERTIFICATE-----` and `-----END CERTIFICATE-----` lines |
   | `GEMINI_API_KEY` | your key, or leave blank to use the built-in fallback engine |

   `JWT_SECRET` and `MIGRATION_SECRET` are generated automatically — you don't type those.

4. In `render.yaml` the region is set to `singapore`. If your Aiven database landed in
   Europe or the US, edit that line to match before deploying — a database on another
   continent adds noticeable latency to every query.

5. Click **Apply** and watch the build log. It runs `npm run render-build`
   (installs backend + frontend, builds the React bundle), then starts the server.
   First build takes roughly 3–5 minutes.

When it finishes you'll have a URL like `https://campusiq.onrender.com`.

---

## Step 4 — Load the schema and seed data

The database is empty at this point. In the Render dashboard open your service →
**Environment** → reveal **`MIGRATION_SECRET`** and copy it.

Then, in PowerShell:

```powershell
curl.exe -X POST "https://YOUR-APP.onrender.com/api/admin/migrate?confirm=reset" `
  -H "x-migration-secret: PASTE_THE_SECRET_HERE"
```

Expected response:

```json
{"success":true,"message":"Schema applied and seed data loaded (16 tables).","tables":16}
```

This drops and recreates all 16 tables and loads the 204-record demo dataset.
`?confirm=reset` is required precisely because it's destructive — run it again any
time you want to reset the demo to a clean state.

---

## Step 5 — Verify

| Check | URL | Expected |
|---|---|---|
| API alive | `https://YOUR-APP.onrender.com/api/health` | `{"status":"ok"...}` |
| Database connected | `https://YOUR-APP.onrender.com/api/health/db` | success, with a MySQL version |
| App loads | `https://YOUR-APP.onrender.com` | the login page |

Then log in with a seeded account — password `Password123!` for all of them:

- **Admin** — Dr. Khurram Nadeem
- **Officer** — Syed Muhammad Ali
- **Faculty** — Dr. Ayesha Khan
- **Staff** — Muhammad Rizwan

Click through Dashboard, Requests, Finance, Reports and the AI Assistant to confirm
real data is coming back rather than empty states.

---

## Step 6 — Close the migration door

Once the data is loaded, go to Render → **Environment** and **delete `MIGRATION_SECRET`**,
then redeploy. Both `/api/admin/*` endpoints then return `403` to everyone, including you.
Re-add it if you ever need to reseed.

---

## Step 7 — Keep it awake for judging

Render's free tier sleeps a service after 15 minutes of no traffic, and the next
request takes 40–60 seconds to wake it. That is a bad first impression for a judge
clicking your link.

Two options:

- **Open your URL 2–3 minutes before the demo** and leave the tab open. Simplest, and enough.
- **Set up a pinger** — create a free job at https://cron-job.org hitting
  `https://YOUR-APP.onrender.com/api/health` every 10 minutes.

---

## Troubleshooting

**Build fails on `vite: not found`** — Render ran the wrong build command. Confirm it is
`npm run render-build`, not `npm install`.

**`/api/health/db` fails with a TLS or certificate error** — the CA certificate didn't
paste cleanly. As a fallback, set `DB_SSL_REJECT_UNAUTHORIZED=false` in Render's
environment. The connection stays encrypted; it just stops verifying the server's identity.
Prefer fixing the CA paste.

**`ER_ACCESS_DENIED_ERROR`** — the password has a trailing space, or `DB_NAME` isn't `defaultdb`.

**The site loads but every panel is empty** — Step 4 hasn't run, or it failed. Re-run it
and read the JSON it returns.

**The site loads but API calls 404** — `VITE_API_URL` wasn't `/api` at build time.
It's set in `render.yaml`; if you configured the service manually instead of via the
Blueprint, add it and redeploy.

**Login works locally but not on Render** — you're hitting the old bundle. Hard-refresh
with Ctrl+Shift+R.
