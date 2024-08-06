const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const {
  adminAuthMiddleware,
  authMiddleware,
} = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get all reservations at that time
router.get("/", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query("SELECT * FROM all_current_reservations");
  res.status(200).json(rows);
});

// Get the user reservations at that time
router.get("/user", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  if (user_id !== undefined) {
    const { rows } = await db.query(
      "SELECT * FROM all_current_reservations WHERE user_id = $1",
      [user_id]
    );
    res.status(200).json(rows);
  } else {
    res
      .status(400)
      .json({ message: "The user does not have any reservation logs." });
  }
});

// Get the item reservation at that time
router.get("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  const { rows } = await db.query(
    "SELECT * FROM all_current_reservations WHERE item_id = $1",
    [id]
  );
  res.status(200).json(rows);
});

// Add reservation
router.post("/:id", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(500).json({ message: "Invalid Token" });
  }
  try {
    await db.query(
      "CALL add_reservation($1::INTEGER, $2::INTEGER)",
      [id, user_id],
      user_id,
      false
    );
    res.status(200).json({ message: "Reservation added successfully" });
  } catch {
    (err) => {
      console.log(err);
      res
        .status(500)
        .json({ message: "An error occurred while adding reservation" });
    };
  }
  res.status(409).json({
    message:
      "Item is available to rent or already reserved or user has max item.",
  });
});

// Delete reservation
router.delete("/:id", authMiddleware, async (req, res) => {
  const { id } = req.params;
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(500).json({ message: "Invalid Token" });
  }
  try {
    await db.query(
      "CALL delete_reservation($1::INTEGER, $2::INTEGER)",
      [id, user_id],
      user_id,
      false
    );
    res.status(200).json({ message: "Reservation deleted successfully" });
  } catch {
    (err) => {
      console.log(err);
      res
        .status(500)
        .json({ message: "An error occurred while deleting reservation" });
    };
  }
  res.status(409).json({
    message: "Item is not reserved.",
  });
});
