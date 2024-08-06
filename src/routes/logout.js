const Router = require("express-promise-router");
const db = require("../db");
const dotenv = require("dotenv");
dotenv.config();
const jwt = require("jsonwebtoken");

const router = new Router();
module.exports = router;

//Logout
router.post("/", async (req, res) => {
  try {
    const { refreshToken } = req.body;
    jwt.verify(
      refreshToken,
      process.env.REFRESH_TOKEN_SECRET,
      async (err, payload) => {
        if (err) {
          console.log(err);
          res.status(400).json({ message: err.message });
        }

        const { rows: existingRows } = await db.query(
          "SELECT * FROM refresh_tokens WHERE token = $1::VARCHAR",
          [refreshToken]
        );
        if (existingRows.length === 0) {
          return res.status(500).json({ message: "Invalid Token" });
        }
        if (payload.admin) {
          await db.query(
            "DELETE FROM refresh_tokens WHERE token = $1::VARCHAR",
            [refreshToken],
            payload.admin_id,
            true
          );
          res.status(200).json({ message: "Logged out successfully." });
        } else {
          await db.query(
            "DELETE FROM refresh_tokens WHERE token = $1::VARCHAR",
            [refreshToken],
            payload.user_id,
            false
          );
          res.status(200).json({ message: "Logged out successfully." });
        }
      }
    );
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "An error occurred while logging out." });
  }
});
