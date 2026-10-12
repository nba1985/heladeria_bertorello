
const API_URL = "http://localhost:3000/api";

const estado = {
    sabores: [],
    seleccionados: [],
    tamanio: "Cuarto",
    pedidos: []
};

const grillaSabores = document.getElementById("grillaSabores");
const resumenPedido = document.getElementById("resumenPedido");
const tablaPedidos = document.getElementById("tablaPedidos");
const formPedido = document.getElementById("formPedido");
const txtCliente = document.getElementById("txtCliente");
const cboTamanio = document.getElementById("cboTamanio");
const btnCrearPedido = document.getElementById("btnCrearPedido");
const btnActualizar = document.getElementById("btnActualizar");
const mensaje = document.getElementById("mensaje");

function mostrarMensaje(texto, tipo = "error") {
    mensaje.textContent = texto;
    mensaje.className = `mensaje mensaje-${tipo}`;
}

function ocultarMensaje() {
    mensaje.textContent = "";
    mensaje.className = "mensaje oculto";
}

async function solicitar(url, opciones = {}) {
    const respuesta = await fetch(`${API_URL}${url}`, opciones);
    const datos = await respuesta.json();

    if (!respuesta.ok) {
        throw new Error(datos.error || "Error de comunicación con el servidor.");
    }

    return datos;
}

function renderSabores() {
    grillaSabores.innerHTML = estado.sabores
        .map(sabor => crearTarjetaSabor(
            sabor,
            estado.seleccionados.includes(sabor.IdSabor)
        ))
        .join("");

    document.getElementById("contadorSabores").textContent =
        `${estado.seleccionados.length} / 3`;
}

function renderResumen() {
    const saboresElegidos = estado.seleccionados
        .map(id => estado.sabores.find(sabor => sabor.IdSabor === id))
        .filter(Boolean);

    resumenPedido.innerHTML = crearResumenPedido(
        saboresElegidos,
        estado.tamanio
    );
}

function renderPedidos() {
    tablaPedidos.innerHTML = estado.pedidos.length
        ? estado.pedidos.map(pedido => crearFilaPedido(pedido)).join("")
        : `<tr><td colspan="7">Todavía no hay pedidos registrados.</td></tr>`;

    document.getElementById("totalPedidos").textContent =
        `${estado.pedidos.length} pedidos`;

    const pendientes = estado.pedidos.filter(p => p.Estado === "Pendiente").length;
    const listos = estado.pedidos.filter(p => p.Estado === "Listo").length;
    const retirados = estado.pedidos.filter(p => p.Estado === "Retirado").length;

    document.getElementById("contadoresEstados").innerHTML = `
        <span class="contador-estado">🟠 ${pendientes} pendientes</span>
        <span class="contador-estado">🟢 ${listos} listos</span>
        <span class="contador-estado">⚪ ${retirados} retirados</span>
    `;
}

function renderTodo() {
    renderSabores();
    renderResumen();
    renderPedidos();
}

async function cargarSabores() {
    estado.sabores = await solicitar("/sabores");
    renderSabores();
    renderResumen();
}

async function cargarPedidos() {
    estado.pedidos = await solicitar("/pedidos");
    renderPedidos();
}

function seleccionarSabor(id) {
    const sabor = estado.sabores.find(s => s.IdSabor === id);

    if (!sabor || !sabor.Disponible) {
        return;
    }

    if (estado.seleccionados.includes(id)) {
        estado.seleccionados = estado.seleccionados.filter(
            seleccionado => seleccionado !== id
        );
    } else {
        if (estado.seleccionados.length >= 3) {
            mostrarMensaje("Solo podés elegir hasta 3 sabores.");
            return;
        }

        estado.seleccionados.push(id);
    }

    ocultarMensaje();
    renderSabores();
    renderResumen();
}

grillaSabores.addEventListener("click", event => {
    const tarjeta = event.target.closest(".tarjeta-sabor");

    if (!tarjeta) {
        return;
    }

    seleccionarSabor(Number(tarjeta.dataset.id));
});

grillaSabores.addEventListener("keydown", event => {
    if (event.key !== "Enter" && event.key !== " ") {
        return;
    }

    const tarjeta = event.target.closest(".tarjeta-sabor");

    if (!tarjeta) {
        return;
    }

    event.preventDefault();
    seleccionarSabor(Number(tarjeta.dataset.id));
});

cboTamanio.addEventListener("change", event => {
    estado.tamanio = event.target.value;
    renderResumen();
});

formPedido.addEventListener("submit", async event => {
    event.preventDefault();

    const cliente = txtCliente.value.trim();

    if (!cliente) {
        mostrarMensaje("Ingresá el nombre del cliente.");
        return;
    }

    if (estado.seleccionados.length === 0) {
        mostrarMensaje("Seleccioná al menos un sabor.");
        return;
    }

    btnCrearPedido.disabled = true;
    btnCrearPedido.textContent = "Registrando...";

    try {
        const resultado = await solicitar("/pedidos", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                cliente,
                tamanio: estado.tamanio,
                sabores: estado.seleccionados
            })
        });

        estado.seleccionados = [];
        estado.tamanio = "Cuarto";
        txtCliente.value = "";
        cboTamanio.value = "Cuarto";

        await cargarPedidos();
        renderSabores();
        renderResumen();

        mostrarMensaje(
            `Pedido #${resultado.IdPedido} registrado correctamente.`,
            "exito"
        );
    } catch (error) {
        mostrarMensaje(error.message);
    } finally {
        btnCrearPedido.disabled = false;
        btnCrearPedido.textContent = "Registrar pedido";
    }
});

tablaPedidos.addEventListener("click", async event => {
    const boton = event.target.closest("[data-avanzar]");

    if (!boton) {
        return;
    }

    const idPedido = Number(boton.dataset.avanzar);
    boton.disabled = true;

    try {
        await solicitar(`/pedidos/${idPedido}/avanzar`, {
            method: "PUT"
        });

        await cargarPedidos();

        mostrarMensaje(
            `Pedido #${idPedido} actualizado correctamente.`,
            "exito"
        );
    } catch (error) {
        mostrarMensaje(error.message);
        boton.disabled = false;
    }
});

btnActualizar.addEventListener("click", async () => {
    try {
        await Promise.all([
            cargarSabores(),
            cargarPedidos()
        ]);

        mostrarMensaje("Información actualizada.", "exito");
    } catch (error) {
        mostrarMensaje(error.message);
    }
});

async function iniciarAplicacion() {
    renderTodo();

    try {
        await Promise.all([
            cargarSabores(),
            cargarPedidos()
        ]);
    } catch (error) {
        mostrarMensaje(error.message);
    }
}

iniciarAplicacion();
