
const fs = require("fs");
const path = require("path");

const carpetaLogs = path.join(__dirname, "../../logs");
fs.mkdirSync(carpetaLogs, { recursive: true });

function errorHandler(err, req, res, next) {
    const codigo = err.number || err.originalError?.info?.number;

    let status = 500;

    if ([50026, 50027].includes(codigo)) {
        status = 400;
    }

    if (codigo === 50024) {
        status = 404;
    }

    if (codigo === 50025) {
        status = 409;
    }

    if (err.status) {
        status = err.status;
    }

    const mensaje = err.message || "Error interno del servidor.";

    const registro = `[${new Date().toISOString()}] ${req.method} ${req.originalUrl} - ${codigo || status} - ${mensaje}\n`;

    fs.appendFileSync(
        path.join(carpetaLogs, "errores.log"),
        registro
    );

    console.error(registro.trim());

    res.status(status).json({
        error: status === 500 ? "Error interno del servidor." : mensaje,
        codigo: codigo || status
    });
}

module.exports = errorHandler;
