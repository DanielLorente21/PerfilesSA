-- ============================================================
-- Script_Completo.sql
-- Sistema PerfilesSA - Prueba Tecnica PRECREDIT/SSASA
-- Ejecutar este script completo en SQL Server Management Studio
-- para crear la base de datos, tablas y stored procedures.
-- ============================================================

USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PerfilesSA_DB')
BEGIN
    CREATE DATABASE PerfilesSA_DB;
END
GO

USE PerfilesSA_DB;
GO

-- TABLA: Departamento
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Departamento')
    DROP TABLE Departamento;
GO

CREATE TABLE Departamento (
    IdDepartamento      INT IDENTITY(1,1)   NOT NULL,
    NombreDepartamento  VARCHAR(100)        NOT NULL,
    Activo              BIT                 NOT NULL DEFAULT(1),
    FechaCreacion       DATETIME            NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT PK_Departamento PRIMARY KEY (IdDepartamento),
    CONSTRAINT UQ_Departamento_Nombre UNIQUE (NombreDepartamento)
);
GO

-- TABLA: Empleado
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Empleado')
    DROP TABLE Empleado;
GO

CREATE TABLE Empleado (
    IdEmpleado          INT IDENTITY(1,1)   NOT NULL,
    Nombres             VARCHAR(150)        NOT NULL,
    DPI                 VARCHAR(13)         NOT NULL,
    FechaNacimiento     DATE                NOT NULL,
    Sexo                CHAR(1)             NOT NULL,
    FechaIngreso        DATE                NOT NULL,
    Direccion           VARCHAR(250)        NULL,
    NIT                 VARCHAR(15)         NULL,
    IdDepartamento      INT                 NOT NULL,
    Activo              BIT                 NOT NULL DEFAULT(1),
    FechaCreacion       DATETIME            NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT PK_Empleado PRIMARY KEY (IdEmpleado),
    CONSTRAINT UQ_Empleado_DPI UNIQUE (DPI),
    CONSTRAINT FK_Empleado_Departamento FOREIGN KEY (IdDepartamento)
        REFERENCES Departamento(IdDepartamento),
    CONSTRAINT CK_Empleado_Sexo CHECK (Sexo IN ('M','F'))
);
GO

CREATE INDEX IX_Empleado_Departamento ON Empleado(IdDepartamento);
CREATE INDEX IX_Empleado_FechaIngreso ON Empleado(FechaIngreso);
GO

PRINT 'Tablas creadas correctamente.';
GO
USE PerfilesSA_DB;
GO

-- SP_Departamento_Insertar
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Departamento_Insertar')
    DROP PROCEDURE SP_Departamento_Insertar;
GO

CREATE PROCEDURE SP_Departamento_Insertar
    @NombreDepartamento VARCHAR(100),
    @IdDepartamentoOut  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Departamento WHERE NombreDepartamento = @NombreDepartamento)
    BEGIN
        RAISERROR('Ya existe un departamento con ese nombre.', 16, 1);
        RETURN;
    END

    INSERT INTO Departamento (NombreDepartamento, Activo)
    VALUES (@NombreDepartamento, 1);

    SET @IdDepartamentoOut = SCOPE_IDENTITY();
END
GO

-- SP_Departamento_Actualizar
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Departamento_Actualizar')
    DROP PROCEDURE SP_Departamento_Actualizar;
GO

CREATE PROCEDURE SP_Departamento_Actualizar
    @IdDepartamento     INT,
    @NombreDepartamento VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Departamento WHERE IdDepartamento = @IdDepartamento)
    BEGIN
        RAISERROR('El departamento no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Departamento
               WHERE NombreDepartamento = @NombreDepartamento
                 AND IdDepartamento <> @IdDepartamento)
    BEGIN
        RAISERROR('Ya existe otro departamento con ese nombre.', 16, 1);
        RETURN;
    END

    UPDATE Departamento
       SET NombreDepartamento = @NombreDepartamento
     WHERE IdDepartamento = @IdDepartamento;
END
GO

-- SP_Departamento_CambiarEstado (con cascada a empleados)
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Departamento_CambiarEstado')
    DROP PROCEDURE SP_Departamento_CambiarEstado;
GO

