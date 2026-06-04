-- ============================================================================
-- MÓDULO I - CREACIÓN DE BASE DE DATOS (DDL)
-- Proyecto: Hospital San Gabriel
-- ============================================================================

-- 1. Crear una base de datos llamada HospitalDB.
CREATE DATABASE HospitalDB;
GO

-- 2. Mostrar todas las bases de datos existentes.
SELECT name FROM sys.databases;
GO

-- 3. Seleccionar HospitalDB para trabajar.
USE HospitalDB;
GO


-- 4. Crear la tabla Especialidades.
-- Nota: La creamos primero porque Medicos depende de ella.
CREATE TABLE Especialidades (
    EspecialidadID INT IDENTITY(1,1) PRIMARY KEY,
    NombreEspecialidad VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL
);
GO

-- 5. Crear la tabla Medicos.
CREATE TABLE Medicos (
    MedicoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    EspecialidadID INT NOT NULL,
    Telefono VARCHAR(20) NULL,
    Email VARCHAR(100) NULL,
    CONSTRAINT FK_Medicos_Especialidades FOREIGN KEY (EspecialidadID) 
        REFERENCES Especialidades(EspecialidadID)
);
GO