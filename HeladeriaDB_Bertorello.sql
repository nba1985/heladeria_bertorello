IF DB_ID(N'HeladeriaDB_Bertorello') IS NULL
    EXEC(N'CREATE DATABASE HeladeriaDB_Bertorello');
GO

USE HeladeriaDB_Bertorello;
GO

IF OBJECT_ID(N'dbo.Sabores', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Sabores (
        IdSabor INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Sabores PRIMARY KEY,
        Nombre NVARCHAR(50) NOT NULL,
        Disponible BIT NOT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.Pedidos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Pedidos (
        IdPedido INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Pedidos PRIMARY KEY,
        Cliente NVARCHAR(80) NOT NULL,
        Tamanio NVARCHAR(10) NOT NULL,
        PrecioTotal DECIMAL(12,2) NOT NULL,
        Estado NVARCHAR(20) NOT NULL,
        Fecha DATETIME NOT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.PedidoSabores', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PedidoSabores (
        IdPedido INT NOT NULL,
        IdSabor INT NOT NULL,
        CONSTRAINT PK_PedidoSabores PRIMARY KEY (IdPedido, IdSabor),
        CONSTRAINT FK_PedidoSabores_Pedidos FOREIGN KEY (IdPedido) REFERENCES dbo.Pedidos(IdPedido),
        CONSTRAINT FK_PedidoSabores_Sabores FOREIGN KEY (IdSabor) REFERENCES dbo.Sabores(IdSabor)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.Sabores') AND type = 'UQ' AND name = N'UQ_Sabores_Nombre')
    ALTER TABLE dbo.Sabores ADD CONSTRAINT UQ_Sabores_Nombre UNIQUE (Nombre);
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.Pedidos') AND name = N'CK_Pedidos_Tamanio')
    ALTER TABLE dbo.Pedidos ADD CONSTRAINT CK_Pedidos_Tamanio CHECK (Tamanio IN (N'Cuarto', N'Medio', N'Kilo'));
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.Pedidos') AND name = N'CK_Pedidos_Estado')
    ALTER TABLE dbo.Pedidos ADD CONSTRAINT CK_Pedidos_Estado CHECK (Estado IN (N'Pendiente', N'Listo', N'Retirado'));
GO

IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.Pedidos') AND name = N'DF_Pedidos_Estado')
    ALTER TABLE dbo.Pedidos ADD CONSTRAINT DF_Pedidos_Estado DEFAULT N'Pendiente' FOR Estado;
GO

IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID(N'dbo.Pedidos') AND name = N'DF_Pedidos_Fecha')
    ALTER TABLE dbo.Pedidos ADD CONSTRAINT DF_Pedidos_Fecha DEFAULT SYSDATETIME() FOR Fecha;
GO

SET IDENTITY_INSERT dbo.Sabores ON;
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 1)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (1, N'Dulce de leche granizado', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 2)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (2, N'Chocolate con almendras', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 3)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (3, N'Frutilla a la crema', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 4)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (4, N'Limón', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 5)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (5, N'Sambayón', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 6)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (6, N'Menta granizada', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 7)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (7, N'Crema americana', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 8)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (8, N'Banana split', 0);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 9)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (9, N'Frambuesa', 1);
IF NOT EXISTS (SELECT 1 FROM dbo.Sabores WHERE IdSabor = 10)
    INSERT INTO [dbo].[Sabores] ([IdSabor], [Nombre], [Disponible]) VALUES (10, N'Mascarpone con frutos rojos', 1);
SET IDENTITY_INSERT dbo.Sabores OFF;
GO

SET IDENTITY_INSERT dbo.Pedidos ON;
IF NOT EXISTS (SELECT 1 FROM dbo.Pedidos WHERE IdPedido = 1)
    INSERT INTO [dbo].[Pedidos] ([IdPedido], [Cliente], [Tamanio], [PrecioTotal], [Estado], [Fecha]) VALUES (1, N'Griselda Pereyra', N'Kilo', CAST(30500.00 AS Decimal(12, 2)), N'Retirado', CAST(N'2026-09-28T16:53:48.463' AS DateTime));
