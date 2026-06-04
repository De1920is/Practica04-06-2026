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

-- 13. Agregar NOT NULL al nombre del paciente.
ALTER TABLE Pacientes
ALTER COLUMN Nombres VARCHAR(100) NOT NULL;
GO

-- 14. Agregar NOT NULL al nombre del médico.
ALTER TABLE Medicos
ALTER COLUMN Nombres VARCHAR(100) NOT NULL;
GO

-- 15. Crear una restricción UNIQUE para el correo del paciente.
ALTER TABLE Pacientes
ADD CONSTRAINT UQ_Pacientes_Email UNIQUE (Email);
GO

-- 16. Crear una restricción UNIQUE para el correo del médico.
ALTER TABLE Medicos
ADD CONSTRAINT UQ_Medicos_Email UNIQUE (Email);
GO

-- 17. Agregar CHECK para edad mayor o igual a 0.
-- Nota: Primero agregamos el campo Edad a la tabla Pacientes.
ALTER TABLE Pacientes
ADD Edad INT;
GO

ALTER TABLE Pacientes
ADD CONSTRAINT CHK_Pacientes_Edad CHECK (Edad >= 0);
GO

-- 18. Agregar CHECK para salario del médico mayor que 0.
-- Nota: Primero agregamos el campo Salario a la tabla Medicos.
ALTER TABLE Medicos
ADD Salario DECIMAL(10,2);
GO

ALTER TABLE Medicos
ADD CONSTRAINT CHK_Medicos_Salario CHECK (Salario > 0);
GO

-- 19. Agregar DEFAULT para fecha de registro.
-- Nota: Agregamos la columna FechaRegistro a Pacientes con valor por defecto la fecha actual.
ALTER TABLE Pacientes
ADD FechaRegistro DATETIME;
GO

ALTER TABLE Pacientes
ADD CONSTRAINT DF_Pacientes_FechaRegistro DEFAULT GETDATE() FOR FechaRegistro;
GO

-- 20. Crear FOREIGN KEY entre Médicos y Especialidades.
ALTER TABLE Medicos
ADD CONSTRAINT FK_Medicos_Especialidades_Mod2 FOREIGN KEY (EspecialidadID) 
REFERENCES Especialidades(EspecialidadID);
GO

-- 21. Crear FOREIGN KEY entre Citas y Pacientes.
ALTER TABLE Citas
ADD CONSTRAINT FK_Citas_Pacientes_Mod2 FOREIGN KEY (PacienteID) 
REFERENCES Pacientes(PacienteID);
GO

-- 22. Crear FOREIGN KEY entre Citas y Médicos.
ALTER TABLE Citas
ADD CONSTRAINT FK_Citas_Medicos_Mod2 FOREIGN KEY (MedicoID) 
REFERENCES Medicos(MedicoID);
GO

-- 23. Crear FOREIGN KEY entre Tratamientos y Pacientes.
ALTER TABLE Tratamientos
ADD CONSTRAINT FK_Tratamientos_Pacientes_Mod2 FOREIGN KEY (PacienteID) 
REFERENCES Pacientes(PacienteID);
GO

-- 24. Crear FOREIGN KEY entre Medicamentos y Tratamientos.
ALTER TABLE Tratamientos
ADD MedicamentoID INT;
GO

ALTER TABLE Tratamientos
ADD CONSTRAINT FK_Tratamientos_Medicamentos FOREIGN KEY (MedicamentoID) 
REFERENCES Medicamentos(MedicamentoID);
GO

-- 25. Crear FOREIGN KEY entre Habitaciones y Pacientes.
ALTER TABLE Pacientes
ADD HabitacionID INT;
GO

ALTER TABLE Pacientes
ADD CONSTRAINT FK_Pacientes_Habitaciones FOREIGN KEY (HabitacionID) 
REFERENCES Habitaciones(HabitacionID);
GO

-- ============================================================================
-- MÓDULO III - MANIPULACIÓN DE DATOS (DML)
-- ============================================================================
-- Guardo los commits por modulo ahora, no por columna. (Nota Enrique)

-- 26. Insertar al menos 5 registros en Especialidades.
INSERT INTO Especialidades (NombreEspecialidad, Descripcion) VALUES
('Cardiologia', 'Estudio y tratamiento de enfermedades del corazon'),
('Pediatria', 'Atencion medica para bebes, ninos y adolescentes'),
('Dermatologia', 'Cuidado y enfermedades de la piel'),
('Ginecologia', 'Salud del sistema reproductor femenino'),
('Medicina General', 'Atencion medica primaria y preventiva');
GO

