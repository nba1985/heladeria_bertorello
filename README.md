# 🍦 Heladería El Iglú — Sistema de Gestión de Pedidos

**Instituto Superior Villa del Rosario**  
**Tecnicatura Superior en Desarrollo de Software**  
**Materia:** Programación II — 2026  
**Alumno:** Nicolás Bertorello  
**Trabajo práctico:** Clase 13 — Componentes de interfaz con JavaScript vanilla

## 1. Descripción del proyecto

Sistema de gestión de pedidos para la Heladería El Iglú, desarrollado para administrar los encargos realizados por los clientes.

La aplicación permite seleccionar hasta tres sabores disponibles, elegir el tamaño del pote, registrar nuevos pedidos y administrar sus estados desde una pantalla de mostrador.

El proyecto integra SQL Server, Node.js, Express y JavaScript vanilla, utilizando una arquitectura en capas para el backend y componentes reutilizables para el frontend.

## 2. Tecnologías utilizadas

- **Backend:** Node.js, Express, mssql, dotenv y cors.
- **Frontend:** HTML5, CSS3 y JavaScript vanilla.
- **Base de datos:** Microsoft SQL Server.
- **Control de versiones:** Git y GitHub.
- **Herramientas:** Visual Studio Code, SQL Server Management Studio y Live Server.

## 3. Estructura del proyecto

```text
Heladeria_Bertorello/
├── .vscode/
│   └── settings.json
├── back/
│   ├── src/
│   │   ├── config/
│   │   │   └── db.js
│   │   ├── controllers/
│   │   │   ├── saboresController.js
│   │   │   └── pedidosController.js
│   │   ├── services/
│   │   │   ├── saboresService.js
│   │   │   └── pedidosService.js
│   │   ├── routes/
│   │   │   ├── saboresRoutes.js
│   │   │   └── pedidosRoutes.js
│   │   ├── middlewares/
│   │   │   ├── asyncHandler.js
│   │   │   ├── errorHandler.js
│   │   │   └── logger.js
│   │   └── server.js
│   ├── .env.example
│   ├── package.json
│   └── package-lock.json
├── front/
│   ├── componentes/
│   │   ├── tarjetaSabor.js
│   │   ├── filaPedido.js
│   │   └── resumenPedido.js
│   ├── index.html
│   ├── estilos.css
│   └── app.js
├── HeladeriaDB_Bertorello.sql
├── .gitignore
└── README.md
```

## 4. Funcionalidades principales

- Visualización de los sabores de helado.
- Selección de hasta tres sabores por pedido.
- Identificación y bloqueo de sabores agotados.
- Selección del tamaño Cuarto, Medio o Kilo.
- Resumen del pedido actualizado automáticamente.
- Visualización del precio estimado.
- Registro de pedidos mediante la API.
- Consulta de todos los pedidos registrados.
- Control de estados: Pendiente → Listo → Retirado.
- Contadores de pedidos agrupados por estado.
- Registro de errores y accesos del servidor.
- Interfaz adaptable a computadoras, tablets y celulares.

## 5. Base de datos

**Nombre:** `HeladeriaDB_Bertorello`

### Tablas

| Tabla | Descripción |
|---|---|
| Sabores | Almacena los sabores y su disponibilidad. |
| Pedidos | Guarda cliente, tamaño, precio, fecha y estado. |
| PedidoSabores | Relaciona pedidos y sabores mediante una relación N:M. |

### Procedimientos almacenados

| Procedimiento | Función |
|---|---|
| usp_ListarSabores | Obtiene los sabores registrados. |
| usp_ListarPedidos | Obtiene pedidos y agrupa sus sabores utilizando STRING_AGG. |
| usp_CrearPedido | Valida los sabores mediante STRING_SPLIT, calcula el precio e inserta el pedido dentro de una transacción. |
| usp_AvanzarPedido | Actualiza el estado del pedido según la secuencia permitida. |

### Reglas de negocio

Los pedidos pueden contener entre uno y tres sabores, y todos deben existir y encontrarse disponibles.

El precio definitivo se calcula en SQL Server según el tamaño del pote.

La creación del pedido utiliza una transacción para garantizar que no se guarden registros parciales cuando ocurre un error.

### Errores personalizados

| Código | Descripción |
|---|---|
| 50024 | El pedido indicado no existe. |
| 50025 | El pedido ya fue retirado. |
| 50026 | Algún sabor no existe o no está disponible. |
| 50027 | El pedido debe tener entre uno y tres sabores. |

## 6. Arquitectura del backend

El backend está organizado en capas:

**Routes → Controllers → Services → Config/DB → SQL Server**

Las rutas definen los endpoints disponibles.

Los controladores reciben las solicitudes HTTP, validan los datos y generan las respuestas.

Los servicios ejecutan los procedimientos almacenados de SQL Server.

La conexión a la base de datos se centraliza en `config/db.js`.

También se utiliza `asyncHandler` para capturar errores asincrónicos, un middleware centralizado para responder ante errores y un logger que registra las solicitudes y errores en archivos.

## 7. Endpoints de la API

| Método | Endpoint | Descripción |
|---|---|---|
| GET | /api/sabores | Lista todos los sabores. |
| GET | /api/pedidos | Lista los pedidos registrados. |
| POST | /api/pedidos | Registra un nuevo pedido. |
| PUT | /api/pedidos/:id/avanzar | Avanza el estado de un pedido. |

