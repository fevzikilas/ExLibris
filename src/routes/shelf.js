const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const { adminAuthMiddleware } = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get all shelves
router.get("/", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query("SELECT * FROM shelf");
  res.status(200).json(rows);
});

// Add new shelf
router.post("/", adminAuthMiddleware, async (req, res) => {
  const { shelf_code } = req.body;
  try {
    const { rows } = await db.query(
      "SELECT 1 FROM shelf WHERE shelf_code = $1",
      [shelf_code]
    );
    if (rows[0]) {
      res.status(409).json({
        error: `The shelf with the given shelf_code already exists`,
      });
    } else {
      await db.query(
        "CALL add_shelf($1::VARCHAR)",
        [shelf_code],
        req.tokenPayload.admin_id,
        true
      );
      res
        .status(200)
        .json("The shelf with the given shelf_code was added successfully.");
    }
  } catch {
    (err) => {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while adding the shelf." });
    };
  }
});

// Delete a shelf
router.delete("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    await db.query(
      "CALL delete_shelf($1::INTEGER)",
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
        .json({ error: "An error occurred while deleting the shelf." });
    };
  }
  res.status(409).json("There are items in the shelf.");
});

// Add new branch
router.post("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  const { branch_code } = req.body;
  try {
    const { rows } = await db.query(
      "SELECT 1 FROM branch WHERE branch_code = $1",
      [branch_code]
    );
    if (rows[0]) {
      res.status(409).json({
        error: `The branch with the given branch_code already exists`,
      });
    } else {
      const { rows } = await db.query(
        "CALL add_branch($1::VARCHAR, $2::INTEGER, $3)",
        [branch_code, id, 1],
        req.tokenPayload.admin_id,
        true
      );
      res.status(200).json({
        message:
          "The branch with the given branch_code was added successfully.",
        branch_id: rows[0].p_branch_id,
      });
    }
  } catch {
    (err) => {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while adding the branch." });
    };
  }
});
