USE PerfilesSA_DB;
GO

-- SP Empleado Insertar
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

-- SP Empleado Actualizar
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

-- SP Empleado CambiarEstado
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

-- SP Empleado ObtenerPorId (con Edad y Antiguedad en tiempo real)
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

-- SP Empleado ObtenerTodos
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

-- SP Empleado ReportePorDepartamento (con filtros opcionales)
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
