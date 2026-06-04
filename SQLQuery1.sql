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

-- 6. Crear la tabla Pacientes.
CREATE TABLE Pacientes (
    PacienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombres VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Genero CHAR(1) CHECK (Genero IN ('M', 'F')),
    Direccion VARCHAR(255) NULL,
    Telefono VARCHAR(20) NULL,
    Email VARCHAR(100) NULL
);
GO

-- 7. Crear la tabla Habitaciones.
CREATE TABLE Habitaciones (
    HabitacionID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroHabitacion VARCHAR(10) NOT NULL UNIQUE,
    TipoHabitacion VARCHAR(50) NOT NULL, -- Ej: Individual, Compartida, UCI
    Estado VARCHAR(20) DEFAULT 'Disponible' CHECK (Estado IN ('Disponible', 'Ocupada', 'Mantenimiento'))
);
GO

-- 8. Crear la tabla Citas.
CREATE TABLE Citas (
    CitaID INT IDENTITY(1,1) PRIMARY KEY,
    PacienteID INT NOT NULL,
    MedicoID INT NOT NULL,
    FechaCita DATETIME NOT NULL,
    Motivo VARCHAR(255) NULL,
    EstadoCita VARCHAR(20) DEFAULT 'Programada' CHECK (EstadoCita IN ('Programada', 'Completada', 'Cancelada')),
    CONSTRAINT FK_Citas_Pacientes FOREIGN KEY (PacienteID) REFERENCES Pacientes(PacienteID),
    CONSTRAINT FK_Citas_Medicos FOREIGN KEY (MedicoID) REFERENCES Medicos(MedicoID)
);
GO

-- 9. Crear la tabla Medicamentos.
CREATE TABLE Medicamentos (
    MedicamentoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreMedicamento VARCHAR(100) NOT NULL,
    ComponenteActivo VARCHAR(100) NULL,
    Presentacion VARCHAR(50) NULL, -- Ej: Tabletas, Jarabe, Inyectable
    Stock INT DEFAULT 0,
    Precio DECIMAL(10,2) NOT NULL
);
GO

-- 10. Crear la tabla Tratamientos.
CREATE TABLE Tratamientos (
    TratamientoID INT IDENTITY(1,1) PRIMARY KEY,
    PacienteID INT NOT NULL,
    MedicoID INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    Descripcion VARCHAR(500) NOT NULL,
    CONSTRAINT FK_Tratamientos_Pacientes FOREIGN KEY (PacienteID) REFERENCES Pacientes(PacienteID),
    CONSTRAINT FK_Tratamientos_Medicos FOREIGN KEY (MedicoID) REFERENCES Medicos(MedicoID)
);
GO

-- ============================================================================
-- MÓDULO II - RESTRICCIONES (DDL)
-- ============================================================================

-- 11. Definir PRIMARY KEY en Pacientes.
ALTER TABLE Pacientes
ADD CONSTRAINT PK_Pacientes PRIMARY KEY (PacienteID);
GO

-- 12. Definir PRIMARY KEY en Médicos.
ALTER TABLE Medicos
ADD CONSTRAINT PK_Medicos PRIMARY KEY (MedicoID);
GO