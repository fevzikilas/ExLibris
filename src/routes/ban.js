const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const { adminAuthMiddleware } = require("../Middleware/security/authMiddlware");

module.exports = router;

// Ban an user
router.post("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  const { admin_id } = req.tokenPayload;
  const { report } = req.body;
  try {
    // Check if user with the given id_number is already banned
    const { rows } = await db.query(
      "SELECT banned FROM user_account WHERE user_id = $1",
      [id]
    );

    if (rows[0].banned) {
      // User is already banned
      res.status(409).json({
        error: "User is already banned.",
      });
    } else {
      await db.query(
        "CALL add_banned_user($1::INTEGER, $2::INTEGER, $3::VARCHAR)",
        [id, admin_id, report],
        req.tokenPayload.admin_id,
        true
      );
      res.status(200).json({ user_id: id });
    }
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while banning the user." });
  }
});

// Unban an user
router.delete("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    // Check if user with the given id_number is banned
    const { rows } = await db.query(
      "SELECT banned FROM user_account WHERE user_id = $1",
      [id]
    );

    if (rows[0].banned) {
      await db.query(
        "CALL delete_ban($1::INTEGER)",
        [id],
        req.tokenPayload.admin_id,
        true
      );
      res.status(200).json({ user_id: id });
    } else {
      // User is not banned
      res.status(409).json({
        error: "User is not banned.",
      });
    }
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while unbanning the user." });
  }
});

// Get all banned users
router.get("/", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query(
    "SELECT * FROM all_banned_users ORDER BY user_id"
  );
  res.status(200).json(rows);
});
