# CampusIQ

CampusIQ is a department management platform for universities. It brings students, faculty,
courses, equipment, purchase requests, budgets and reporting into one system, and adds an
assistant that answers questions by querying the database directly rather than guessing.

Built for a single academic department, using Pakistani institutional context throughout:
real roll number formats, PKR currency, and HEC credit hour rules.

---

## Contents

**Understanding the project**
- [The problem it solves](#the-problem-it-solves)
- [How the system is put together](#how-the-system-is-put-together)
- [The modules](#the-modules)
- [User roles and permissions](#user-roles-and-permissions)
- [The database](#the-database)

**Working with it**
- [Running it on your machine](#running-it-on-your-machine)
- [Demo accounts](#demo-accounts)
- [Available commands](#available-commands)
- [Environment variables](#environment-variables)
- [Deploying to the web](#deploying-to-the-web)

**Reference**
- [API reference](#api-reference)
- [Project structure](#project-structure)
- [Troubleshooting](#troubleshooting)

**Engineering notes**
- [Design decisions](#design-decisions)
- [Challenges we ran into](#challenges-we-ran-into)
- [What we learned](#what-we-learned)
- [Known limitations](#known-limitations)
- [Future work](#future-work)
- [Contributing](#contributing)

---

# Understanding the project

## The problem it solves

A university department runs on information that usually lives in separate places. Student
records sit in one system, the equipment register in a spreadsheet, purchase requests in
email, and the budget in someone's personal file. Nobody can answer a simple question like
"how much did we spend on lab equipment this semester, and who approved it" without opening
four different things and trusting that all four are current.

CampusIQ puts all of it in one database and connects the pieces. When an officer approves a
request to buy five computers, the system records the expense in the finance ledger and adds
the computers to the inventory in the same transaction. Nothing is entered twice, and the
trail from request to expense to asset stays intact and auditable.

## How the system is put together

Three layers, kept deliberately separate.

**The database** holds everything. Sixteen related MySQL tables with foreign keys, cascade
rules and indexes. Business constraints such as valid request states and asset conditions
are enforced at this level, not only in application code, so bad data cannot get in through
a different path.

**The API** is a Node.js and Express service. It owns all business logic: authentication,
role checks, the request workflow, the cross module transactions, and the query engine
behind the assistant. Every endpoint validates the caller's role on the server, so a
restricted user cannot reach a protected route by calling it directly.

**The web application** is a React single page application built with Vite. It holds no
business rules. It renders what the API returns and sends back what the user does. This
separation is what allowed the whole thing to be deployed to the cloud later without
rewriting any feature code.

### Technology

| Layer | Choices |
| :--- | :--- |
| Backend | Node.js, Express, ES modules |
| Database | MySQL 8, mysql2 driver with connection pooling |
| Security | JSON Web Tokens, bcrypt password hashing, Helmet headers, CORS allowlist |
| Frontend | React 19, Vite, Recharts, Lucide icons |
| Styling | Plain CSS with design tokens, no UI framework |

## The modules

### Dashboard

The landing page after login. Every figure is calculated live from the database rather than
read from stored totals, so nothing can drift out of date.

It shows headline indicators across all modules, a revenue and expense trend chart, a
breakdown of expenses by category, course enrollment levels, a feed of recent request
activity, and short written observations derived from the current data.

### Academic

Three connected areas.

**Students.** Searchable records with roll number, programme, semester and GPA. Students
below a 2.50 GPA are flagged so they can be followed up. Opening a student shows their
current course enrollments.

**Faculty.** The teaching directory, with each member's assigned credit hours shown against
the HEC standard of 12 hours per week. Anyone above it is marked as overloaded, which makes
it immediately clear who cannot take another course. Equipment issued to each member appears
on their record.

**Courses.** The catalogue with a capacity meter per offering showing how full it is. From
here you can view the roster and enroll a student, which runs as a database transaction so
seat counts stay correct even under concurrent use.

### Inventory

The register of physical assets: computers, lab equipment, projectors, networking hardware
and furniture, across seven categories.

Each item carries a condition of Good, Fair or Damaged, plus quantity, location and value.
Items can be issued to a faculty member or a lab, and custody history is retained, so you
can see who had what and when it came back. Issuing and returning adjusts available stock
automatically.

### Requests

The approval workflow, and the module where the automated text analysis does the most work.

When someone submits a request, the text is analysed to determine its type (purchase, leave,
maintenance or general), its priority, and the structured details inside it: what is wanted,
how many, why, and the likely cost. A short summary is produced for the reviewer. The same
analysis can run live as the user types, so they can see what the system understood before
they submit.

Requests move through defined states: Pending, then Under Review, then Approved, Returned
with Remarks, or Rejected. Every transition is recorded with who made it and when, and both
sides can leave comments on the thread.

The purchase workflow is where the modules join up. Approving a purchase request does three
things in a single transaction: marks the request approved, records the cost as an expense,
and adds or increments the item in inventory. If any step fails, all three roll back. The
records stay linked, so an asset can always be traced back to the request that bought it.

### Finance

Revenue and expenses for the department, held in PKR with live conversion available.

Revenue covers research grants, tuition allocations and other income. Expenses cover
operational spending by category. Both support full create, edit and delete.

On top of the ledgers, the module tracks budget periods and revenue goals, and calculates
total revenue, total expenses, net balance, margin percentage, budget utilisation and goal
progress. Monthly trends and category breakdowns are charted rather than left as tables.

### Reports

Generates audit reports on demand across four areas: academic, financial, inventory and
requests.

A report is compiled from live queries at the moment it is generated, then given a written
executive summary drawn from those same figures. The result opens in a printable preview
with the department seal, a verification stamp, an indicator grid and structured tables.
Every generated report is archived and can be reopened later.

### AI Assistant

A question and answer interface over the department's data.

The design point is how it avoids inventing answers. A question is translated into a
specific SQL query, that query runs against the database, and the answer is constructed from
the rows returned. If the data cannot answer the question, it says so rather than producing
a plausible number.

Each answer shows a confidence indicator, the supporting rows it was built from, and links
through to the module holding those records, so any claim can be verified in a couple of
clicks.

### Settings

Currency switches live between PKR, USD and EUR, with rates applied across every figure.
Institution and department names are configurable, and profile changes persist immediately.

### System health

A diagnostics page and two public endpoints reporting whether the API is running and whether
it can reach the database. When something breaks, this tells you which layer failed.

## User roles and permissions

| Role | What they can do |
| :--- | :--- |
| Administrator | Everything. Budget allocation, executive reports, deletions, full governance. |
| Officer | Review and approve requests, issue and receive equipment, record finance entries. |
| Faculty | Submit requests, view their workload, courses and assigned equipment. |
| Staff | Submit maintenance and lab requests, inspect assets. |

Permissions are enforced by role guard middleware on the server. The interface hides what a
user cannot do, but the server is what actually refuses it.

## The database

Sixteen tables with foreign keys and cascade rules that keep data consistent when records
are removed.

| Area | Tables |
| :--- | :--- |
| Organisation | departments, users |
| Academic | students, faculty, courses, enrollments |
| Inventory | inventory, inventory_assignments |
| Requests | requests, request_history, request_comments |
| Finance | revenue, expenses, budgets, revenue_goals |
| Reporting | reports |

Money is stored as DECIMAL(12,2) rather than a floating point type, so totals do not drift
by fractions of a rupee across thousands of rows.

The seed data includes 1 department, 6 users across all four roles, 30 students, 10 faculty,
12 courses, 30 enrollments, 22 inventory items, 6 assignments, 32 requests, 12 revenue
entries, 24 expenses, 2 budget periods, 2 goals and 3 reports.

---

# Working with it

## Running it on your machine

### Before you start

- Node.js 18 or later. Check with `node -v`.
- MySQL or MariaDB on port 3306. XAMPP is the easiest route on Windows.
- Git.

### Step 1: Get the code

```bash
git clone https://github.com/ImanAsmatMughal/CampusIQ.git
cd CampusIQ
```

### Step 2: Create your environment files

Copy the templates into place. You need one in the project root and one in `backend/`.

Windows PowerShell:

```powershell
Copy-Item .env.example .env
Copy-Item backend/.env.example backend/.env
```

macOS, Linux or Git Bash:

```bash
cp .env.example .env
cp backend/.env.example backend/.env
```

Both are ignored by Git and must stay that way.

Worth knowing: the application loads `backend/.env` first and the root `.env` second, and it
does not overwrite values already set. If a variable appears in both files, the one in
`backend/.env` wins. Keep them in sync.

### Step 3: Install dependencies

```bash
npm run install:all
```

### Step 4: Create and fill the database

With MySQL running:

```bash
npm run db:init
```

This creates the database if needed, applies all 16 tables from `database/schema.sql`, and
loads the demo data from `database/seed.sql`. It prints every table with its record count
when finished.

Running it again resets everything to a clean state, which is useful before a demo. To
reload only the data, use `npm run db:seed`.

### Step 5: Start both servers

Two terminals.

```bash
npm run dev:backend    # API on port 5000
```

```bash
npm run dev:frontend   # Web app on port 5173
```

Confirm the API with `http://localhost:5000/api/health`, and its database connection with
`http://localhost:5000/api/health/db`. Then open `http://localhost:5173`.

## Demo accounts

All seeded accounts use the password `Password123!`.

| Role | Email | Name |
| :--- | :--- | :--- |
| Administrator | admin@departmenthub.edu | Dr. Khurram Nadeem |
| Officer | officer@departmenthub.edu | Syed Muhammad Ali |
| Faculty | faculty@departmenthub.edu | Dr. Ayesha Khan |
| Staff | staff@departmenthub.edu | Muhammad Rizwan |

The login page fills these in with one click, and you can switch roles from the profile menu
without logging out. There is no self registration; accounts come from the seed data.

## Available commands

| Command | What it does |
| :--- | :--- |
| `npm run install:all` | Installs backend and frontend dependencies |
| `npm run db:init` | Creates the database, applies the schema, loads demo data |
| `npm run db:seed` | Reloads demo data into an existing database |
| `npm run dev:backend` | Starts the API in development mode on port 5000 |
| `npm run dev:frontend` | Starts the Vite dev server on port 5173 |
| `npm run build` | Builds the frontend for production |
| `npm run start` | Starts the API in production mode |
| `npm run render-build` | Installs everything and builds the frontend, for hosting platforms |

## Environment variables

| Variable | Purpose | Local value |
| :--- | :--- | :--- |
| `PORT` | Port the API listens on | `5000` |
| `NODE_ENV` | `development` or `production` | `development` |
| `DB_HOST` | Database hostname | `localhost` |
| `DB_PORT` | Database port | `3306` |
| `DB_USER` | Database username | `root` |
| `DB_PASSWORD` | Database password | empty for XAMPP |
| `DB_NAME` | Database name | `campusiq_db` |
| `DB_SSL` | `true` for a cloud database requiring TLS | `false` |
| `DB_SSL_CA` | The provider's CA certificate, when using TLS | unset |
| `DB_SSL_REJECT_UNAUTHORIZED` | `false` to skip certificate verification | `true` |
| `DB_SKIP_CREATE` | `true` when the provider creates the database for you | `false` |
| `DB_POOL_LIMIT` | Maximum pooled connections | `20` locally, `3` on serverless |
| `JWT_SECRET` | Secret used to sign login tokens | change in production |
| `JWT_EXPIRES_IN` | Session lifetime | `7d` |
| `CLIENT_URL` | Comma separated browser origins allowed to call the API | `http://localhost:5173` |
| `ALLOW_VERCEL_PREVIEWS` | Allows Vercel preview deployments through CORS | `false` |
| `SERVE_CLIENT` | Serves the built frontend from the API process | `false` |
| `GEMINI_API_KEY` | Optional. Without it the built in engine is used | unset |
| `MIGRATION_SECRET` | Enables the protected migration endpoints | unset |

Never commit real values. Document any new variable in both `.env.example` files.

## Deploying to the web

The application needs a MySQL database reachable from the internet, so a local XAMPP
installation cannot back a deployed site.

### Database

Any managed MySQL 8 service works, and the schema and seed files run unmodified. Set
`DB_SSL=true`, and either paste the provider's certificate into `DB_SSL_CA` or set
`DB_SSL_REJECT_UNAUTHORIZED=false`. If the provider creates the database for you, set
`DB_SKIP_CREATE=true` so the schema's own CREATE DATABASE statement is skipped.

Load the schema and data by pointing `npm run db:init` at the cloud database from your own
machine, with the connection details set as environment variables in your terminal session.

### Hosting

`vercel.json` deploys the frontend and API together as one Vercel project using Vercel
Services. The frontend is served at the root and the API at `/api`, on the same domain,
which removes cross origin configuration entirely. Set `VITE_API_URL=/api`, and leave the
project's Root Directory setting empty so Vercel reads `vercel.json` from the repository
root.

`render.yaml` is an alternative describing a single Render service that serves the API and
the built frontend together using `SERVE_CLIENT=true`.

If you host the two separately instead, set `VITE_API_URL` on the frontend to the API's full
address ending in `/api`, and `CLIENT_URL` on the API to the frontend's address with no
trailing slash. Both need a rebuild after changing, because `VITE_API_URL` is compiled into
the JavaScript bundle at build time.

Full step by step instructions are in `DEPLOYMENT.md`.

---

# Reference

## API reference

All paths are relative to the API base. Authenticated endpoints expect an
`Authorization: Bearer <token>` header.

### System

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/health` | API status, uptime, environment | Public |
| GET | `/api/health/db` | Database connectivity and version | Public |

### Authentication

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| POST | `/api/auth/login` | Sign in, returns a JWT | Public |
| GET | `/api/auth/demo-accounts` | Lists the seeded demo accounts | Public |
| GET | `/api/auth/me` | The signed in user's profile | Authenticated |

### Dashboard

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/dashboard/stats` | All dashboard indicators and chart data | Authenticated |

### Academic

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/academic/students` | List and filter students | Authenticated |
| GET | `/api/academic/students/:id` | One student with enrollments | Authenticated |
| POST | `/api/academic/students` | Add a student | Officer, Admin |
| PUT | `/api/academic/students/:id` | Update a student | Officer, Admin |
| DELETE | `/api/academic/students/:id` | Remove a student | Admin |
| GET | `/api/academic/faculty` | Faculty directory with workloads | Authenticated |
| GET | `/api/academic/faculty/:id` | One faculty member | Authenticated |
| POST | `/api/academic/faculty` | Add a faculty member | Admin |
| PUT | `/api/academic/faculty/:id` | Update a faculty member | Admin |
| DELETE | `/api/academic/faculty/:id` | Remove a faculty member | Admin |
| GET | `/api/academic/courses` | Course catalogue with capacity | Authenticated |
| GET | `/api/academic/courses/:id` | One course with its roster | Authenticated |
| POST | `/api/academic/courses` | Create a course | Admin |
| PUT | `/api/academic/courses/:id` | Update a course | Admin |
| DELETE | `/api/academic/courses/:id` | Remove a course | Admin |
| POST | `/api/academic/courses/:id/enroll` | Enroll a student | Officer, Admin |

### Inventory

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/inventory` | Asset register with filters | Authenticated |
| GET | `/api/inventory/stats` | Counts and values by category | Authenticated |
| GET | `/api/inventory/:id` | One asset with custody history | Authenticated |
| POST | `/api/inventory` | Add an asset | Officer, Admin |
| PUT | `/api/inventory/:id` | Update an asset | Officer, Admin |
| DELETE | `/api/inventory/:id` | Remove an asset | Admin |
| POST | `/api/inventory/:id/assign` | Issue an asset to a person or lab | Officer, Admin |
| PUT | `/api/inventory/assignments/:assignmentId/return` | Mark an asset returned | Officer, Admin |

### Requests

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/requests` | List requests, filterable by type, status, priority | Authenticated |
| GET | `/api/requests/stats` | Counts by status and type | Authenticated |
| GET | `/api/requests/:id` | One request with history and comments | Authenticated |
| POST | `/api/requests` | Submit a request, analysis runs automatically | Authenticated |
| POST | `/api/requests/analyze` | Analyse text without submitting | Authenticated |
| POST | `/api/requests/:id/status` | Approve, return, or reject | Officer, Admin |
| POST | `/api/requests/:id/comments` | Add a comment to the thread | Authenticated |

### Finance

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/finance/overview` | Totals, margins, utilisation, trends | Officer, Admin |
| GET | `/api/finance/revenue` | Revenue entries | Officer, Admin |
| POST | `/api/finance/revenue` | Record revenue | Officer, Admin |
| PUT | `/api/finance/revenue/:id` | Update a revenue entry | Officer, Admin |
| DELETE | `/api/finance/revenue/:id` | Delete a revenue entry | Admin |
| GET | `/api/finance/expenses` | Expense entries | Officer, Admin |
| POST | `/api/finance/expenses` | Record an expense | Officer, Admin |
| PUT | `/api/finance/expenses/:id` | Update an expense | Officer, Admin |
| DELETE | `/api/finance/expenses/:id` | Delete an expense | Admin |
| GET | `/api/finance/budgets` | Budget periods | Officer, Admin |
| POST | `/api/finance/budgets` | Create a budget period | Admin |
| GET | `/api/finance/goals` | Revenue goals with progress | Officer, Admin |
| POST | `/api/finance/goals` | Create a revenue goal | Admin |

### Reports

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/reports` | Archive of generated reports | Officer, Admin |
| GET | `/api/reports/:id` | One report with its full content | Officer, Admin |
| POST | `/api/reports/generate` | Generate a report with a written summary | Officer, Admin |

### AI Assistant

| Method | Path | Description | Access |
| :--- | :--- | :--- | :--- |
| GET | `/api/ai/suggestions` | Suggested questions to ask | Authenticated |
| POST | `/api/ai/query` | Ask a question, get an answer plus source rows | Authenticated |

### Administration

These exist for hosting platforms that provide no shell for running setup scripts. They do
nothing unless `MIGRATION_SECRET` is set, and they require that value in an
`x-migration-secret` header. Leave the variable unset in normal operation.

| Method | Path | Description |
| :--- | :--- | :--- |
| POST | `/api/admin/migrate?confirm=reset` | Rebuilds every table and reloads seed data. Destructive. |
| POST | `/api/admin/seed` | Reloads the seed data only |

## Project structure

```
CampusIQ/
├── backend/
│   ├── src/
│   │   ├── controllers/     Request handlers, one file per module
│   │   ├── routes/          Express route definitions
│   │   ├── services/        Text analysis and inventory business logic
│   │   ├── middleware/      JWT verification, role guards, error handling
│   │   ├── db/              Connection pool, TLS config, setup and seed scripts
│   │   ├── app.js           Express application and middleware
│   │   └── server.js        Server entry point
│   ├── .env.example
│   └── package.json
├── frontend/
│   ├── src/
│   │   ├── components/      Shared UI components
│   │   ├── context/         Authentication and settings state
│   │   ├── layouts/         Application shell, sidebar, header
│   │   ├── pages/           One file per module screen
│   │   ├── services/        API client with timeout handling
│   │   ├── App.jsx          Screen switching and providers
│   │   ├── main.jsx         React entry point
│   │   └── index.css        Design tokens and base styles
│   ├── package.json
│   └── vite.config.js
├── database/
│   ├── schema.sql           All 16 tables with keys and indexes
│   └── seed.sql             Demo dataset
├── docs/
│   ├── PRD.md
│   └── API_NOTES.md
├── vercel.json              Vercel Services deployment config
├── render.yaml              Render deployment blueprint
├── DEPLOYMENT.md            Step by step deployment guide
├── .env.example
├── .gitignore
└── README.md
```

## Troubleshooting

**The API cannot connect to the database.** Confirm MySQL is running. Then check `DB_HOST`,
`DB_PORT`, `DB_USER` and `DB_PASSWORD` in `backend/.env`, remembering that it overrides the
root `.env`.

**`getaddrinfo ENOTFOUND` with a cloud database.** The hostname does not resolve. Either it
is mistyped, or the database service is stopped. Many free tier providers power a service
down after inactivity, which removes its DNS record entirely.

**Unknown database, or empty tables.** Run `npm run db:init`.

**Port 5000 or 5173 already in use.** Change `PORT` in `backend/.env`, or start Vite with
`--port 5174`.

**`vite is not recognized`.** Frontend dependencies are missing. Run
`npm install --prefix frontend`.

**A deployed site shows a CORS error on login.** The API's `CLIENT_URL` does not include the
frontend's address, or the API was not redeployed after the value changed.

**A deployed site returns HTML where JSON was expected.** `VITE_API_URL` points at an address
with no API on it. It must end in `/api`, have no trailing slash, and the frontend must be
rebuilt after any change.

**MySQL will not start in XAMPP.** Usually another MySQL service holds port 3306. On Windows,
find it with `netstat -ano | findstr :3306`.

---

# Engineering notes

## Design decisions

**The assistant queries, it does not generate.** A question is mapped to a deterministic SQL
query, and the answer is built from the rows it returns, which are shown alongside it.
Handing the question to a language model would have been easier, but a department system
that confidently reports a wrong budget figure is worse than no feature at all.

**Cross module writes are transactional.** Approving a purchase touches three tables in three
modules. Those writes run in one transaction and roll back together, so there is never an
approved request without its expense, or an asset that nothing paid for. Enrollment works the
same way, so two students cannot claim the last seat.

**Money is DECIMAL, never float.** Floating point error is not acceptable on a budget page.
All currency columns are DECIMAL(12,2).

**Roles are enforced on the server.** Hiding a button is a user experience choice, not a
security control. Every protected route checks the caller's role in middleware.

**Nothing is hardcoded.** Hostnames, ports, credentials and origins come from the
environment. This is what made deployment possible later without touching feature code.

## Challenges we ran into

**Local assumptions leak everywhere.** Building against XAMPP left `localhost` fallbacks,
"Connected to XAMPP MySQL" labels and XAMPP specific error messages throughout the app. None
of it breaks anything locally, so none of it surfaced until a stranger could read it.

**Windows to Linux is not automatic.** The root `package.json` called `npm.cmd`, which fails
on every build server. Path casing is the other trap: Windows ignores it, Linux does not.

**Build time and run time variables behave differently.** `VITE_API_URL` is compiled into the
bundle at build time, so changing it in a dashboard does nothing until a rebuild. `DB_HOST`
is read at run time. Confusing the two cost real time.

**Connection pooling assumes a long lived server.** A pool of 20 suits one process. On
serverless, every warm instance holds its own pool and a small database plan runs out of
connections, so the size had to become configurable.

**Same origin is simpler than correct CORS.** Two domains means an allowlist, a redeploy
whenever a URL changes, and failures that surface as a generic "Failed to fetch". Serving
both from one domain removed the whole class of problem.

**Free tier infrastructure sleeps.** A free managed database powers off when idle, and its
DNS record disappears with it. The error then looks like a configuration mistake rather than
a stopped service.

## What we learned

**Deployment is a design constraint, not a final step.** Nearly every problem above existed
from day one and stayed invisible because everything ran on one machine.

**An error message is user interface.** "Failed to fetch" is accurate and useless. The errors
that saved time were the ones naming the actual host and database being used.

**Check what a system resolves, not what it should resolve.** An hour went to a variable that
looked correct but pointed at the wrong host, and to a hostname that was correct but belonged
to a stopped server.

**Constraints in the database outlive constraints in code.** Application rules get bypassed
by the next script someone writes. Foreign keys and DECIMAL columns do not.

## Known limitations

- **No automated tests.** Verification has been manual.
- **No pagination.** List endpoints return every matching row. Fine at demo scale, not at a
  few thousand students.
- **No input validation library.** Request bodies are checked ad hoc in the controllers.
- **No rate limiting.** The login endpoint in particular can be hammered.
- **The schema is not migration safe.** `schema.sql` drops all 16 tables before recreating
  them, so it cannot be applied to a database holding data you want to keep.
- **Reports print rather than export.** Output opens the browser print dialog. There is no
  server generated PDF.
- **No user management.** Accounts come only from seed data. No registration, password reset
  or admin interface.
- **Single department.** The table exists, but the application assumes one throughout.
- **English only.** No localisation, despite the Pakistani context.

## Future work

**Correctness first**

1. A test suite, starting with the transactional paths where silent failure does real damage.
2. Schema validation on request bodies, with consistent error responses.
3. Incremental migrations replacing the drop and recreate schema file.

**Usable at real scale**

4. Pagination and server side sorting on list endpoints.
5. Caching for dashboard aggregations, which currently recompute on every load.
6. Rate limiting and account lockout on authentication.

**What a department would ask for next**

7. User management: creating accounts, resetting passwords, deactivating leavers.
8. File attachments on requests, for quotations and invoices.
9. Email notification when a request changes state.
10. Multi department support, using the table that already exists.
11. Continuous integration running tests and a Linux build on every pull request, which would
    have caught several of the problems above.

## Contributing

**Protect secrets.** Never put passwords, keys or tokens in code. Read them from
`process.env`, and document any new variable in both `.env.example` files.

**Work on a branch.** Create one with `git checkout -b feature/your-feature-name`, confirm
that `npm run db:init` and both dev servers still work, then open a pull request against
`main`.

**Keep the schema shared.** If you change a table or relationship, update
`database/schema.sql` and `database/seed.sql` in the same commit, so teammates get the change
when they next run `npm run db:init`.

## License

Built for academic departments and faculty governance.