CREATE PROCEDURE SP_Departamento_CambiarEstado
    @IdDepartamento INT,
    @Activo         BIT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Departamento WHERE IdDepartamento = @IdDepartamento)
        BEGIN
            RAISERROR('El departamento no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE Departamento
           SET Activo = @Activo
         WHERE IdDepartamento = @IdDepartamento;

        IF @Activo = 0
        BEGIN
            UPDATE Empleado
               SET Activo = 0
             WHERE IdDepartamento = @IdDepartamento;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- SP_Departamento_ObtenerTodos
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Departamento_ObtenerTodos')
    DROP PROCEDURE SP_Departamento_ObtenerTodos;
GO

CREATE PROCEDURE SP_Departamento_ObtenerTodos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdDepartamento, NombreDepartamento, Activo, FechaCreacion
      FROM Departamento
     ORDER BY NombreDepartamento;
END
GO

-- SP_Departamento_ObtenerActivos
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Departamento_ObtenerActivos')
    DROP PROCEDURE SP_Departamento_ObtenerActivos;
GO

CREATE PROCEDURE SP_Departamento_ObtenerActivos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdDepartamento, NombreDepartamento
      FROM Departamento
     WHERE Activo = 1
     ORDER BY NombreDepartamento;
END
GO

-- SP_Departamento_ObtenerPorId
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Departamento_ObtenerPorId')
    DROP PROCEDURE SP_Departamento_ObtenerPorId;
GO

CREATE PROCEDURE SP_Departamento_ObtenerPorId
    @IdDepartamento INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdDepartamento, NombreDepartamento, Activo, FechaCreacion
      FROM Departamento
     WHERE IdDepartamento = @IdDepartamento;
END
GO

PRINT 'Stored Procedures de Departamento creados correctamente.';
GO
USE PerfilesSA_DB;
GO

-- SP_Empleado_Insertar
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Empleado_Insertar')
    DROP PROCEDURE SP_Empleado_Insertar;
GO

CREATE PROCEDURE SP_Empleado_Insertar
    @Nombres            VARCHAR(150),
    @DPI                VARCHAR(13),
    @FechaNacimiento    DATE,
    @Sexo               CHAR(1),
    @FechaIngreso       DATE,
    @Direccion          VARCHAR(250) = NULL,
    @NIT                VARCHAR(15)  = NULL,
    @IdDepartamento     INT,
    @IdEmpleadoOut      INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Empleado WHERE DPI = @DPI)
    BEGIN
        RAISERROR('Ya existe un empleado registrado con ese DPI.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Departamento WHERE IdDepartamento = @IdDepartamento AND Activo = 1)
    BEGIN
        RAISERROR('El departamento no existe o se encuentra inactivo.', 16, 1);
        RETURN;
    END

    INSERT INTO Empleado
        (Nombres, DPI, FechaNacimiento, Sexo, FechaIngreso, Direccion, NIT, IdDepartamento, Activo)
    VALUES
        (@Nombres, @DPI, @FechaNacimiento, @Sexo, @FechaIngreso, @Direccion, @NIT, @IdDepartamento, 1);

    SET @IdEmpleadoOut = SCOPE_IDENTITY();
END
GO

-- SP_Empleado_Actualizar
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Empleado_Actualizar')
    DROP PROCEDURE SP_Empleado_Actualizar;
GO

CREATE PROCEDURE SP_Empleado_Actualizar
    @IdEmpleado         INT,
    @Nombres            VARCHAR(150),
    @DPI                VARCHAR(13),
    @FechaNacimiento    DATE,
    @Sexo               CHAR(1),
    @FechaIngreso       DATE,
    @Direccion          VARCHAR(250) = NULL,
    @NIT                VARCHAR(15)  = NULL,
    @IdDepartamento     INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        RAISERROR('El empleado no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Empleado WHERE DPI = @DPI AND IdEmpleado <> @IdEmpleado)
    BEGIN
        RAISERROR('Ya existe otro empleado registrado con ese DPI.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Departamento WHERE IdDepartamento = @IdDepartamento AND Activo = 1)
    BEGIN
        RAISERROR('El departamento no existe o se encuentra inactivo.', 16, 1);
        RETURN;
    END

    UPDATE Empleado
       SET Nombres         = @Nombres,
           DPI             = @DPI,
           FechaNacimiento = @FechaNacimiento,
           Sexo            = @Sexo,
           FechaIngreso    = @FechaIngreso,
           Direccion       = @Direccion,
           NIT             = @NIT,
           IdDepartamento  = @IdDepartamento
     WHERE IdEmpleado = @IdEmpleado;
END
GO

-- SP_Empleado_CambiarEstado
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Empleado_CambiarEstado')
    DROP PROCEDURE SP_Empleado_CambiarEstado;
GO

CREATE PROCEDURE SP_Empleado_CambiarEstado
    @IdEmpleado INT,
    @Activo     BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
    BEGIN
        RAISERROR('El empleado no existe.', 16, 1);
        RETURN;
    END

    UPDATE Empleado
       SET Activo = @Activo
     WHERE IdEmpleado = @IdEmpleado;
END
GO

-- SP_Empleado_ObtenerPorId (con Edad y Antigüedad en tiempo real)
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Empleado_ObtenerPorId')
    DROP PROCEDURE SP_Empleado_ObtenerPorId;
GO

CREATE PROCEDURE SP_Empleado_ObtenerPorId
    @IdEmpleado INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.IdEmpleado,
        E.Nombres,
        E.DPI,
        E.FechaNacimiento,
        E.Sexo,
        E.FechaIngreso,
        E.Direccion,
        E.NIT,
        E.IdDepartamento,
        D.NombreDepartamento,
        E.Activo,
        (DATEDIFF(YEAR, E.FechaNacimiento, GETDATE())
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.FechaNacimiento, GETDATE()), E.FechaNacimiento) > GETDATE()
                THEN 1 ELSE 0
              END) AS Edad,
        (DATEDIFF(YEAR, E.FechaIngreso, GETDATE())
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.FechaIngreso, GETDATE()), E.FechaIngreso) > GETDATE()
                THEN 1 ELSE 0
              END) AS AntiguedadAnios
    FROM Empleado E
    INNER JOIN Departamento D ON D.IdDepartamento = E.IdDepartamento
    WHERE E.IdEmpleado = @IdEmpleado;
