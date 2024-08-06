const Router = require("express-promise-router");
const db = require("../db");
const router = new Router();
const {
  authMiddleware,
  adminAuthMiddleware,
} = require("../Middleware/security/authMiddlware");

module.exports = router;

// Get the user notifications
router.get("/", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  if (req.tokenPayload.admin) {
    return res.status(403).json({ message: "Invalid token" });
  }
  const { rows } = await db.query(
    "SELECT message, created_at FROM notifications WHERE user_id = $1::INTEGER",
    [user_id]
  );
  res.status(200).json(rows);
});

// Update the notification status
router.patch("/", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  const { notification_id, isRead } = req.body;

  if (req.tokenPayload.admin) {
    return res.status(403).json({ message: "Invalid token" });
  }
  try {
    await db.query(
      "UPDATE notifications SET is_read = $1::BOOLEAN WHERE id = $2::INTEGER AND user_id = $3::INTEGER",
      [isRead, notification_id, user_id],
      user_id,
      false
    );
    res.status(200).json(rows);
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "An error occurred while updating notification status.",
    });
  }
});

// Delete the notification
router.delete("/", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  const { notification_id } = req.body;

  if (req.tokenPayload.admin) {
    return res.status(403).json({ message: "Invalid token" });
  }
  try {
    await db.query(
      "DELETE FROM notifications WHERE id = $1::INTEGER AND user_id = $2::INTEGER",
      [notification_id, user_id],
      user_id,
      false
    );
    res.status(200).json(rows);
  } catch (err) {
    console.log(err);
    res.status(500).json({
      message: "An error occurred while updating notification status.",
    });
  }
});

// Send a notification to the user
router.post("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  const { message } = req.body;
  try {
    await db.query(
      "INSERT INTO notifications (message, user_id) VALUES ($1::TEXT, $2::INTEGER);",
      [message, id],
      req.tokenPayload.admin_id,
      true
    );
    res.status(200).json({ message: "Notification added successfully." });
  } catch (err) {
    console.log(err);
    res
      .status(500)
      .json({ message: "An error occurred while sending notification." });
  }
});
