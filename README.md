# CampusIQ — AI-Powered Academic & Department Intelligence Platform

> **Comprehensive Department Management & Intelligence Platform**  
> Centralized workspace for managing academic curricula, faculty workloads, physical asset inventory, operational requests, financial budgets, and automated audit reports with an integrated, zero-hallucination Grounded AI intelligence layer.

---

## 🌟 Key Capabilities & Architecture

1. **🇵🇰 Regional Localization & Multi-Currency System**:
   - **Default Currency**: Pakistani Rupee (`PKR` / `Rs.`) configured across all metrics, transaction ledgers, budget charts, and valuation figures.
   - **Interactive Settings Studio**: Accessible via the gear icon on the top-right header, allowing live switching between **PKR (Rs.)**, **USD ($)**, and **EUR (€)** with real-time exchange rate calculation.
   - **Institution & Department Customization**: Configurable University and Department metadata (e.g. *NUST*, *FAST-NUCES*, *Punjab University*, *QAU*).

2. **📌 Fixed-Sidebar Viewport Layout & Dynamic 2-per-row Rearrangeable Cards**:
   - Sticky, non-scrolling left navigation sidebar locked to the screen viewport height (`100vh`).
   - Main page workspace scrolls smoothly and independently with a persistent top navigation bar.
   - Interactive Executive Dashboard with 2-cards-per-row grid layout and dedicated top-right drag handles.

3. **👥 Authentic Regional Dataset & Personalized User Profiles**:
   - Pre-seeded with authentic Pakistani faculty, administrative staff, student roll numbers (`2023-CS-041`), courses, and realistic financial figures in PKR.
   - Dedicated User Profile and Department Profile customization settings with instant persistence.

4. **🎓 Academic & Curriculum Management**:
   - Track students, GPA distributions, and academic standing watchlist.
   - Monitor faculty credit-hour workloads with safety threshold warnings ($\ge 12$ credit hours/week).
   - Real-time course capacity utilization and database-backed student enrollment roster.

5. **📦 Operations & Physical Asset Inventory**:
   - Hardware, lab equipment, computing nodes, and projectors with condition tags (`Good`, `Fair`, `Damaged`).
   - Dynamic asset assignment tracking (custody history by faculty member or lab location) with automated return workflows.

6. **📝 Requests & Approval Workflow with AI Extraction**:
   - Multi-role approval pipeline (`Pending` → `Under Review` → `Approved` / `Returned` / `Rejected`).
   - Instant NLP text analysis: automatically classifies request type, priority, and extracts structured JSON parameters (items, quantities, dates, budget requirements).
   - **Connected Purchase Workflow**: Approving equipment purchase atomically records an expense entry and adds the asset into physical inventory.

7. **💰 Financial & Budget Management**:
   - Real-time tracking of research grants, tuition allocations, and operational expense ledgers.
   - Budget period utilization, revenue goal progress indicators, and interactive monthly trend charts.

8. **🤖 Grounded AI Intelligence Assistant**:
   - Zero-hallucination natural language Q&A engine executing deterministic SQL queries against local MySQL database (`campusiq_db` / `departmenthub_db`).
   - Displays real-time grounding verification badges, confidence scores, supporting SQL data rows, and direct module navigation links.

9. **📄 Verified Management Reports & PDF Generator**:
   - Instant 1-click generation of verified Academic, Financial, Inventory, and Procurement audit reports.
   - Synthesizes grounded AI executive summaries with interactive printable preview and PDF export.

---

## 👥 Contributor & Team Quickstart Guide

Welcome to the **CampusIQ** development team! Follow these instructions to set up your local development environment after cloning the repository.

### 📋 Prerequisites
- **Node.js**: `v18.0.0+` or `v20.x` / `v22.x` (check via `node -v`)
- **XAMPP / MySQL**: MySQL or MariaDB running on local port `3306` (start via XAMPP Control Panel)
- **Git**: Installed and configured

---

### 🚀 Step-by-Step Setup

#### Step 1: Clone Repository
```bash
git clone https://github.com/Waleed2412/CampusIQ.v2.git
cd CampusIQ.v2
```

#### Step 2: Set Up Local Environment Files (`.env`)
The repository contains base templates (`.env.example`) with safe defaults. Copy the template to `.env` in both the project root and the `backend/` folder:

**On Windows (Command Prompt):**
```cmd
copy .env.example .env
copy backend\.env.example backend\.env
```

**On Windows (PowerShell):**
```powershell
Copy-Item .env.example .env
Copy-Item backend/.env.example backend/.env
```

**On macOS / Linux / Git Bash:**
```bash
cp .env.example .env
cp backend/.env.example backend/.env
```

