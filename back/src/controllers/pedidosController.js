
const pedidosService = require("../services/pedidosService");
const asyncHandler = require("../middlewares/asyncHandler");

const listarPedidos = asyncHandler(async (req, res) => {
    const pedidos = await pedidosService.listarPedidos();
    res.status(200).json(pedidos);
});

const crearPedido = asyncHandler(async (req, res) => {
    const { cliente, tamanio, sabores } = req.body || {};

    if (
        typeof cliente !== "string" ||
        !cliente.trim() ||
        cliente.trim().length > 80 ||
        !["Cuarto", "Medio", "Kilo"].includes(tamanio) ||
        !Array.isArray(sabores) ||
        !sabores.every(id => Number.isInteger(id) && id > 0)
    ) {
        return res.status(400).json({
            error: "Datos del pedido invalidos."
        });
    }

    const idPedido = await pedidosService.crearPedido(
        cliente.trim(),
        tamanio,
        sabores
    );

    res.status(201).json({
        mensaje: "Pedido creado correctamente.",
        IdPedido: idPedido
    });
});

const avanzarPedido = asyncHandler(async (req, res) => {
    const idPedido = Number(req.params.id);

    if (!Number.isSafeInteger(idPedido) || idPedido <= 0) {
        return res.status(400).json({
            error: "Id de pedido invalido."
        });
    }

    await pedidosService.avanzarPedido(idPedido);

    res.status(200).json({
        mensaje: "Estado del pedido actualizado correctamente."
    });
});

module.exports = {
    listarPedidos,
    crearPedido,
    avanzarPedido
};
