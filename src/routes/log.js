const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
module.exports = router;
const { adminAuthMiddleware } = require("../Middleware/security/authMiddlware");

// Get the user logs
router.get("/:id/:admin", adminAuthMiddleware, async (req, res) => {
  const { id, admin } = req.params;
  const { rows } = await db.query(
    "SELECT * FROM processing_history WHERE id = $1 AND admin = $2 ORDER BY timestamp ASC LIMIT 10",
    [id, admin]
  );
  res.status(200).json(rows);
});

// Get all the user logs
router.get("/", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query(
    "SELECT * FROM processing_history ORDER BY id ASC, timestamp ASC"
  );
  res.status(200).json(rows);
});
