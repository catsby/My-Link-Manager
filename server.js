const express = require("express");
const app = express();
const mongoose = require("mongoose");
const config = require("./config");
const initialize = require("./config/initialize");
const DB = process.env.DATABASE_URL || ""

// connecting with mongoosejs.
mongoose.connect(DB, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const initializer = initialize(app);
initializer.create(config);
initializer.start();