-- 27. Insertar al menos 5 registros en Medicos.
INSERT INTO Medicos (Nombres, Apellidos, EspecialidadID, Telefono, Email, Salario) VALUES
('Carlos', 'Mendoza', 1, '8888-1111', 'carlos.mendoza@sangrabriel.com', 2500.00),
('Ana', 'Rodriguez', 2, '8888-2222', 'ana.rodriguez@sangrabriel.com', 2200.00),
('Luis', 'Martinez', 3, '8888-3333', 'luis.martinez@sangrabriel.com', 2400.00),
('Sofia', 'Lopez', 4, '8888-4444', 'sofia.lopez@sangrabriel.com', 2600.00),
('Juan', 'Perez', 5, '8888-5555', 'juan.perez@sangrabriel.com', 1800.00);
GO

-- 28. Insertar al menos 5 registros en Habitaciones.
INSERT INTO Habitaciones (NumeroHabitacion, TipoHabitacion, Estado) VALUES
('101', 'Individual', 'Disponible'),
('102', 'Compartida', 'Disponible'),
('201', 'UCI', 'Ocupada'),
('202', 'Individual', 'Disponible'),
('301', 'Compartida', 'Mantenimiento');
GO

-- 29. Insertar al menos 5 registros en Pacientes.
INSERT INTO Pacientes (Nombres, Apellidos, FechaNacimiento, Genero, Direccion, Telefono, Email, Edad, HabitacionID) VALUES
('Alejandro', 'Gomez', '1995-04-12', 'M', 'Managua, Nicaragua', '7777-1111', 'alejandro.gomez@mail.com', 31, 1),
('Maria', 'Vasquez', '2010-08-22', 'F', 'Masaya, Nicaragua', '7777-2222', 'maria.vasquez@mail.com', 15, 2),
('Roberto', 'Castillo', '1978-11-05', 'M', 'Leon, Nicaragua', '7777-3333', 'roberto.castillo@mail.com', 47, 3),
('Elena', 'Torres', '2002-01-30', 'F', 'Granada, Nicaragua', '7777-4444', 'elena.torres@mail.com', 24, 4),
('Ricardo', 'Flores', '1965-06-15', 'M', 'Carazo, Nicaragua', '7777-5555', 'ricardo.flores@mail.com', 60, NULL);
GO

-- 30. Insertar al menos 5 registros en Citas.
INSERT INTO Citas (PacienteID, MedicoID, FechaCita, Motivo, EstadoCita) VALUES
(1, 1, '2026-06-10 09:00:00', 'Chequeo cardiaco general', 'Programada'),
(2, 2, '2026-06-11 10:30:00', 'Control de crecimiento pediatrico', 'Programada'),
(3, 3, '2026-06-12 14:00:00', 'Consulta por dermatitis', 'Programada'),
(4, 4, '2026-06-13 08:15:00', 'Revision ginecologica anual', 'Programada'),
(5, 5, '2026-06-14 11:00:00', 'Sintomas de gripe fuerte', 'Programada');
GO

-- 31. Insertar al menos 5 registros en Medicamentos.
INSERT INTO Medicamentos (NombreMedicamento, ComponenteActivo, Presentacion, Stock, Precio) VALUES
('Paracetamol', 'Acetaminofen', 'Tabletas', 150, 1.50),
('Amoxicilina', 'Amoxicilina trihidrato', 'Capsulas', 80, 4.20),
('Ibuprofeno', 'Ibuprofeno', 'Tabletas', 200, 2.00),
('Loratadina', 'Loratadina', 'Jarabe', 50, 5.50),
('Omeprazol', 'Omeprazol', 'Capsulas', 120, 3.00);
GO

-- 32. Insertar al menos 5 registros en Tratamientos.
INSERT INTO Tratamientos (PacienteID, MedicoID, FechaInicio, FechaFin, Descripcion, MedicamentoID) VALUES
(1, 1, '2026-06-10', '2026-07-10', 'Tratamiento preventivo de hipertension', 3),
(2, 2, '2026-06-11', '2026-06-18', 'Antibiotico para infeccion leve', 2),
(3, 3, '2026-06-12', '2026-06-19', 'Crema topica y antihistaminico', 4),
(4, 4, '2026-06-13', NULL, 'Seguimiento de rutina medica', 1),
(5, 5, '2026-06-14', '2026-06-21', 'Reposo e hidratacion por cuadro gripal', 1);
GO

-- ============================================================================
-- MODIFICACIONES (UPDATE)
-- ============================================================================

-- 33. Modificar el nombre de un paciente específico.
UPDATE Pacientes
SET Nombres = 'Alejandro Jose'
WHERE PacienteID = 1;
GO

-- 34. Modificar el precio de un medicamento específico.
UPDATE Medicamentos
SET Precio = 4.50
WHERE MedicamentoID = 2;
GO