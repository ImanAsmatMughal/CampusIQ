import 'dotenv/config';
import express from 'express';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import healthRoutes from './routes/healthRoutes.js';
import authRoutes from './routes/authRoutes.js';
import dashboardRoutes from './routes/dashboardRoutes.js';
import academicRoutes from './routes/academicRoutes.js';
import inventoryRoutes from './routes/inventoryRoutes.js';
import requestRoutes from './routes/requestRoutes.js';
import financeRoutes from './routes/financeRoutes.js';
import reportRoutes from './routes/reportRoutes.js';
import aiAssistantRoutes from './routes/aiAssistantRoutes.js';
import adminRoutes from './routes/adminRoutes.js';
import { errorHandler, notFoundHandler } from './middleware/errorHandler.js';

const app = express();

// Security and utility middleware
app.use(helmet({ contentSecurityPolicy: process.env.SERVE_CLIENT === 'true' ? false : undefined }));
// CLIENT_URL accepts a comma-separated allowlist so local dev, the deployed
// frontend and preview deployments can all talk to this API.
const allowedOrigins = (process.env.CLIENT_URL || 'http://localhost:5173,http://127.0.0.1:5173')
  .split(',')
  .map((o) => o.trim().replace(/\/$/, ''))
  .filter(Boolean);

app.use(cors({
  origin(origin, callback) {
    // Allow server-to-server / curl / health probes with no Origin header
    if (!origin) return callback(null, true);
    const clean = origin.replace(/\/$/, '');
    if (allowedOrigins.includes(clean)) return callback(null, true);
    if (process.env.ALLOW_VERCEL_PREVIEWS === 'true' && /\.vercel\.app$/.test(new URL(clean).hostname)) {
      return callback(null, true);
    }
    return callback(new Error(`Origin ${origin} is not allowed by CORS`));
  },
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

if (process.env.NODE_ENV !== 'test') {
  app.use(morgan('dev'));
}

// Root route so platform health probes get a 200.
// Skipped when SERVE_CLIENT is on, so that '/' serves the React app instead.
if (process.env.SERVE_CLIENT !== 'true') {
  app.get('/', (req, res) => {
    res.json({ service: 'CampusIQ API', status: 'ok', docs: '/api/health' });
  });
}

// API Routes
app.use('/api/health', healthRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/academic', academicRoutes);
app.use('/api/inventory', inventoryRoutes);
app.use('/api/requests', requestRoutes);
app.use('/api/finance', financeRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/ai', aiAssistantRoutes);
app.use('/api/admin', adminRoutes);

// Optional: serve the built React app from this same service (single-URL deploy).
// Set SERVE_CLIENT=true and make sure frontend/dist exists in the image.
const __dirname_app = path.dirname(fileURLToPath(import.meta.url));
const clientDist = path.resolve(__dirname_app, '../../frontend/dist');
if (process.env.SERVE_CLIENT === 'true' && fs.existsSync(clientDist)) {
  app.use(express.static(clientDist));
  app.get(/^(?!\/api).*/, (req, res) => {
    res.sendFile(path.join(clientDist, 'index.html'));
  });
}

// Fallback & Error Handling
app.use(notFoundHandler);
app.use(errorHandler);

export default app;

