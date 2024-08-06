const { Pool } = require("pg");
const dotenv = require("dotenv");
dotenv.config();

const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
  max: 20,
});

module.exports = {
  async query(text, params, id, admin, get_item) {
    const start = Date.now();
    const res = await pool.query(text, params);
    const duration = Date.now() - start;
    if (id !== undefined) {
      // Save the query in the database
      if (get_item && !admin && res.rowCount > 0) {
        // Save the query in the access_log
        await pool.query(
          "INSERT INTO access_item_history (user_id, item_id) VALUES ($1::INTEGER, $2::INTEGER)",
          [id, params[0]]
        );
        const res = await pool.query(
          "SELECT COUNT(*) FROM access_item_history WHERE user_id = $1",
          [id]
        );
        if (res.rows[0].count > 10) {
          await pool.query(
            
            "DELETE FROM access_item_history WHERE user_id = $1 AND timestamp = ( SELECT timestamp FROM access_item_history WHERE user_id = $1 ORDER BY timestamp ASC LIMIT 1)",
            [id]
          );
        }
      } else {
        // Save the query in the processing_history
        const queryParams = JSON.stringify({ params });
        await pool.query(
          "INSERT INTO processing_history (id, admin, executed_query, query_params, query_duration) VALUES ($1::INTEGER, $2::BOOLEAN, $3::TEXT, $4::JSONB, $5::INT)",
          [id, admin, text, queryParams, duration]
        );
        const res = await pool.query(
          "SELECT COUNT(*) FROM processing_history WHERE id = $1 AND admin = $2",
          [id, admin]
        );
        if (res.rows[0].count > 10) {
          await pool.query(
            "DELETE FROM processing_history WHERE id = $1 AND admin = $2 AND timestamp = ( SELECT timestamp FROM processing_history WHERE id = $1 AND admin = $2 ORDER BY timestamp ASC LIMIT 1 )",
            [id, admin]
          );
        }
      }
    }
    console.log("executed query", {
      text,
      duration,
      params,
      rows: res.rowCount,
      id,
      admin,
    });
    return res;
  },

  async getClient() {
    const client = await pool.connect();
    const query = client.query;
    const release = client.release;

    const timeout = setTimeout(() => {
      console.error("A client has been checked out for more than 5 seconds!");
      console.error(
        `The last executed query on this client was: ${client.lastQuery}`
      );
    }, 5000);

    client.query = (...args) => {
      client.lastQuery = args;
      return query.apply(client, args);
    };
    client.release = () => {
      clearTimeout(timeout);

      client.query = query;
      client.release = release;
      return release.apply(client);
    };
    return client;
  },
};
