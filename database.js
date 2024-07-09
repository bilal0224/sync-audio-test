const mysql = require('mysql2');

module.exports = function createConnectionPool(config) {
  const pool = mysql.createPool({
    host: config.host || process.env.DB_HOST,
    user: config.user || process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  });

  return {
    query: async function(sql, values) {
      const [rows, fields] = await pool.promise().query(sql, values);
      return rows;
    }
  };
};

