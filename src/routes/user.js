const Router = require("express-promise-router");
const bcrypt = require("bcrypt");
const db = require("../db");
const router = new Router();
const MAX_LISTS = 20;
const {
  adminAuthMiddleware,
  authMiddleware,
  loggedAuthMiddleware,
} = require("../Middleware/security/authMiddlware");
const { uploadPP } = require("../Middleware/upload/uploadMiddleware");
const fs = require("fs");
const { sendEmail } = require("../Middleware/mail/sendMail");
module.exports = router;

// Get user information for user
router.get("/user", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token" });
  }
  const { rows } = await db.query(
    "SELECT * FROM user_account WHERE user_id = $1",
    [user_id]
  );
  res.status(200).json(rows[0]);
});



// Get all users information
router.get("/all", adminAuthMiddleware, async (req, res) => {
  const { rows } = await db.query(
    "SELECT * FROM user_all_information ORDER BY user_id",
    []
  );
  res.status(200).json(rows);
});

// Get user's all lists
router.get("/lists", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid Token" });
  }
  const { rows } = await db.query(
    "SELECT * FROM list WHERE user_id = $1::INTEGER",
    [user_id]
  );
  res.status(200).json(rows);
});

// Get pp
router.get("/pp", authMiddleware, async (req, res) => {
  const user_id = req.tokenPayload.user_id;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token." });
  }
  const { rows } = await db.query(
    "SELECT photo, photo_type FROM user_account WHERE user_id = $1",
    [user_id]
  );
  console.log(rows[0]);
  const filePath = rows[0].photo;
  const photo_type = rows[0].photo_type;
  if (filePath) {
    fs.readFile(filePath, (err, file) => {
      res.setHeader("Content-Type", photo_type);
      res.send(file);
    });
  } else {
    res.status(404).json({ message: "The content was not found." });
  }
});


// Get user information for admin
router.get("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  const { rows } = await db.query(
    "SELECT * FROM user_account WHERE user_id = $1",
    [id]
  );
  res.status(200).json(rows[0]);
});

// Add new user
router.post("/", adminAuthMiddleware, async (req, res) => {
  const { admin_id } = req.tokenPayload;
  const {
    first_name,
    last_name,
    email,
    username,
    password,
    phone_number,
    id_number,
    banned,
    user_type_id,
  } = req.body;
  try {
    // Check if user with the given id_number already exists
    const { rows: existingRows } = await db.query(
      "SELECT user_id FROM user_account WHERE id_number = $1 OR email = $2",
      [id_number, email]
    );

    if (existingRows.length > 0) {
      // User already exists, return their user_id
      res.status(409).json({
        user_id: existingRows[0].user_id,
        error: "User already exists.",
      });
    } else {
      const hashedPassword = await bcrypt.hash(password, 10);
      const { rows } = await db.query(
        "CALL add_user_account($1::VARCHAR, $2::VARCHAR, $3::VARCHAR, $4::VARCHAR, $5::VARCHAR, $6::VARCHAR, $7::INTEGER, $8::VARCHAR, $9::BOOLEAN, $10::SMALLINT, $11::INTEGER)",
        [
          first_name,
          last_name,
          email,
          username,
          hashedPassword,
          phone_number,
          admin_id,
          id_number,
          banned,
          user_type_id,
          1,
        ],
        admin_id,
        true
      );
      res.status(200).json({ user_id: rows[0].p_user_id });
    }
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while adding the user account." });
  }
});

// Update user information
router.patch("/", loggedAuthMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  const { first_name, last_name, email, username, phone_number, user_type_id } =
    req.body;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid Token" });
  }
  try {
    await db.query(
      "CALL update_user_information($1::INTEGER, $2::VARCHAR, $3::VARCHAR, $4::VARCHAR, $5::VARCHAR, $6::VARCHAR, $7::SMALLINT)",
      [
        user_id,
        first_name,
        last_name,
        email,
        username,
        phone_number,
        user_type_id,
      ],
      user_id,
      false
    );
    res.status(200).json({ result: "User information updated successfully." });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while updating the user." });
  }
});

// Delete user
router.delete("/:id", adminAuthMiddleware, async (req, res) => {
  const { id } = req.params;
  try {
    await db.query(
      "CALL delete_user_account($1::INTEGER)",
      [id],
      req.tokenPayload.admin_id,
      true
    );
    res.status(200).json({ result: "User deleted successfully." });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while deleting the user." });
  }
  res.status(409).json("User has book.");
});

// Update user password
router.patch("/update-password", loggedAuthMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  const { new_password } = req.body;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid Token" });
  }
  try {
    const hashedPassword = await bcrypt.hash(new_password, 10);
    await db.query(
      "UPDATE user_account SET password = $1::VARCHAR WHERE user_id = $2::INTEGER",
      [hashedPassword, user_id],
      user_id,
      false
    );
    res.status(200).json({ result: "User password updated successfully." });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: "An error occurred while updating the password." });
  }
});