IF NOT EXISTS (SELECT 1 FROM dbo.Pedidos WHERE IdPedido = 2)
    INSERT INTO [dbo].[Pedidos] ([IdPedido], [Cliente], [Tamanio], [PrecioTotal], [Estado], [Fecha]) VALUES (2, N'Fabián Torres', N'Medio', CAST(17800.00 AS Decimal(12, 2)), N'Listo', CAST(N'2026-09-30T13:53:48.463' AS DateTime));
IF NOT EXISTS (SELECT 1 FROM dbo.Pedidos WHERE IdPedido = 3)
    INSERT INTO [dbo].[Pedidos] ([IdPedido], [Cliente], [Tamanio], [PrecioTotal], [Estado], [Fecha]) VALUES (3, N'Lucía Bengolea', N'Cuarto', CAST(9800.00 AS Decimal(12, 2)), N'Pendiente', CAST(N'2026-09-30T16:13:48.463' AS DateTime));
IF NOT EXISTS (SELECT 1 FROM dbo.Pedidos WHERE IdPedido = 4)
    INSERT INTO [dbo].[Pedidos] ([IdPedido], [Cliente], [Tamanio], [PrecioTotal], [Estado], [Fecha]) VALUES (4, N'Marta Ricotti', N'Kilo', CAST(30500.00 AS Decimal(12, 2)), N'Pendiente', CAST(N'2026-09-30T16:41:48.463' AS DateTime));
IF NOT EXISTS (SELECT 1 FROM dbo.Pedidos WHERE IdPedido = 5)
    INSERT INTO [dbo].[Pedidos] ([IdPedido], [Cliente], [Tamanio], [PrecioTotal], [Estado], [Fecha]) VALUES (5, N'Cliente Prueba', N'Cuarto', CAST(9800.00 AS Decimal(12, 2)), N'Retirado', CAST(N'2026-10-12T10:49:56.370' AS DateTime));
IF NOT EXISTS (SELECT 1 FROM dbo.Pedidos WHERE IdPedido = 6)
    INSERT INTO [dbo].[Pedidos] ([IdPedido], [Cliente], [Tamanio], [PrecioTotal], [Estado], [Fecha]) VALUES (6, N'Prueba Backend', N'Cuarto', CAST(9800.00 AS Decimal(12, 2)), N'Pendiente', CAST(N'2026-10-12T11:46:50.307' AS DateTime));
IF NOT EXISTS (SELECT 1 FROM dbo.Pedidos WHERE IdPedido = 7)
    INSERT INTO [dbo].[Pedidos] ([IdPedido], [Cliente], [Tamanio], [PrecioTotal], [Estado], [Fecha]) VALUES (7, N'Nicolas Bertorello', N'Kilo', CAST(30500.00 AS Decimal(12, 2)), N'Retirado', CAST(N'2026-10-12T12:22:52.147' AS DateTime));
SET IDENTITY_INSERT dbo.Pedidos OFF;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 1 AND IdSabor = 1)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (1, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 1 AND IdSabor = 2)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (1, 2);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 1 AND IdSabor = 5)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (1, 5);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 2 AND IdSabor = 3)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (2, 3);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 2 AND IdSabor = 7)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (2, 7);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 3 AND IdSabor = 1)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (3, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 4 AND IdSabor = 2)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (4, 2);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 4 AND IdSabor = 6)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (4, 6);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 4 AND IdSabor = 9)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (4, 9);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 5 AND IdSabor = 1)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (5, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 5 AND IdSabor = 2)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (5, 2);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 5 AND IdSabor = 3)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (5, 3);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 6 AND IdSabor = 1)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (6, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 6 AND IdSabor = 2)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (6, 2);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 6 AND IdSabor = 3)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (6, 3);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 7 AND IdSabor = 1)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (7, 1);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 7 AND IdSabor = 3)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (7, 3);
IF NOT EXISTS (SELECT 1 FROM dbo.PedidoSabores WHERE IdPedido = 7 AND IdSabor = 4)
    INSERT INTO [dbo].[PedidoSabores] ([IdPedido], [IdSabor]) VALUES (7, 4);
