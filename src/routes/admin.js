const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const bcrypt = require("bcrypt");
const {
  adminAuthMiddleware,
  adminAndLoggedAuthMiddleware,
} = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get all admins information
router.get("/", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query("SELECT * FROM admin");
  res.status(200).json(rows);
});

// Add new admin
router.post("/", adminAuthMiddleware, async (req, res) => {
  const { first_name, last_name, email, username, password, phone_number } =
    req.body;
  try {
    // Check if admin with the given email already exists
    const { rows: existingRows } = await db.query(
      "SELECT email FROM admin WHERE email = $1::VARCHAR",
      [email]
    );

    if (existingRows.length > 0) {
      // Admin already exists, return their admin name
      res.status(409).json({
        admin_id: existingRows[0].admin_id,
        error: "Admin already exists.",
      });
    } else {
      const hashedPassword = await bcrypt.hash(password, 10);
      const { rows } = await db.query(
        "CALL add_admin($1::VARCHAR, $2::VARCHAR, $3::VARCHAR, $4::VARCHAR, $5::VARCHAR, $6::VARCHAR, $7::INTEGER)",
        [
          first_name,
          last_name,
          email,
          username,
          hashedPassword,
          phone_number,
          1,
        ],
        req.tokenPayload.admin_id,
        true
      );
      res.status(200).json({ admin_id: rows[0].p_admin_id });
    }
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while adding the admin." });
  }
});

// Update admin information
router.patch("/", adminAndLoggedAuthMiddleware, async (req, res) => {
  const { admin_id } = req.tokenPayload;
  const { first_name, last_name, email, username, phone_number } = req.body;
  try {
    await db.query(
      "CALL update_admin_information($1::INTEGER, $2::VARCHAR, $3::VARCHAR, $4::VARCHAR, $5::VARCHAR, $6::VARCHAR)",
      [admin_id, first_name, last_name, email, username, phone_number],
      req.tokenPayload.admin_id,
      true
    );
    res.status(200).json({ result: "Admin information updated successfully." });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while updating the admin." });
  }
});

// Reset admin password
router.patch(
  "/reset-password",
  adminAndLoggedAuthMiddleware,
  async (req, res) => {
    const { admin_id } = req.tokenPayload;
    const { new_password } = req.body;
    try {
      const hashedPassword = await bcrypt.hash(new_password, 10);
      await db.query(
        "UPDATE admin SET password = $1::VARCHAR WHERE admin_id = $2::INTEGER",
        [hashedPassword, admin_id],
        req.tokenPayload.admin_id,
        true
      );
      res.status(200).json({ result: "Admin password updated successfully." });
    } catch (err) {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while updating the password." });
    }
  }
);
