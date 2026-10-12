
function crearTarjetaSabor(sabor, estaSeleccionado) {
    const clases = [
        "tarjeta-sabor",
        estaSeleccionado ? "seleccionada" : "",
        sabor.Disponible ? "" : "agotada"
    ].filter(Boolean).join(" ");

    return `
        <article class="${clases}" data-id="${sabor.IdSabor}"
            role="button" tabindex="${sabor.Disponible ? 0 : -1}"
            aria-pressed="${estaSeleccionado}"
            aria-disabled="${!sabor.Disponible}">
            <span class="sabor-icono">🍨</span>
            <span class="nombre-sabor">${sabor.Nombre}</span>
            <span class="sabor-indicador">${!sabor.Disponible ? "AGOTADO" : estaSeleccionado ? "✓ Elegido" : "Seleccionar"}</span>
        </article>
    `;
}