END
GO

-- SP_Empleado_ObtenerTodos
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Empleado_ObtenerTodos')
    DROP PROCEDURE SP_Empleado_ObtenerTodos;
GO

CREATE PROCEDURE SP_Empleado_ObtenerTodos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.IdEmpleado,
        E.Nombres,
        E.DPI,
        E.FechaNacimiento,
        E.Sexo,
        E.FechaIngreso,
        E.Direccion,
        E.NIT,
        E.IdDepartamento,
        D.NombreDepartamento,
        E.Activo,
        (DATEDIFF(YEAR, E.FechaNacimiento, GETDATE())
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.FechaNacimiento, GETDATE()), E.FechaNacimiento) > GETDATE()
                THEN 1 ELSE 0
              END) AS Edad,
        (DATEDIFF(YEAR, E.FechaIngreso, GETDATE())
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.FechaIngreso, GETDATE()), E.FechaIngreso) > GETDATE()
                THEN 1 ELSE 0
              END) AS AntiguedadAnios
    FROM Empleado E
    INNER JOIN Departamento D ON D.IdDepartamento = E.IdDepartamento
    ORDER BY E.Nombres;
END
GO

-- SP_Empleado_ReportePorDepartamento (con filtros opcionales)
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_Empleado_ReportePorDepartamento')
    DROP PROCEDURE SP_Empleado_ReportePorDepartamento;
GO

CREATE PROCEDURE SP_Empleado_ReportePorDepartamento
    @IdDepartamento     INT  = NULL,
    @FechaIngresoDesde  DATE = NULL,
    @FechaIngresoHasta  DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.IdEmpleado,
        E.Nombres,
        E.DPI,
        E.FechaNacimiento,
        E.FechaIngreso,
        D.NombreDepartamento,
        E.Activo,
        (DATEDIFF(YEAR, E.FechaNacimiento, GETDATE())
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.FechaNacimiento, GETDATE()), E.FechaNacimiento) > GETDATE()
                THEN 1 ELSE 0
              END) AS Edad,
        (DATEDIFF(YEAR, E.FechaIngreso, GETDATE())
            - CASE
                WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.FechaIngreso, GETDATE()), E.FechaIngreso) > GETDATE()
                THEN 1 ELSE 0
              END) AS AntiguedadAnios
    FROM Empleado E
    INNER JOIN Departamento D ON D.IdDepartamento = E.IdDepartamento
    WHERE (@IdDepartamento IS NULL OR E.IdDepartamento = @IdDepartamento)
      AND (@FechaIngresoDesde IS NULL OR E.FechaIngreso >= @FechaIngresoDesde)
      AND (@FechaIngresoHasta IS NULL OR E.FechaIngreso <= @FechaIngresoHasta)
    ORDER BY D.NombreDepartamento, E.Nombres;
END
GO

PRINT 'Stored Procedures de Empleado creados correctamente.';
GO