const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const {
  authMiddleware,
  adminAuthMiddleware,
} = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get all return records
router.get("/", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query(
    "SELECT * FROM return_history ORDER BY return_date"
  );
  res.status(200).json(rows);
});

// Get user return records
router.get("/user", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(401).json({ message: "Invalid Token" });
  }
  const { rows } = await db.query(
    "SELECT * FROM return_history WHERE user_id = $1 ORDER BY return_date",
    [user_id]
  );
  res.status(200).json(rows);
});

// Finish the rental process and add the record to rental history
router.post("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  const { description } = req.body;
  try {
    await db.query(
      "CALL add_return_history ($1, $2::VARCHAR)",
      [id, description],
      req.tokenPayload.admin_id,
      true
    );
    res.status(200).json("The return history was successfully added.");
  } catch {
    (err) => {
      console.error(err);
      res.status(500).json("An error occured while adding rental history.");
    };
  }
  res.status(409).json("Record does not exist.");
});
