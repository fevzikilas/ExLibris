const Router = require("express-promise-router");
const db = require("../db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
dotenv.config();

const router = new Router();
module.exports = router;

// Login
router.post("/", async (req, res) => {
  try {
    const { email, password } = req.body;
    const { rows: existingRows } = await db.query(
      "SELECT * FROM admin WHERE email = $1::VARCHAR",
      [email]
    );

    if (existingRows.length > 0) {
      // Admin
      const adminInfo = existingRows[0];
      const isPasswordMatched = await bcrypt.compare(
        password,
        adminInfo.password
      );

      if (isPasswordMatched) {
        // Admin information matches
        const accesToken = jwt.sign(
          {
            admin_id: adminInfo.admin_id,
            email: adminInfo.email,
            admin: true,
            logged_in: true,
          },
          process.env.ACCES_TOKEN_SECRET,
          { expiresIn: "15m" }
        );

        const refreshToken = jwt.sign(
          { admin_id: adminInfo.admin_id, email: adminInfo.email, admin: true },
          process.env.REFRESH_TOKEN_SECRET,
          { expiresIn: "30d" }
        );
        const now = Date.now();
        const expirationDate = new Date(now);
        expirationDate.setDate(expirationDate.getDate() + 30);
        
        
        await db.query(
          "INSERT INTO refresh_tokens (token, expires_at, admin) VALUES ($1, $2, $3)",
          [refreshToken, expirationDate, true],
          adminInfo.admin_id,
          true
        );
        
        res
          .status(200)
          .json({ accesToken: accesToken, refreshToken: refreshToken, isAdmin: true  });
      } else {
        res.status(401).json({ message: "Invalid Access Token" });
      }
    } else {
      const { rows: existingRows } = await db.query(
        "SELECT * FROM user_account WHERE email = $1::VARCHAR",
        [email]
      );

      if (existingRows.length > 0) {
        // User
        const userInfo = existingRows[0];
        if (userInfo.banned) {
          return res.status(401).json({ message: "The user has been banned" });
        }
        const isPasswordMatched = await bcrypt.compare(
          password,
          userInfo.password
        );

        if (isPasswordMatched) {
          // User information matches
          const accesToken = jwt.sign(
            {
              user_id: userInfo.user_id,
              email: userInfo.email,
              admin: false,
              logged_in: true,
            },
            process.env.ACCES_TOKEN_SECRET,
            { expiresIn: "15m" }
          );

          const refreshToken = jwt.sign(
            { user_id: userInfo.user_id, email: userInfo.email, admin: false },
            process.env.REFRESH_TOKEN_SECRET,
            { expiresIn: "30d" }
          );
          const now = Date.now();
          const expirationDate = new Date(now);
          expirationDate.setDate(expirationDate.getDate() + 30);
          await db.query(
            "INSERT INTO refresh_tokens (token, expires_at, admin) VALUES ($1, $2, $3)",
            [refreshToken, expirationDate, false],
            userInfo.user_id,
            false
          );
          res
            .status(200)
            .json({ accesToken: accesToken, refreshToken: refreshToken, isAdmin: false });
        } else {
          res.status(401).json({ message: "Invalid Access Token" });
        }
      } else {
        // There is no account for the given email and password
        return res.status(401).json({
          message: "There is no account for the given email and password.",
        });
      }
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "An error occurred while loging." });
  }
});

// Refresh Access Token
router.post("/refresh", async (req, res) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken)
      return res.status(401).json({ message: "Invalid token" });

    const { rows: existingRows } = await db.query(
      "SELECT * FROM refresh_tokens WHERE token = $1::VARCHAR",
      [refreshToken]
    );

    if (existingRows.length === 0) {
      return res.status(401).json({ message: "Invalid refresh token" });
    }

    const now = Date.now();
    const currentDate = new Date(now);
    if (existingRows[0].expires_at < currentDate) {
      await db.query("DELETE FROM refresh_tokens WHERE token = $1::VARCHAR", [
        refreshToken,
      ]);
      return res.status(401).json({ message: "Invalid refresh token" });
    }

    jwt.verify(
      refreshToken,
      process.env.REFRESH_TOKEN_SECRET,
      (err, payload) => {
        if (err) {
          console.log(err);
          res.status(400).json({ message: "Not Logged" });
        }
        if (payload.admin) {
          const accesToken = jwt.sign(
            {
              admin_id: payload.admin_id,
              email: payload.email,
              admin: true,
              logged_in: false,
            },
            process.env.ACCES_TOKEN_SECRET,
            { expiresIn: "15m" }
          );
          return res.status(200).json({ accesToken: accesToken });
        } else {
          const accesToken = jwt.sign(
            {
              user_id: payload.user_id,
              email: payload.email,
              admin: false,
              logged_in: false,
            },
            process.env.ACCES_TOKEN_SECRET,
            { expiresIn: "15m" }
          );
          return res.status(200).json({ accesToken: accesToken });
        }
      }
    );
  } catch (e) {
    console.log(e);
    res
      .status(500)
      .json({ message: "An error occurred while refreshing access token" });
  }
});
