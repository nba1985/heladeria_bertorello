
const { sql, poolPromise } = require("./src/config/db");

async function probarConexion() {
    try {
        const pool = await poolPromise;
        const resultado = await pool.request().query("SELECT DB_NAME() AS BaseDatos");

        console.log("Conexión exitosa a SQL Server");
        console.log("Base de datos:", resultado.recordset[0].BaseDatos);
    } catch (error) {
        console.error("Error de conexión:", error.message);
    } finally {
        sql.close();
    }
}

probarConexion();
