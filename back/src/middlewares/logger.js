
const fs = require("fs");
const path = require("path");

const carpetaLogs = path.join(__dirname, "../../logs");
fs.mkdirSync(carpetaLogs, { recursive: true });

function logger(req, res, next) {
    const inicio = Date.now();

    res.on("finish", () => {
        const duracion = Date.now() - inicio;

        const registro = `[${new Date().toISOString()}] ${req.method} ${req.originalUrl} -> ${res.statusCode} (${duracion} ms)\n`;

        fs.appendFileSync(
            path.join(carpetaLogs, "acceso.log"),
            registro
        );

        console.log(registro.trim());
    });

    next();
}

module.exports = logger;
