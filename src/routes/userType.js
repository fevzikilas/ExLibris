const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const { adminAuthMiddleware } = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get all user types
router.get("/", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query("SELECT * FROM user_type");
  res.status(200).json(rows);
});

// Add new user type
router.post("/", adminAuthMiddleware, async (req, res) => {
  const {
    type_name,
    max_extratime,
    max_rental,
    max_reservation_day,
    penalty_fee,
    rental_time,
  } = req.body;
  try {
    // Check if user type with the given name already exists
    const { rows } = await db.query(
      "SELECT 1 FROM user_type WHERE type_name = $1::VARCHAR",
      [type_name]
    );
    if (rows[0]) {
      res.status(409).json({
        error: `The user type with the given name already exists`,
      });
    } else {
      const { rows } = await db.query(
        "CALL add_user_type($1::VARCHAR, $2::INTEGER, $3::INTEGER, $4::INTEGER, $5::INTEGER, $6::INTEGER, $7::INTEGER)",
        [
          type_name,
          max_extratime,
          max_rental,
          max_reservation_day,
          penalty_fee,
          rental_time,
          1,
        ],
        req.tokenPayload.admin_id,
        true
      );
      res.status(200).json({ user_type_id: rows[0].p_user_type_id });
    }
  } catch {
    (err) => {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while adding the user type." });
    };
  }
});

// Delete the user type
router.delete("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    await db.query(
      "CALL delete_user_type($1)",
      [id],
      req.tokenPayload.admin_id,
      true
    );
    res.status(200).json("The user type was successfully deleted.");
  } catch {
    (err) => {
      console.error(err);
      res.status(500).json("An error occurred while deleting the user type");
    };
  }
  res
    .status(409)
    .json(
      "The user type could not be deleted. Because there are users with the given user type."
    );
});

// Update the user type
router.patch("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;

  const {
    type_name,
    max_extratime,
    max_rental,
    max_reservation_day,
    rental_time,
    penalty_fee,
  } = req.body;
  try {
    await db.query(
      "CALL update_user_type($1::INTEGER, $2::VARCHAR, $3::INTEGER, $4::INTEGER, $5::INTEGER, $6::INTEGER, $7::INTEGER)",
      [
        id,
        type_name,
        max_extratime,
        max_rental,
        max_reservation_day,
        rental_time,
        penalty_fee,
      ],
      req.tokenPayload.admin_id,
      true
    );
    res.status(200).json("User type was updated successfully.");
  } catch {
    (err) => {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while updating the user type." });
    };
  }
});