> ⚠️ **Security Notice**: `.env` files contain local secrets and are automatically ignored by `.gitignore`. **Never commit or push `.env` files to GitHub.**

---

#### Step 3: Install All Dependencies
Install backend and frontend dependencies in one command from the project root:
```bash
npm run install:all
```
*(Alternatively: `cd backend && npm install`, then `cd ../frontend && npm install`)*

---

#### Step 4: Initialize & Seed MySQL Database
Ensure **MySQL is running in your XAMPP Control Panel**, then run:
```bash
npm run db:init
```

**What this does automatically:**
1. Connects to your local MySQL server on `localhost:3306`.
2. Creates the database (`campusiq_db` / `departmenthub_db`) if it doesn't already exist.
3. Applies all 16 relational tables with foreign keys and indexes from `database/schema.sql`.
4. Seeds 200+ realistic Pakistani records (users, faculty, courses, students, budgets, assets) from `database/seed.sql`.

> 💡 **Tip:** If you ever need to reset the database back to clean demo data, simply run `npm run db:seed`.

---

#### Step 5: Start Development Servers
Open two terminal windows:

**Terminal 1 (Backend API Server - Port 5000):**
```bash
npm run dev:backend
# API running at: http://localhost:5000
# Health Check:    http://localhost:5000/api/health
# DB Diagnostics:  http://localhost:5000/api/health/db
```

**Terminal 2 (Frontend Client - Port 5173):**
```bash
npm run dev:frontend
# Web application will open at: http://localhost:5173
```

---

## 🔑 Demo Login Accounts

All pre-seeded test accounts use the standard password: **`Password123!`**

