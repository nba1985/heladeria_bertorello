
const express = require("express");
const router = express.Router();
const pedidosController = require("../controllers/pedidosController");

router.get("/", pedidosController.listarPedidos);
router.post("/", pedidosController.crearPedido);
router.put("/:id/avanzar", pedidosController.avanzarPedido);

module.exports = router;
