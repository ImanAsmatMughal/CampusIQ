# CampusIQ

CampusIQ is a department management platform for universities. It brings students, faculty,
courses, equipment, purchase requests, budgets and reporting into one place, and adds an
assistant that answers questions by reading the database directly rather than guessing.

It was built for a single academic department, using Pakistani institutional context
throughout: real roll number formats, PKR currency, and HEC credit hour rules.

## Contents

- [What the platform does](#what-the-platform-does)
- [Technology used](#technology-used)
- [The modules](#the-modules)
- [User roles](#user-roles)
- [The database](#the-database)
- [Running it on your machine](#running-it-on-your-machine)
- [Demo accounts](#demo-accounts)
- [Available commands](#available-commands)
- [Environment variables](#environment-variables)
- [Deploying to the web](#deploying-to-the-web)
- [API reference](#api-reference)
- [Project structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## What the platform does

A university department runs on information that usually lives in separate places. Student
records sit in one system, the equipment register in a spreadsheet, purchase requests in
email, and the budget in someone's personal file. Nobody can answer a simple question like
"how much did we spend on lab equipment this semester, and who approved it" without opening
four different things.

CampusIQ puts all of it in one database and connects the pieces. When an officer approves a
request to buy five computers, the system records the expense in the finance ledger and adds
the computers to the inventory automatically. Nothing has to be entered twice, and the trail
from request to expense to asset stays intact.

## Technology used

**Backend**

- Node.js with Express, written as ES modules
- MySQL 8 accessed through the mysql2 driver with connection pooling
- JSON Web Tokens for authentication, bcrypt for password hashing
- Helmet for security headers, CORS with an explicit origin allowlist

**Frontend**

- React 19 built with Vite
- Recharts for all graphs and charts
- Lucide for icons
- Plain CSS with design tokens, no UI framework

**Data**

- 16 related tables with foreign keys, indexes and cascade rules
- Around 204 seeded records covering every module

## The modules

### Dashboard

The landing page after login. It calculates its numbers live from the database rather than
storing precomputed totals, so figures are always current.

It shows headline indicators across all modules, a revenue and expense trend area chart, a
donut chart breaking expenses down by category, a course enrollment chart, a feed of recent
request activity, and short written observations generated from the current data.

### Academic

Three connected areas.

**Students.** A searchable, filterable record of every enrolled student with their roll
number, programme, semester and GPA. Students whose GPA falls below 2.50 are flagged so they
can be followed up. Opening a student shows the courses they are enrolled in.

**Faculty.** The teaching staff directory, with each member's assigned credit hours shown
against the HEC standard threshold of 12 hours per week. Anyone above the threshold is
marked as overloaded, which makes it obvious at a glance who cannot take on another course.
Equipment currently issued to each member is listed on their record.

**Courses.** The course catalogue with a capacity meter for each offering, showing how full
it is against its seat limit. From here you can view the enrolled roster and enroll a
student, which writes to the database as a proper transaction so seat counts stay correct.

### Inventory

The register of physical assets: computers, lab equipment, projectors, networking hardware
and furniture, organised across seven categories.

Each item carries a condition tag of Good, Fair or Damaged, a quantity, a location and a
value. Items can be issued to a faculty member or to a lab, and the system keeps the custody
history so you can see who has had what and when it came back. Issuing and returning items
adjusts the available stock automatically.

### Requests

The approval workflow, and the module where the automated text analysis does the most work.

Anyone can submit a request. When they do, the text is analysed to work out what kind of
request it is (purchase, leave, maintenance or general), how urgent it is, and what
structured details it contains: what is being asked for, how many, why, and the likely cost.
A short summary is produced for whoever has to review it. The same analysis can run live as
the person types, so they see what the system understood before submitting.

Requests move through a defined set of states: Pending, then Under Review, and finally
Approved, Returned with Remarks, or Rejected. Every change is recorded with who made it and
when, and reviewers and submitters can leave comments on the thread.

The purchase workflow is where the modules connect. Approving a purchase request does three
things in one transaction: it marks the request approved, records the cost as an expense in
the finance module, and adds or increments the item in inventory. The records stay linked,
so an asset can be traced back to the request that bought it.

### Finance

Revenue and expenses for the department, kept in PKR with conversion available.

Revenue covers research grants, tuition allocations and other income. Expenses cover
operational spending by category. Both support full create, edit and delete operations.

On top of the ledgers the module tracks operating budget periods and revenue goals, and
calculates total revenue, total expenses, net balance, margin percentage, budget utilisation
and goal progress. A monthly trend chart and a category breakdown make the pattern visible
rather than leaving it in a table.

### Reports

Generates audit reports on demand across four areas: academic, financial, inventory and
requests.

A report is compiled from live database queries at the moment it is generated, then given a
written executive summary drawn from those same figures. The result opens in a printable
preview with the department seal, a verification stamp, an indicator grid and structured
data tables. Every generated report is archived so it can be opened again later.

### AI Assistant

A question and answer interface over the department's data.

The important detail is how it avoids making things up. A question is translated into a
specific SQL query, that query runs against the database, and the answer is built from the
rows that come back. If the data cannot answer the question, it says so rather than
inventing a plausible number.

Each answer displays a confidence indicator, the supporting rows the answer was built from,
and links through to the module where the underlying records live, so any claim can be
checked in a couple of clicks. Suggested questions are offered for people who are not sure
what to ask.

### Settings

Currency can be switched live between PKR, USD and EUR, with exchange rates applied across
every figure in the application. The institution and department names are configurable, and
user profile details persist immediately.

### System health

A diagnostics page, and two public endpoints behind it, reporting whether the API is running
and whether it can reach the database. Useful when something stops working and you need to
know which layer failed.

## User roles

Four roles, each seeing a different slice of the system.

| Role | What they can do |
| :--- | :--- |
| Administrator | Everything. Budget allocation, executive reports, full governance. |
| Officer | Review and approve requests, issue and receive equipment, record finance entries. |
| Faculty | Submit requests, view their workload, courses and assigned equipment. |
| Staff | Submit maintenance and lab requests, inspect assets. |

Permissions are enforced on the server through role guard middleware, not only hidden in the
interface, so a restricted user cannot reach a protected endpoint by calling it directly.

## The database

Sixteen tables, all in MySQL, with foreign keys and cascade rules that keep the data
consistent when records are removed.

| Area | Tables |
| :--- | :--- |
| Organisation | departments, users |
| Academic | students, faculty, courses, enrollments |
| Inventory | inventory, inventory_assignments |
| Requests | requests, request_history, request_comments |
| Finance | revenue, expenses, budgets, revenue_goals |
| Reporting | reports |

Money is stored as DECIMAL(12,2) rather than a floating point type, so totals do not drift.
States such as request status and asset condition are constrained at the database level
rather than left to application code.

The seed data includes 1 department, 6 users across all four roles, 30 students, 10 faculty
members, 12 courses, 30 enrollments, 22 inventory items, 6 assignments, 32 requests, 12
revenue entries, 24 expenses, 2 budget periods, 2 goals and 3 reports.

## Running it on your machine

### Before you start

- Node.js version 18 or later. Check with `node -v`.
- MySQL or MariaDB running on port 3306. XAMPP is the easiest way to get this on Windows.
- Git.

### Step 1: Get the code

```bash
git clone https://github.com/ImanAsmatMughal/CampusIQ.git
cd CampusIQ
```

### Step 2: Create your environment files

The repository includes `.env.example` templates with safe defaults. Copy them into place.
You need one in the project root and one in `backend/`.

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

Both files are ignored by Git and will never be committed. Keep it that way.

A point worth knowing: the application loads `backend/.env` first and the root `.env`
second, and it does not overwrite values that are already set. If the same variable appears
in both files, the one in `backend/.env` wins. Keep them in sync to avoid confusion.

### Step 3: Install dependencies

From the project root:

```bash
npm run install:all
```

This installs both the backend and the frontend. It takes a few minutes the first time.

### Step 4: Create and fill the database

Make sure MySQL is running, then:

```bash
npm run db:init
```

This connects to your MySQL server, creates the database if it does not exist, applies all
16 tables from `database/schema.sql`, and loads the demo data from `database/seed.sql`. It
prints every table with its record count when it finishes.

Running it again resets everything to a clean state, which is useful before a demo. To
reload only the data without rebuilding the tables, use `npm run db:seed`.

### Step 5: Start both servers

You need two terminals, one for each.

Terminal 1, the API:

```bash
npm run dev:backend
```

It runs on port 5000. Check `http://localhost:5000/api/health` to confirm it started, and
`http://localhost:5000/api/health/db` to confirm it reached the database.

Terminal 2, the web application:

```bash
npm run dev:frontend
```

It runs on port 5173. Open `http://localhost:5173` in a browser.

## Demo accounts

Every seeded account uses the password `Password123!`.

| Role | Email | Name |
| :--- | :--- | :--- |
| Administrator | admin@departmenthub.edu | Dr. Khurram Nadeem |
| Officer | officer@departmenthub.edu | Syed Muhammad Ali |
| Faculty | faculty@departmenthub.edu | Dr. Ayesha Khan |
| Staff | staff@departmenthub.edu | Muhammad Rizwan |

The login page has buttons that fill these in with one click, and you can switch roles from
the profile menu without logging out. There is no self registration in CampusIQ; accounts
come from the seed data.

## Available commands

Run these from the project root.

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
| `DB_SSL` | Set to `true` for a cloud database that requires TLS | `false` |
| `DB_SSL_CA` | The provider's CA certificate, when using TLS | unset |
| `DB_SSL_REJECT_UNAUTHORIZED` | Set to `false` to skip certificate verification | `true` |
| `DB_SKIP_CREATE` | Set to `true` when the provider creates the database for you | `false` |
| `DB_POOL_LIMIT` | Maximum pooled connections | `20` locally, `3` on serverless |
| `JWT_SECRET` | Secret used to sign login tokens | change this in production |
| `JWT_EXPIRES_IN` | How long a session lasts | `7d` |
| `CLIENT_URL` | Comma separated list of browser origins allowed to call the API | `http://localhost:5173` |
| `ALLOW_VERCEL_PREVIEWS` | Allows Vercel preview deployments through CORS | `false` |
| `SERVE_CLIENT` | Serves the built frontend from the API process | `false` |
| `GEMINI_API_KEY` | Optional. Without it the built in engine is used | unset |
| `MIGRATION_SECRET` | Enables the protected migration endpoints. Leave unset normally | unset |

Never commit real values. Add any new variable to both `.env.example` files with an
explanation so the rest of the team knows it exists.

## Deploying to the web

The application needs a MySQL database that is reachable from the internet, so a local XAMPP
installation cannot be used for a deployed site.

### Database

Any managed MySQL 8 service works. The schema and seed files run without modification. Set
`DB_SSL=true`, and either paste the provider's certificate into `DB_SSL_CA` or set
`DB_SSL_REJECT_UNAUTHORIZED=false`. If the provider creates the database for you, set
`DB_SKIP_CREATE=true` so the schema's own CREATE DATABASE statement is skipped.

Load the schema and data by pointing `npm run db:init` at the cloud database from your own
machine, with the connection details set as environment variables in your terminal session.

### Hosting

The repository includes `vercel.json`, which deploys the frontend and the API together as
one Vercel project using Vercel Services. The frontend is served at the root and the API at
`/api`, both on the same domain, which means no cross origin configuration is needed. Set
`VITE_API_URL=/api` so the frontend calls its own domain.

For this to work, the project's Root Directory setting must be empty, so that Vercel reads
`vercel.json` from the repository root.

`render.yaml` is also included as an alternative. It describes a single Render service that
serves the API and the built frontend together using `SERVE_CLIENT=true`.

If you host the frontend and the API separately instead, set `VITE_API_URL` on the frontend
to the API's full address ending in `/api`, and set `CLIENT_URL` on the API to the
frontend's address with no trailing slash. Both need a rebuild after changing, because
`VITE_API_URL` is compiled into the JavaScript bundle at build time.

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
| GET | `/api/inventory/:id` | One asset with its custody history | Authenticated |
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
| POST | `/api/ai/query` | Ask a question, get an answer plus its source rows | Authenticated |

### Administration

These exist for hosting platforms that give you no shell to run the setup scripts. They do
nothing unless `MIGRATION_SECRET` is set, and they require that value in an
`x-migration-secret` header. Leave the variable unset in normal operation.

| Method | Path | Description |
| :--- | :--- | :--- |
| POST | `/api/admin/migrate?confirm=reset` | Rebuilds every table and reloads the seed data. Destructive. |
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

**The API cannot connect to the database.** Confirm MySQL is running. In XAMPP, the MySQL
row should show a green indicator. Then check that `DB_HOST`, `DB_PORT`, `DB_USER` and
`DB_PASSWORD` in `backend/.env` match your MySQL setup. Remember that `backend/.env`
overrides the root `.env`.

**`getaddrinfo ENOTFOUND` with a cloud database.** The hostname does not resolve. Either it
is mistyped, or the database service is stopped. Many free tier providers power a service
down after a period of inactivity, which removes its DNS record. Check the service is
running in your provider's console.

**Unknown database, or the tables are empty.** Run `npm run db:init`.

**Port 5000 or 5173 already in use.** Change `PORT` in `backend/.env`, or start Vite with
`--port 5174`.

**`vite is not recognized`.** The frontend dependencies are missing. Run
`npm install --prefix frontend`.

**A deployed site shows a CORS error on login.** The API's `CLIENT_URL` does not include the
frontend's address, or the API was not redeployed after the value changed.

**A deployed site returns HTML where JSON was expected.** `VITE_API_URL` points at an
address with no API on it. It must end in `/api` and have no trailing slash, and the
frontend must be rebuilt after any change.

**MySQL will not start in XAMPP.** Usually another MySQL service is already holding port
3306. On Windows, find it with `netstat -ano | findstr :3306`.

## Contributing

**Protect secrets.** Never put passwords, keys or tokens in code. Read them from
`process.env`. When you add a variable, document it in both `.env.example` files.

**Work on a branch.** Create one with `git checkout -b feature/your-feature-name`, confirm
that `npm run db:init` and both dev servers still work, then open a pull request against
`main`.

**Keep the schema shared.** If you change a table or a relationship, update
`database/schema.sql` and `database/seed.sql` in the same commit, so your teammates get the
change when they next run `npm run db:init`.

## License

Built for academic departments and faculty governance.
