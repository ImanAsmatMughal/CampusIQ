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
const skipCreate = String(process.env.DB_SKIP_CREATE || '').toLowerCase() === 'true';

export async function initializeDatabase() {
  console.log('====================================================');
  console.log('🏛️  CampusIQ Database Initialization');
  console.log(`   Target Server : ${dbUser}@${dbHost}:${dbPort}`);
  console.log(`   Database Name : ${dbName}`);
  console.log('====================================================');

  let connection;
  try {
    // 1. Connect without selecting database to guarantee creation
    connection = await mysql.createConnection({
      host: dbHost,
      port: dbPort,
      user: dbUser,
      password: dbPassword,
      multipleStatements: true,
      ...sslOptions
    });

    console.log('[1/4] Connected to MySQL server successfully.');

    // 2. Create and select target database
    if (!skipCreate) {
      await connection.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`);
    }
    await connection.query(`USE \`${dbName}\`;`);
    console.log(`[2/4] Database '${dbName}' created/verified.`);

    // 3. Execute schema.sql (dynamically ensuring active dbName is used)
    const schemaPath = path.resolve(__dirname, '../../../database/schema.sql');
    if (!fs.existsSync(schemaPath)) {
      throw new Error(`Schema file not found at: ${schemaPath}`);
    }
    let schemaSql = fs.readFileSync(schemaPath, 'utf8');
    // Replace any legacy hardcoded database references with active dbName
    schemaSql = schemaSql.replace(/CREATE DATABASE IF NOT EXISTS `?[a-zA-Z0-9_]+`?[\s\S]*?;/i, skipCreate ? '' : `CREATE DATABASE IF NOT EXISTS \`${dbName}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`);
    schemaSql = schemaSql.replace(/USE `?[a-zA-Z0-9_]+`?;/gi, `USE \`${dbName}\`;`);

    await connection.query(schemaSql);
    console.log('[3/4] Schema tables and constraints applied from database/schema.sql');

    // 4. Execute seed.sql
    const seedPath = path.resolve(__dirname, '../../../database/seed.sql');
    if (!fs.existsSync(seedPath)) {
      throw new Error(`Seed file not found at: ${seedPath}`);
    }
    let seedSql = fs.readFileSync(seedPath, 'utf8');
    seedSql = seedSql.replace(/USE `?[a-zA-Z0-9_]+`?;/gi, `USE \`${dbName}\`;`);

    await connection.query(seedSql);
    console.log('[4/4] Seed dataset inserted successfully from database/seed.sql');

    // Verify created tables
    const [tables] = await connection.query('SHOW TABLES');
    console.log('\n--- Database Summary ---');
    console.log(`Total Tables Created: ${tables.length}`);
    for (const tableObj of tables) {
      const tableName = Object.values(tableObj)[0];
      const [[{ count }]] = await connection.query(`SELECT COUNT(*) as count FROM \`${tableName}\``);
      console.log(` - ${tableName.padEnd(25)}: ${count} records`);
    }

    console.log('\n✔ CampusIQ database setup and seeding completed successfully!\n');
    return { success: true, tables: tables.length };
  } catch (error) {
    console.error('\n✖ Database initialization failed:', error.message);
    console.error('\nTip for teammates:');
    console.error('  1. Ensure XAMPP MySQL (or local MariaDB) is started.');
    console.error('  2. Verify your .env configuration (copy .env.example to .env).');
    console.error('  3. Check that DB_USER and DB_PASSWORD match your local MySQL credentials.\n');
    return { success: false, error: error.message };
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

// Run directly if invoked from CLI
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  initializeDatabase().then((result) => {
    if (!result || !result.success) process.exitCode = 1;
  });
}