### Ejemplo de creación de pedido

**POST** `/api/pedidos`

```json
{
  "cliente": "Cliente Prueba",
  "tamanio": "Cuarto",
  "sabores": [1, 2, 3]
}
```

El backend convierte el arreglo de sabores en el texto `"1,2,3"` y lo envía como parámetro al procedimiento almacenado `usp_CrearPedido`.

## 8. Componentes del frontend

El frontend está desarrollado con JavaScript vanilla y utiliza tres componentes principales.

### tarjetaSabor.js

La función `crearTarjetaSabor(sabor, estaSeleccionado)` genera el HTML de una tarjeta.

Según los parámetros recibidos, la tarjeta puede mostrarse seleccionada, disponible o agotada.

### filaPedido.js

La función `crearFilaPedido(pedido)` genera una fila de la tabla de pedidos.

Utiliza internamente el subcomponente `crearBadgeEstado(estado)` para representar visualmente el estado del pedido.

### resumenPedido.js

La función `crearResumenPedido(saboresElegidos, tamanio)` genera el resumen del pedido y muestra el precio estimado.

### Arquitectura estado → render → eventos

El archivo `app.js` mantiene el estado centralizado de la aplicación.

Los eventos modifican el estado y las funciones de renderizado actualizan la interfaz utilizando los componentes.

Los componentes son funciones puras: reciben datos por parámetros y devuelven HTML. No realizan peticiones fetch, no registran eventos ni modifican variables globales.

## 9. Prueba de componente puro

Desde la consola del navegador se ejecutó:

```javascript
crearTarjetaSabor(
    { IdSabor: 99, Nombre: "Prueba", Disponible: true },
    true
)
```

**Resultado:** la función devuelve correctamente el HTML correspondiente a una tarjeta seleccionada.

**¿Por qué demuestra un buen diseño?**

Porque el componente funciona de manera independiente, sin necesitar acceder al DOM, realizar consultas al servidor ni modificar el estado global.

Esto permite reutilizarlo, probarlo de forma aislada y mantener separada la presentación de la lógica de la aplicación.

## 10. Pruebas del sistema

### Pruebas realizadas en SQL Server

| Prueba | Resultado |
|---|---|
| Creación de un pedido válido | Correcto |
| Pedido con cuatro sabores | Error 50027 |
| Pedido con sabor inexistente | Error 50026 |
| Verificación de registros no insertados | Correcto |
| Avance Pendiente → Listo | Correcto |
| Avance Listo → Retirado | Correcto |
| Intento de avanzar un pedido Retirado | Error 50025 |
| Intento de avanzar un pedido inexistente | Error 50024 |
| Listado de sabores | Correcto |
| Listado de pedidos con STRING_AGG | Correcto |

### Pruebas realizadas en la API

- GET `/api/sabores`: respuesta correcta con los sabores registrados.
- GET `/api/pedidos`: respuesta correcta con los pedidos registrados.
- POST con cuatro sabores: HTTP 400, error 50027.
- POST con sabor inexistente: HTTP 400, error 50026.
- PUT con pedido inexistente: HTTP 404, error 50024.
- Registro de errores en `errores.log`.

### Pruebas del frontend

- Selección de sabores y actualización del resumen.
- Visualización del sabor agotado.
- Visualización de pedidos y sus estados.
- Visualización de precios en formato argentino.
- Prueba del componente puro desde la consola del navegador.

## 11. Instalación y ejecución

### Requisitos

- Node.js y npm.
- SQL Server.
- Visual Studio Code.
- Extensión Live Server.

### Paso 1: base de datos

Ejecutar `HeladeriaDB_Bertorello.sql` en SQL Server, utilizando una instancia de prueba cuando sea necesario crear la base desde cero.

### Paso 2: instalar dependencias

Abrir una terminal dentro de `back` y ejecutar:

```bash
npm install
```

### Paso 3: configurar conexión

Crear `back/.env` a partir de `.env.example` y completar los datos correspondientes al servidor local.

```dotenv
DB_USER=prog2
DB_PASSWORD=TU_CONTRASEÑA
DB_SERVER=localhost
DB_DATABASE=HeladeriaDB_Bertorello
DB_PORT=1433
PORT=3000
```

El puerto debe coincidir con el configurado en SQL Server.

El archivo `.env` contiene información privada y no debe publicarse en GitHub.

### Paso 4: iniciar el backend

Desde la carpeta `back`:

```bash
node src/server.js
```

La API estará disponible en:

`http://localhost:3000`

### Paso 5: iniciar el frontend

Abrir `front/index.html` utilizando Live Server desde Visual Studio Code.

La interfaz se comunicará con los endpoints del backend para consultar y registrar pedidos.

## 12. Git y GitHub

El proyecto se organiza en tres commits significativos:

1. **Backend:** API de sabores y pedidos, arquitectura en capas, middlewares y logs.
2. **Frontend:** componentes reutilizables, estado, renderizado y eventos.
3. **Base de datos y documentación:** script SQL y README.

**Repositorio:** https://github.com/nba1985/heladeria_bertorello

---

**Proyecto académico — Programación II — Instituto Superior Villa del Rosario — 2026.**