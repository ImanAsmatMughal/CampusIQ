import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import { buildSslOptions } from './sslConfig.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables from backend/.env or root .env
dotenv.config({ path: path.resolve(__dirname, '../../.env') });
dotenv.config({ path: path.resolve(__dirname, '../../../.env') });



const sslOptions = buildSslOptions();

const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306', 10),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : '',
  database: process.env.DB_NAME || 'campusiq_db',
  waitForConnections: true,
  connectionLimit: 20,
  maxIdle: 10,
  idleTimeout: 30000,
  connectTimeout: 10000,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
  charset: 'utf8mb4',
  ...sslOptions
};

export const pool = mysql.createPool(dbConfig);

// Pool-level error safety to prevent uncaught socket terminations
pool.on('error', (err) => {
  console.error('[MySQL Pool Error]', err.message);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    console.warn('[MySQL] Connection lost. Will re-establish on next incoming query.');
  }
});

/**
 * Test database connection and return status/version
 */
export async function testConnection() {
  try {
    const connection = await pool.getConnection();
    const [rows] = await connection.query('SELECT 1 as connected, VERSION() as version, DATABASE() as current_db');
    connection.release();
    return {
      success: true,
      data: rows[0],
      message: 'Database connection established successfully.'
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      code: error.code,
      message: `Failed to connect to MySQL database at ${dbConfig.host}:${dbConfig.port} (Database: ${dbConfig.database}).\n` +
               `Tip for teammates: Ensure XAMPP MySQL is running, copy .env.example to .env, and run 'npm run db:init'.`
    };
  }
}

export default pool;
