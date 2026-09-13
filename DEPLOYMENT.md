# CampusIQ — Deploying to Vercel

**Architecture:** two Vercel projects from this one repo, plus a free Aiven MySQL database.

| Project | Root Directory | What it is |
|---|---|---|
| `campusiq-api` | `backend` | The Express app, running as a Vercel Function |
| `campusiq` | `frontend` | The Vite/React build, served from Vercel's CDN |

Two projects rather than one, because Vercel ignores `express.static()` — an Express app
there cannot serve your React bundle. Splitting them is the supported shape, and the
CORS allowlist in `app.js` already handles the two origins.

Local development is unaffected. With `DB_SSL` unset the app still talks to XAMPP as before.

---

## Step 1 — Create the GitHub repo

Go to **https://github.com/new** signed in as `ImanAsmatMughal`:

- Repository name: **`CampusIQ`**
- Private or Public — your call. Vercel deploys from private repos on the free plan.
- **Do not** tick "Add a README", `.gitignore`, or a license.

The `mine` remote is already configured locally, which is why the earlier push failed with
*Repository not found* — the remote was pointing at a repo that didn't exist yet.

---

## Step 2 — Push

```powershell
cd "I:\Eiman Asmat Mughal\Pak Angles Cohort Certificate\Hackathon\CampusIQ"

git add -A
git commit -m "Vercel deployment support: serverless-safe pool, CORS allowlist, TLS MySQL"
git push -u mine main
```

`.env` is gitignored, so your credentials stay on your machine.

---

## Step 3 — Create the Aiven MySQL database

1. **https://console.aiven.io** → sign up → **Create service → MySQL** → the **Free** plan (1 GB).
2. Name it `campusiq-db`. Provisioning takes 3–5 minutes; wait for **Running**.
3. From the **Overview** tab collect: **Host**, **Port** (5 digits, not 3306), **User** (`avnadmin`),
   **Password**, **Database** (`defaultdb`), and download the **CA certificate** (`ca.pem`).

---

## Step 4 — Seed the database from your own machine

Do this *before* deploying, so the API has data the moment it goes live.

Your laptop can open a direct MySQL connection to Aiven, so this is just `db:init` pointed
at the cloud instead of XAMPP. In PowerShell:

```powershell
cd "I:\Eiman Asmat Mughal\Pak Angles Cohort Certificate\Hackathon\CampusIQ"

$env:DB_HOST="YOUR-HOST.aivencloud.com"
$env:DB_PORT="YOUR-PORT"
$env:DB_USER="avnadmin"
$env:DB_PASSWORD="YOUR-PASSWORD"
$env:DB_NAME="defaultdb"
$env:DB_SSL="true"
$env:DB_SSL_REJECT_UNAUTHORIZED="false"
$env:DB_SKIP_CREATE="true"

npm run db:init
```

You should see all 16 tables listed with their record counts, ending in
`✔ CampusIQ database setup and seeding completed successfully!`

These variables only live in that PowerShell window — close it and your local XAMPP
setup is untouched. Nothing was written to `.env`.

> `DB_SKIP_CREATE=true` matters: Aiven pre-creates `defaultdb` and the schema's own
> `CREATE DATABASE` statement would fail. The init script strips it when this is set.

---

## Step 5 — Deploy the API

1. **https://vercel.com/new** → import the `CampusIQ` repo.
2. **Project Name:** `campusiq-api`
3. **Root Directory:** click *Edit* and choose **`backend`** — this is the important one.
   Vercel detects the Express app automatically; leave the framework preset alone.
4. Add these Environment Variables:

   | Variable | Value |
   |---|---|
   | `NODE_ENV` | `production` |
   | `DB_HOST` | Aiven host |
   | `DB_PORT` | Aiven port |
   | `DB_USER` | `avnadmin` |
   | `DB_PASSWORD` | Aiven password |
   | `DB_NAME` | `defaultdb` |
   | `DB_SSL` | `true` |
   | `DB_SSL_CA` | full contents of `ca.pem`, `-----BEGIN`/`-----END` lines included |
   | `DB_POOL_LIMIT` | `3` |
   | `JWT_SECRET` | a long random string — generate one, don't reuse the example |
   | `JWT_EXPIRES_IN` | `7d` |
   | `ALLOW_VERCEL_PREVIEWS` | `true` |
   | `GEMINI_API_KEY` | your key, or leave unset for the fallback engine |

   Leave `CLIENT_URL` out for now — you don't know the frontend URL yet.
   Do **not** set `SERVE_CLIENT`; it does nothing on Vercel.

