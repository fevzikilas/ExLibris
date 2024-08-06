const nodemailer = require("nodemailer");
require("dotenv").config();

let transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    type: "OAuth2",
    user: process.env.AUTH_EMAIL,
    clientId: process.env.AUTH_CLIENT_ID,
    clientSecret: process.env.AUTH_CLIENT_SECRET,
    refreshToken: process.env.AUTH_REFRESH_TOKEN,
  },
});

// Testing transport success
transporter.verify((error, succes) => {
  if (error) {
    console.log(error);
  } else {
    console.log("Server is ready to send mail.");
  }
});

// Send  email
const sendEmail = async (email, text, subject, res) => {
  try {
    const mailOptions = {
      from: process.env.AUTH_EMAIL,
      to: email,
      subject: subject,
      html: text,
    };

    await transporter.sendMail(mailOptions);
  } catch (err) {
    res.status(500).json({ message: "An error occurred sending email." });
  }
};

module.exports = { sendEmail };
