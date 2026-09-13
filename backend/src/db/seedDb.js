import mysql from 'mysql2/promise';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';
import { buildSslOptions } from './sslConfig.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
dotenv.config({ path: path.resolve(__dirname, '../../.env') });
dotenv.config({ path: path.resolve(__dirname, '../../../.env') });

const dbHost = process.env.DB_HOST || 'localhost';
const dbPort = parseInt(process.env.DB_PORT || '3306', 10);
const dbUser = process.env.DB_USER || 'root';
const dbPassword = process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '';
const dbName = process.env.DB_NAME || 'campusiq_db';
const sslOptions = buildSslOptions();

export async function seedDatabase() {
  console.log('====================================================');
  console.log('🌱 CampusIQ Database Re-Seeding');
  console.log(`   Target Server : ${dbUser}@${dbHost}:${dbPort}`);
  console.log(`   Database Name : ${dbName}`);
  console.log('====================================================');

  let connection;
  try {
    connection = await mysql.createConnection({
      host: dbHost,
      port: dbPort,
      user: dbUser,
      password: dbPassword,
      database: dbName,
      multipleStatements: true,
      ...sslOptions
    });

    const seedPath = path.resolve(__dirname, '../../../database/seed.sql');
    if (!fs.existsSync(seedPath)) {
      throw new Error(
        `Seed SQL file not found at: ${seedPath}. ` +
        'On Vercel the database/ folder sits outside the deployed root directory, so ' +
        'these endpoints cannot seed. Run "npm run db:seed" from your own machine instead.'
      );
    }

    let seedSql = fs.readFileSync(seedPath, 'utf8');
    seedSql = seedSql.replace(/USE `?[a-zA-Z0-9_]+`?;/gi, `USE \`${dbName}\`;`);

    await connection.query(seedSql);

    console.log('✔ CampusIQ database re-seeded successfully with fresh demo dataset!');
    return { success: true };
  } catch (error) {
    console.error('✖ Database seed failed:', error.message);
    console.error('\nTip for teammates:');
    console.error('  1. Ensure the database has been initialized first via "npm run db:init".');
    console.error('  2. Verify your MySQL credentials in .env.\n');
    return { success: false, error: error.message };
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  seedDatabase().then((result) => {
    if (!result || !result.success) process.exitCode = 1;
  });
}
