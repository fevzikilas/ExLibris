// Storage for multimedia items content
const multer = require("multer");
const path = require("path");
const { v4: uuidv4 } = require("uuid");
const fs = require("fs");

const storagePDF = multer.diskStorage({
  destination: (req, res, cb) => {
    const destinationPath = "./upload/pdf";
    if (!fs.existsSync(destinationPath)) {
      fs.mkdirSync(destinationPath, { recursive: true });
    }

    cb(null, destinationPath);
  },

  filename: (req, file, cb) => {
    console.log(file);
    const uniqueName = uuidv4();
    cb(null, file.originalname + uniqueName + path.extname(file.originalname));
  },
});

const uploadPDF = multer({
  storage: storagePDF,

  fileFilter: function (req, file, cb) {
    const allowedTypes = ["application/pdf"];
    const fileMimeType = file.mimetype;
    if (!allowedTypes.includes(fileMimeType)) {
      req.fileValidationError = "File types other than PDF cannot be attached.";
      return cb(
        null,
        false,
        new Error("File types other than PDF cannot be attached.")
      );
    }
    cb(null, true);
  },
});

const storageAudio = multer.diskStorage({
  destination: (req, res, cb) => {
    const destinationPath = "./upload/audio";
    if (!fs.existsSync(destinationPath)) {
      fs.mkdirSync(destinationPath, { recursive: true });
    }

    cb(null, destinationPath);
  },

  filename: (req, file, cb) => {
    console.log(file);
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const uploadAudio = multer({
  storage: storageAudio,

  fileFilter: function (req, file, cb) {
    const allowedTypes = ["audio/mpeg", "audio/wav", "audio/mp3"];
    const fileMimeType = file.mimetype;
    if (!allowedTypes.includes(fileMimeType)) {
      req.fileValidationError =
        "File types other than .mpeg, .wav and .mp3 cannot be attached.";
      return cb(
        null,
        false,
        new Error(
          "File types other than .mpeg, .wav and .mp3 cannot be attached."
        )
      );
    }
    cb(null, true);
  },
});

const storageVideo = multer.diskStorage({
  destination: (req, res, cb) => {
    const destinationPath = "./upload/video";
    if (!fs.existsSync(destinationPath)) {
      fs.mkdirSync(destinationPath, { recursive: true });
    }

    cb(null, destinationPath);
  },

  filename: (req, file, cb) => {
    console.log(file);
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const uploadVideo = multer({
  storage: storageVideo,

  fileFilter: function (req, file, cb) {
    const allowedTypes = ["video/mp4", "video/mpeg", "video/quicktime"];
    const fileMimeType = file.mimetype;
    if (!allowedTypes.includes(fileMimeType)) {
      req.fileValidationError =
        "File types other than .mpeg, .quicktime and .mp4 cannot be attached.";
      return cb(
        null,
        false,
        new Error(
          "File types other than .mpeg, .quicktime and .mp4 cannot be attached."
        )
      );
    }
    cb(null, true);
  },
});

const storageUserPP = multer.diskStorage({
  destination: (req, res, cb) => {
    const destinationPath = "./upload/image";
    if (!fs.existsSync(destinationPath)) {
      fs.mkdirSync(destinationPath, { recursive: true });
    }

    cb(null, destinationPath);
  },

  filename: (req, file, cb) => {
    console.log(file);
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const uploadPP = multer({
  storage: storageUserPP,

  fileFilter: function (req, file, cb) {
    const allowedTypes = ["image/jpg", "image/jpeg", "image/png"];
    const fileMimeType = file.mimetype;
    if (!allowedTypes.includes(fileMimeType)) {
      req.fileValidationError =
        "File types other than .jpg, .jpeg and .png cannot be attached.";
      return cb(
        null,
        false,
        new Error(
          "File types other than .jpg, .jpeg and .png cannot be attached."
        )
      );
    }
    cb(null, true);
  },
});

module.exports = {
  uploadPDF,
  uploadAudio,
  uploadVideo,
  uploadPP,
};
