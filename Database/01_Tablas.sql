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