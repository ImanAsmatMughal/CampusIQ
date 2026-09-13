import express from 'express';
import { initializeDatabase } from '../db/initDb.js';
import { seedDatabase } from '../db/seedDb.js';

const router = express.Router();

/**
 * These endpoints exist because managed hosts (Render free tier, serverless
 * platforms) give you no shell to run `npm run db:init` against the cloud
 * database. They are inert unless MIGRATION_SECRET is set, and both require
 * that secret in the x-migration-secret header.
 *
 * Once the database is live, unset MIGRATION_SECRET to disable them entirely.
 */
function requireMigrationSecret(req, res, next) {
  const secret = process.env.MIGRATION_SECRET;
  if (!secret) {
    return res.status(403).json({
      success: false,
      message: 'Migration endpoints are disabled. Set MIGRATION_SECRET to enable them.'
    });
  }
  const provided = req.get('x-migration-secret');
  if (!provided || provided !== secret) {
    return res.status(401).json({
      success: false,
      message: 'Missing or invalid x-migration-secret header.'
    });
  }
  return next();
}

/**
 * POST /api/admin/migrate?confirm=reset
 * DESTRUCTIVE. Drops and recreates every table from database/schema.sql,
 * then loads database/seed.sql.
 */
router.post('/migrate', requireMigrationSecret, async (req, res) => {
  const confirm = req.query.confirm || req.body?.confirm;
  if (confirm !== 'reset') {
    return res.status(400).json({
      success: false,
      message: 'This drops every existing table. Re-send with ?confirm=reset to proceed.'
    });
  }

  try {
    const result = await initializeDatabase();
    if (!result?.success) {
      return res.status(500).json({ success: false, message: 'Migration failed.', error: result?.error });
    }
    return res.json({
      success: true,
      message: `Schema applied and seed data loaded (${result.tables} tables).`,
      tables: result.tables
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: 'Migration failed.', error: error.message });
  }
});

/**
 * POST /api/admin/seed
 * Re-loads database/seed.sql only. Assumes the schema already exists.
 */
router.post('/seed', requireMigrationSecret, async (req, res) => {
  try {
    const result = await seedDatabase();
    if (!result?.success) {
      return res.status(500).json({ success: false, message: 'Seeding failed.', error: result?.error });
    }
    return res.json({ success: true, message: 'Demo dataset reloaded.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: 'Seeding failed.', error: error.message });
  }
});

export default router;
