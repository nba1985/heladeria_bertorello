
const express = require("express");
const router = express.Router();
const saboresController = require("../controllers/saboresController");

router.get("/", saboresController.listarSabores);

module.exports = router;