GO

CREATE OR ALTER PROCEDURE dbo.usp_AvanzarPedido
    @IdPedido INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @Estado NVARCHAR(20);

        SELECT @Estado = Estado 
		FROM dbo.Pedidos 
		WHERE IdPedido = @IdPedido;

        IF @Estado IS NULL
        BEGIN
            THROW 50024, N'El pedido indicado no existe.', 1;
        END;

        IF @Estado = N'Retirado'
        BEGIN
            THROW 50025, N'El pedido ya fue retirado: no hay más pasos.', 1;
        END;

        UPDATE dbo.Pedidos
        SET Estado = CASE Estado
            WHEN N'Pendiente' THEN N'Listo'
            ELSE N'Retirado'
        END
        WHERE IdPedido = @IdPedido;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_CrearPedido
    @Cliente  NVARCHAR(80),
    @Tamanio  NVARCHAR(10),
    @Sabores  NVARCHAR(50),
    @IdPedido INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Cliente IS NULL OR LTRIM(RTRIM(@Cliente)) = N''
        BEGIN
            THROW 50020, N'El nombre del cliente no puede estar vacío.', 1;
        END;

        IF @Tamanio NOT IN (N'Cuarto', N'Medio', N'Kilo')
        BEGIN
            THROW 50020, N'El tamaño debe ser Cuarto, Medio o Kilo.', 1;
        END;

        
        DECLARE @CantSabores INT;
        SELECT @CantSabores = COUNT(*)
        FROM STRING_SPLIT(@Sabores, N',');

        IF @CantSabores < 1 OR @CantSabores > 3
        BEGIN
            THROW 50027, N'El pedido debe tener entre 1 y 3 sabores.', 1;
        END;

        
        IF EXISTS (
            SELECT 1
            FROM STRING_SPLIT(@Sabores, N',') AS SS
            LEFT JOIN dbo.Sabores AS S
                ON S.IdSabor = TRY_CAST(SS.value AS INT)
            WHERE S.IdSabor IS NULL OR S.Disponible = 0
        )
        BEGIN
            THROW 50026, N'Algún sabor elegido no existe o no está disponible.', 1;
        END;

        
        DECLARE @Precio DECIMAL(12, 2) =
            CASE @Tamanio
                WHEN N'Cuarto' THEN 9800.00
                WHEN N'Medio'  THEN 17800.00
                ELSE 30500.00
            END;

        INSERT INTO dbo.Pedidos (Cliente, Tamanio, PrecioTotal)
        VALUES (LTRIM(RTRIM(@Cliente)), @Tamanio, @Precio);

        SET @IdPedido = SCOPE_IDENTITY();

        
        INSERT INTO dbo.PedidoSabores (IdPedido, IdSabor)
        SELECT DISTINCT @IdPedido, TRY_CAST(SS.value AS INT)
        FROM STRING_SPLIT(@Sabores, N',') AS SS;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ListarPedidos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.IdPedido,
        P.Cliente,
        P.Tamanio,
        P.PrecioTotal,
        P.Estado,
        P.Fecha,
        STRING_AGG(S.Nombre, N', ') AS Sabores
    FROM dbo.Pedidos AS P
    INNER JOIN dbo.PedidoSabores AS PS ON PS.IdPedido = P.IdPedido
    INNER JOIN dbo.Sabores AS S ON S.IdSabor = PS.IdSabor
    GROUP BY P.IdPedido, P.Cliente, P.Tamanio, P.PrecioTotal, P.Estado, P.Fecha
    ORDER BY
        CASE P.Estado
            WHEN N'Pendiente' THEN 1
            WHEN N'Listo' THEN 2
            ELSE 3
        END ASC,
        P.Fecha DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ListarSabores
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdSabor, Nombre, Disponible
    FROM dbo.Sabores
    ORDER BY Nombre ASC;
END;
GO