5. Deploy, then check `https://campusiq-api.vercel.app/api/health` and
   `https://campusiq-api.vercel.app/api/health/db`. The second one proves Aiven is wired up.

`DB_POOL_LIMIT=3` is there because every warm function instance keeps its own pool.
The default of 20, multiplied across instances, would exhaust Aiven's free connection cap.

---

## Step 6 — Deploy the frontend

1. **https://vercel.com/new** → import the **same repo** again.
2. **Project Name:** `campusiq`
3. **Root Directory:** **`frontend`** — Vercel detects Vite on its own.
4. One environment variable:

   | Variable | Value |
   |---|---|
   | `VITE_API_URL` | `https://campusiq-api.vercel.app/api` |

   Use the real API URL from Step 5. The trailing `/api` is required — the frontend appends
   paths like `/auth/login` directly to it.

5. Deploy.

---

## Step 7 — Point CORS back at the frontend

The API will reject the frontend until you tell it that origin is allowed.

In the **`campusiq-api`** project → Settings → Environment Variables, add:

| Variable | Value |
|---|---|
| `CLIENT_URL` | `https://campusiq.vercel.app` |

Comma-separate if you want more than one, e.g.
`https://campusiq.vercel.app,http://localhost:5173`. No trailing slash.

Then **redeploy the API** — environment variable changes don't apply to an existing deployment.

---

## Step 8 — Verify

| Check | Where | Expected |
|---|---|---|
| API alive | `campusiq-api.vercel.app/api/health` | `{"status":"ok"...}` |
| Database | `campusiq-api.vercel.app/api/health/db` | success + MySQL version |
| App | `campusiq.vercel.app` | login page |

Log in — password `Password123!` for every seeded account:

- **Admin** — Dr. Khurram Nadeem
- **Officer** — Syed Muhammad Ali
- **Faculty** — Dr. Ayesha Khan
- **Staff** — Muhammad Rizwan

Walk through Dashboard, Requests, Finance, Reports and the AI Assistant and confirm real
data loads rather than empty states.

---

## Troubleshooting

**Login fails, console shows a CORS error** — Step 7 isn't done, or the API wasn't redeployed
after adding `CLIENT_URL`.

**Every request 404s** — `VITE_API_URL` is wrong or missing its `/api` suffix. It's baked in at
build time, so fix it and redeploy the frontend; editing the variable alone changes nothing.

**`/api/health/db` fails on TLS** — the `ca.pem` paste got mangled. Fall back to
`DB_SSL_REJECT_UNAUTHORIZED=false` (still encrypted, just unverified) and redeploy.

**`ER_CON_COUNT_ERROR` or "too many connections"** — lower `DB_POOL_LIMIT` to `2`.

**Panels are empty but the API is healthy** — Step 4 didn't actually run. Re-run it and read the output.

**The API 404s on every route** — Root Directory isn't set to `backend`.

---

## Re-seeding later

Re-run Step 4 any time to reset the demo to a clean state — it drops and recreates all 16 tables.

There are also protected endpoints (`POST /api/admin/migrate`, `POST /api/admin/seed`, gated
behind a `MIGRATION_SECRET` env var and an `x-migration-secret` header). They exist for hosts
with no shell, but on Vercel they can't read `database/*.sql` — that folder sits outside the
`backend` root directory and isn't part of the deployment. Seed from your own machine instead.

---

## Note on Render

`render.yaml` is still in the repo. It describes a single-service Render deployment that
serves the API and React build together from one URL, using `SERVE_CLIENT=true`. It's a
working alternative if you ever want one URL instead of two — Render's free tier does
sleep after 15 minutes of inactivity, which is its main drawback for live judging.
