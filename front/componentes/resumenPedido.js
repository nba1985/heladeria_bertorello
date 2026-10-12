
const PRECIOS_TAMANIO = {
    Cuarto: 9800,
    Medio: 17800,
    Kilo: 30500
};

function crearResumenPedido(saboresElegidos, tamanio) {
    const precio = PRECIOS_TAMANIO[tamanio];

    const precioFormateado = precio.toLocaleString("es-AR", {
        style: "currency",
        currency: "ARS",
        maximumFractionDigits: 2
    });

    const lista = saboresElegidos.length
        ? saboresElegidos.map(sabor => `<li>${sabor.Nombre}</li>`).join("")
        : `<li class="resumen-vacio">Todavía no elegiste sabores.</li>`;

    return `
        <div class="resumen-contenido">
            <div class="resumen-detalle">
                <span class="etiqueta">Tamaño seleccionado</span>
                <strong>${tamanio}</strong>
            </div>
            <div class="resumen-detalle">
                <span class="etiqueta">Sabores (${saboresElegidos.length}/3)</span>
                <ul class="lista-resumen">${lista}</ul>
            </div>
            <div class="resumen-total">
                <span>Precio estimado</span>
                <strong>${precioFormateado}</strong>
            </div>
            <p class="nota-precio">El precio definitivo lo calcula SQL Server.</p>
        </div>
    `;
}