// Add new list
router.post("/lists", authMiddleware, async (req, res) => {
  const { user_id } = req.tokenPayload;
  const { list_name } = req.body;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid Token" });
  }
  try {
    // Check if user with the given id_number already have MAX_LISTS list
    const { rows } = await db.query(
      "SELECT COUNT(*) FROM list WHERE user_id = $1::INTEGER",
      [user_id]
    );
    if (rows[0].count > MAX_LISTS) {
      res.status(409).json({
        error: `The user with the given id_number already has ${MAX_LISTS} list`,
      });
    } else {
      await db.query(
        "INSERT INTO list (user_id, list_name) VALUES ($1::INTEGER, $2::VARCHAR)",
        [user_id, list_name],
        user_id,
        false
      );
      res.status(200).json("List has been created.");
    }
  } catch {
    (err) => {
      console.error(err);
      res
        .status(500)
        .json({ error: "An error occurred while edding the list." });
    };
  }
});

// Reset Password

// Request password reset
router.post("/request-password-reset", async (req, res) => {
  try {
    const { email } = req.body;
    const { rows } = await db.query(
      "SELECT * FROM user_account WHERE email = $1",
      [email]
    );
    if (rows.length > 0) {
      const user = rows[0];
      await db.query("DELETE FROM otpcode WHERE user_id = $1", [user.user_id]);
      const otp = `${Math.floor(1000 + Math.random() * 9000)}`;
      const expiresTime = 3600000;
      const expiresAt = new Date(Date.now() + expiresTime);

      const hashedOtp = await bcrypt.hash(otp, 10);
      await db.query(
        "INSERT INTO otpCode (user_id, otp, expiresAt) VALUES ($1::INTEGER, $2::VARCHAR, $3::TIMESTAMP)",
        [user.user_id, hashedOtp, expiresAt]
      );

      const subject = "ExLibris Resend Password Reset";
      const text = `<p>Hi <b>${user.first_name}</b>! Enter <b>${otp}</b> in the app to reset your password.</p>
      <p>This code <b>expires in 1 hour</b>.</p>
      
      <p>If you did not request this, please ignore this email.</p>`;
      sendEmail(email, text, subject, res);
      res.status(200).json({
        message: "OTP Code was sent successfully to given email.",
      });
    } else {
      res
        .status(403)
        .json({ message: "There is no user with that email address." });
    }
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ message: "An error occurred while sending otp code." });
  }
});

// Reset Password
router.post("/reset-password", async (req, res) => {
  const { email, otpCode, newPassword } = req.body;
  try {
    const { rows } = await db.query(
      "SELECT user_id FROM user_account WHERE email = $1",
      [email]
    );

    if (rows.length > 0) {
      const user_id = rows[0].user_id;
      let otpResult = await db.query(
        "SELECT * FROM otpcode WHERE user_id = $1",
        [user_id]
      );
      otpResult = otpResult.rows;
      if (otpResult.length > 0) {
        const { otp, expiresat } = otpResult[0];
        const isOTPMatched = await bcrypt.compare(otpCode.toString(), otp);
        if (isOTPMatched) {
          if (expiresat > Date.now()) {
            const hashedPassword = await bcrypt.hash(newPassword, 10);
            await db.query(
              "UPDATE user_account SET password = $1::VARCHAR WHERE user_id = $2::INTEGER",
              [hashedPassword, user_id],
              user_id,
              false
            );
            await db.query("DELETE FROM otpcode WHERE user_id = $1", [user_id]);
            res.status(200).json({ message: "Password changed successfully." });
          } else {
            res
              .status(401)
              .json({ message: "Code has expired. Please try again." });
          }
        } else {
          res.status(401).json({ message: "Invalid code. Check your inbox." });
        }
      } else {
        res.status(401).json({ message: "Password reset request not found." });
      }
    } else {
      res.status(403).json({ message: "There is no user with that email." });
    }
  } catch (err) {
    console.log(err);
    res
      .status(500)
      .json({ message: "An error occurred while reseting password." });
  }
});

// Storage for user profile photo

// Upload profile photo
router.post("/pp", authMiddleware, uploadPP.single("pp"), async (req, res) => {
  const user_id = req.tokenPayload.user_id;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token." });
  }

  if (req.fileValidationError) {
    return res.status(500).json({ message: req.fileValidationError });
  }

  const { rows } = await db.query(
    "SELECT photo FROM user_account WHERE user_id = $1",
    [user_id]
  );
  const filePath = rows[0].path;

  if (filePath) {
    fs.access(filePath, fs.constants.F_OK, (err) => {
      if (!err) {
        fs.unlink(filePath, (err) => console.log(err));
      }
    });
  }
  const path = req.file.path;
  const mimetype = req.file.mimetype;
  await db.query(
    "UPDATE user_account SET photo = $1::VARCHAR, photo_type = $2::VARCHAR WHERE user_id = $3::INTEGER",
    [path, mimetype, user_id],
    user_id,
    false
  );
  res.status(200).json({ message: "Upload successfully." });
});

// Delete pp
router.delete("/pp", authMiddleware, async (req, res) => {
  const user_id = req.tokenPayload.user_id;
  if (user_id === undefined) {
    return res.status(403).json({ message: "Invalid token." });
  }
  const { rows } = await db.query(
    "SELECT photo FROM user_account WHERE user_id = $1",
    [id]
  );
  const filePath = rows[0].path;

  if (filePath) {
    fs.access(filePath, fs.constants.F_OK, (err) => {
      if (!err) {
        fs.unlink(filePath, (err) => console.log(err));
      }
    });
    await db.query(
      "UPDATE user_account SET photo = $1, photo_type = $2 WHERE user_id = $3::INTEGER",
      [null, null, user_id],
      req.tokenPayload.user_id,
      false
    );
  }

  res.status(200).json({ message: "The photo was deleted successfully." });
});

