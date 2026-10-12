
require("dotenv").config();

const express = require("express");
const cors = require("cors");

const saboresRoutes = require("./routes/saboresRoutes");
const pedidosRoutes = require("./routes/pedidosRoutes");

const logger = require("./middlewares/logger");
const errorHandler = require("./middlewares/errorHandler");

const app = express();

app.use(cors());
app.use(express.json());
app.use(logger);

app.use("/api/sabores", saboresRoutes);
app.use("/api/pedidos", pedidosRoutes);

app.use((req, res) => {
    res.status(404).json({
        error: "Ruta no encontrada."
    });
});

app.use(errorHandler);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor funcionando en http://localhost:${PORT}`);
});