| Role | Email | Name | Access Level |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@departmenthub.edu` | **Dr. Khurram Nadeem** | Full governance, budget allocation, executive reports |
| **Officer / Manager** | `officer@departmenthub.edu` | **Syed Muhammad Ali** | Review & approve requests, asset check-in/out, expenses |
| **Faculty Member** | `faculty@departmenthub.edu` | **Dr. Ayesha Khan** | Submit requests, view workloads, courses, assigned assets |
| **Staff Member** | `staff@departmenthub.edu` | **Muhammad Rizwan** | Hardware maintenance, lab requests, asset inspection |

> 🔄 **Instant Role Switching:** You can switch between demo accounts with 1 click using the profile menu on the top-right of the navigation bar.

---

## 🛠️ Available NPM Scripts

Run these scripts from the repository root:

| Command | Description |
| :--- | :--- |
| `npm run install:all` | Installs dependencies for both `backend` and `frontend` |
| `npm run db:init` | Creates database, applies schema, and seeds all demo data |
| `npm run db:seed` | Re-seeds database with fresh Pakistani demo records |
| `npm run dev:backend` | Starts the Express API server in development mode (port 5000) |
| `npm run dev:frontend` | Starts Vite React dev server with Hot Module Reload (port 5173) |
| `npm run start:backend` | Starts the production Node.js server |

---

## 🛡️ Git & Contribution Guidelines

1. **Keep Secrets Safe**:
   - Never put plain-text passwords, private keys, or API tokens directly into code files.
   - Always load sensitive configurations through `process.env`.
   - If you introduce a new environment variable, add it with a placeholder explanation to `.env.example` and `backend/.env.example`.

2. **Branching & Pull Requests**:
   - Create a feature branch for your work: `git checkout -b feature/your-feature-name`
   - Verify that both `npm run db:init` and `npm run dev` work cleanly before pushing.
   - Submit a Pull Request targeting `main`.

3. **Database Migrations**:
   - If you modify table columns or add relations, update `database/schema.sql` and `database/seed.sql` so your teammates receive the updated schema when running `npm run db:init`.

---

## 🔧 Troubleshooting & FAQ

<details>
<summary><b>1. Error: "Failed to connect to MySQL database at localhost:3306"</b></summary>

- **Cause**: MySQL service is not running or credentials in `.env` are mismatched.
- **Fix**:
  1. Open the **XAMPP Control Panel** and ensure the **MySQL** module is started (green indicator).
  2. Verify that `DB_PORT=3306`, `DB_USER=root`, and `DB_PASSWORD=` match your local MySQL settings in `.env`.
</details>

<details>
<summary><b>2. Error: "Unknown database 'campusiq_db'" or empty tables</b></summary>

- **Fix**: Run `npm run db:init` from the root directory to automatically create and populate the database.
</details>

<details>
<summary><b>3. Port 5000 or Port 5173 is already in use</b></summary>

- **Fix**: Change `PORT=5001` in your `backend/.env` or specify `--port 5174` in `frontend/package.json`.
</details>

---

## 📡 API Endpoints Summary

| Category | Method & Path | Description | Access |
| :--- | :--- | :--- | :--- |
| **System** | `GET /api/health` | Server runtime status, uptime & environment | Public |
| **System** | `GET /api/health/db` | Real-time MySQL connection latency & table metrics | Public |
| **Auth** | `POST /api/auth/login` | Authenticate user & issue JWT token | Public |
| **Auth** | `GET /api/auth/me` | Retrieve current authenticated user profile | Authenticated |
| **Dashboard** | `GET /api/dashboard/stats` | Aggregated KPIs, charts, insights & recent feeds | Authenticated |
| **Academic** | `GET /api/students` | Search and filter student records & GPAs | Authenticated |
| **Academic** | `GET /api/faculty` | Faculty directory, teaching hours & workload status | Authenticated |
| **Academic** | `GET /api/courses` | Course catalog, capacity meters & enrolled rosters | Authenticated |
| **Academic** | `POST /api/courses/enroll` | Enroll a student into an active course offering | Officer / Admin |
| **Inventory** | `GET /api/inventory` | Hardware & physical asset registry with filters | Authenticated |
| **Inventory** | `POST /api/inventory` | Create new inventory asset | Officer / Admin |
| **Inventory** | `POST /api/inventory/:id/assign` | Assign equipment to faculty or lab location | Officer / Admin |
| **Inventory** | `POST /api/inventory/assignments/:id/return` | Mark assigned asset as returned to stock | Officer / Admin |
| **Requests** | `GET /api/requests` | List operational & procurement requests | Authenticated |
| **Requests** | `POST /api/requests` | Submit request (triggers automated AI extraction) | Authenticated |
| **Requests** | `POST /api/requests/analyze` | Live interactive AI text classification & JSON preview | Authenticated |
| **Requests** | `POST /api/requests/:id/status` | Approve, Return with Remarks, or Reject request | Officer / Admin |
| **Finance** | `GET /api/finance/overview` | Revenue, expenses, net surplus, budget utilization | Officer / Admin |
| **Finance** | `POST /api/finance/revenue` | Record external grant or income entry | Officer / Admin |
| **Finance** | `POST /api/finance/expenses` | Record operational expense item | Officer / Admin |
| **Finance** | `POST /api/finance/budgets` | Allocate new operating budget period | Officer / Admin |
| **AI Assistant** | `GET /api/ai/suggestions` | Suggested natural language database queries | Authenticated |
| **AI Assistant** | `POST /api/ai/query` | Grounded SQL execution with data verification | Authenticated |
| **Reports** | `GET /api/reports` | List historical generated reports archive | Officer / Admin |
| **Reports** | `POST /api/reports/generate` | Synthesize live report with AI summary & printable export | Officer / Admin |

---

## 📁 Project Directory Structure

```
/CampusIQ.v2
├── backend/
│   ├── src/
│   │   ├── controllers/      # Academic, inventory, requests, finance, reports, ai
│   │   ├── routes/           # Express REST route definitions
│   │   ├── services/         # Business logic, NLP parsing & grounded SQL engine
│   │   ├── middleware/       # JWT authentication, RBAC role guards, error handlers
│   │   ├── db/               # MySQL connection pool, initDb & seedDb runners
│   │   ├── app.js            # Express app configuration & middleware
│   │   └── server.js         # HTTP server entry point
│   ├── .env.example          # Backend environment variables template
│   └── package.json
├── frontend/
│   ├── src/
│   │   ├── components/       # Reusable UI components & SettingsModal
│   │   ├── context/          # AuthContext & SettingsContext (Currency, Regional configs)
│   │   ├── layouts/          # AppLayout shell (Fixed sticky sidebar, Header, Nav)
│   │   ├── pages/            # Dashboard, Academic, Inventory, Requests, Finance, Reports, AI, Health
│   │   ├── services/         # Axios API client with timeout protection
│   │   ├── App.jsx           # Lazy-loaded routes & global providers
│   │   ├── main.jsx          # React DOM entry point
│   │   └── index.css         # Design system tokens & typography
│   ├── package.json
│   └── vite.config.js        # Optimized vendor chunking configuration
├── database/
│   ├── schema.sql            # Full MySQL schema (16 tables, constraints, indexes)
│   └── seed.sql              # Realistic Pakistani dataset (200+ records)
├── docs/
│   ├── PRD.md
│   └── API_NOTES.md
├── .env.example              # Root environment template
├── .gitignore                # Production & team safe gitignore
├── DEVELOPMENT_STATUS.md     # Development milestone verification tracker
└── README.md                 # Complete documentation & team quickstart guide
```

---

## 📜 License & Collaboration
Built with ❤️ for academic institutions, higher education departments, and faculty governance.
