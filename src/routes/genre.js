const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const {
  adminAuthMiddleware,
  authMiddleware,
} = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get all genres
router.get("/", authMiddleware, async (req, res) => {
  const { rows } = await db.query("SELECT * FROM genre ORDER BY genre_name");
  res.status(200).json(rows);
});

// Add new genre
router.post("/", adminAuthMiddleware, async (req, res) => {
  const { genre_name } = req.body;
  try {
    // Check if genre with the given genre_name already exists
    const { rows } = await db.query(
      "SELECT 1 FROM genre WHERE genre_name = $1::VARCHAR",
      [genre_name]
    );
    if (rows[0]) {
      res.status(409).json({
        error: `The genre with the given genre_name already exists`,
      });
    } else {
      const { rows } = await db.query(
        "CALL add_genre($1::VARCHAR, $2::INTEGER)",
        [genre_name, 1],
        req.tokenPayload.admin_id,
        true
      );
      res.status(200).json({ genre_id: rows[0].p_genre_id });
    }
  } catch {
    (err) => {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while adding the genre." });
    };
  }
});
