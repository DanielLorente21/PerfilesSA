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