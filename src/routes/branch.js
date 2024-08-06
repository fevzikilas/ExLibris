const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const {
  adminAuthMiddleware,
  authMiddleware,
} = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get all branches with their shelves
router.get("/", authMiddleware, async (req, res) => {
  const { rows } = await db.query("SELECT * FROM branch_shelf");
  res.status(200).json(rows);
});

// Delete branch
router.delete("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    await db.query(
      "CALL delete_branch($1::INTEGER)",
      [id],
      req.tokenPayload.admin_id,
      true
    );
    res.status(200).json("The delete was successful.");
  } catch {
    (err) => {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while deleting the branch." });
    };
  }
  res.status(409).json("There are items in the branch.");
});
