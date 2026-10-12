
const { sql, poolPromise } = require("../config/db");

async function listarPedidos() {
    const pool = await poolPromise;
    const resultado = await pool.request()
        .execute("usp_ListarPedidos");

    return resultado.recordset;
}

async function crearPedido(cliente, tamanio, sabores) {
    const pool = await poolPromise;

    const resultado = await pool.request()
        .input("Cliente", sql.NVarChar(80), cliente)
        .input("Tamanio", sql.NVarChar(10), tamanio)
        .input("Sabores", sql.NVarChar(50), sabores.join(","))
        .output("IdPedido", sql.Int)
        .execute("usp_CrearPedido");

    return resultado.output.IdPedido;
}

async function avanzarPedido(idPedido) {
    const pool = await poolPromise;

    await pool.request()
        .input("IdPedido", sql.Int, idPedido)
        .execute("usp_AvanzarPedido");
}

module.exports = {
    listarPedidos,
    crearPedido,
    avanzarPedido
};
