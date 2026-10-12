
const CLASE_ESTADO_PEDIDO = {
    Pendiente: "estado-pendiente",
    Listo: "estado-listo",
    Retirado: "estado-retirado"
};

const ACCION_SIGUIENTE_PEDIDO = {
    Pendiente: "Marcar listo",
    Listo: "Entregar"
};

function crearBadgeEstado(estado) {
    return `<span class="badge-estado ${CLASE_ESTADO_PEDIDO[estado] || ""}">${estado}</span>`;
}

function crearFilaPedido(pedido) {
    const precio = Number(pedido.PrecioTotal).toLocaleString("es-AR", {
        style: "currency",
        currency: "ARS",
        maximumFractionDigits: 2
    });

    const accion = ACCION_SIGUIENTE_PEDIDO[pedido.Estado];

    return `
        <tr>
            <td class="numero-pedido">#${pedido.IdPedido}</td>
            <td>${pedido.Cliente}</td>
            <td>${pedido.Tamanio}</td>
            <td class="celda-sabores">${pedido.Sabores || "-"}</td>
            <td class="precio-tabla">${precio}</td>
            <td>${crearBadgeEstado(pedido.Estado)}</td>
            <td>
                ${accion
                    ? `<button class="btn-accion" data-avanzar="${pedido.IdPedido}">${accion}</button>`
                    : `<span class="sin-accion">Finalizado</span>`
                }
            </td>
        </tr>
    `;
}
