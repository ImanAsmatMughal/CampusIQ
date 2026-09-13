/**
 * TLS options for cloud MySQL providers (Aiven, TiDB Cloud, PlanetScale, Azure).
 *
 *   DB_SSL=true                     -> enable TLS
 *   DB_SSL_CA="-----BEGIN CERT..."  -> provider CA certificate (preferred, verifies the server)
 *   DB_SSL_REJECT_UNAUTHORIZED=false-> accept the provider cert without verifying it
 *                                      (use only if you have not supplied DB_SSL_CA)
 *
 * Local XAMPP / MariaDB needs none of this - leave DB_SSL unset.
 */
export function buildSslOptions() {
  if (String(process.env.DB_SSL || '').toLowerCase() !== 'true') return {};

  const ssl = { minVersion: 'TLSv1.2' };

  const ca = process.env.DB_SSL_CA;
  if (ca && ca.trim()) {
    // Allow the PEM to be supplied with literal \n escapes (common in dashboards)
    ssl.ca = ca.includes('\\n') ? ca.replace(/\\n/g, '\n') : ca;
    ssl.rejectUnauthorized = true;
  } else {
    ssl.rejectUnauthorized =
      String(process.env.DB_SSL_REJECT_UNAUTHORIZED || 'true').toLowerCase() !== 'false';
  }

  return { ssl };
}

export default buildSslOptions;
