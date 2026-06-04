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

-- ============================================================================
-- MÓDULO IV - ELIMINACIÓN DE OBJETOS (DROP)
-- ============================================================================

-- 41. Eliminar una tabla temporal.
CREATE TABLE #TablaTemporal (ID INT);
DROP TABLE #TablaTemporal;
GO

-- 42. Eliminar una restricción CHECK.
ALTER TABLE Pacientes DROP CONSTRAINT CHK_Pacientes_Edad;
GO

-- 43. Eliminar una restricción UNIQUE.
ALTER TABLE Medicos DROP CONSTRAINT UQ_Medicos_Email;
GO

-- 44. Eliminar una columna.
ALTER TABLE Pacientes DROP COLUMN Telefono;
GO

-- 45. Eliminar una tabla de pruebas.
CREATE TABLE TablaPruebas (ID INT);
DROP TABLE TablaPruebas;
GO

-- 46. Crear y eliminar una tabla Auditoria.
CREATE TABLE Auditoria (ID INT, Accion VARCHAR(50));
DROP TABLE Auditoria;
GO

-- 47. Crear y eliminar una tabla Logs.
CREATE TABLE Logs (ID INT, Detalle VARCHAR(100));
DROP TABLE Logs;
GO

-- 48. Eliminar una FOREIGN KEY.
ALTER TABLE Tratamientos DROP CONSTRAINT FK_Tratamientos_Medicamentos;
GO

-- 49. Eliminar una tabla MedicamentosPrueba.
CREATE TABLE MedicamentosPrueba (ID INT);
DROP TABLE MedicamentosPrueba;
GO

-- 50. Eliminar una base de datos de pruebas.
CREATE DATABASE HospitalPruebasDB;
GO
DROP DATABASE HospitalPruebasDB;
GO

Aquí tienes el script correspondiente al Módulo V: Insert, estructurado de forma limpia y directa para que puedas continuar agregando tus bloques y generando tus commits individuales uno por uno.

SQL
-- ============================================================================
-- MÓDULO V - INSERCIÓN DE DATOS (INSERT)
-- ============================================================================

-- 51. Insertar 5 especialidades médicas.
INSERT INTO Especialidades (NombreEspecialidad, Descripcion) VALUES
('Cardiologia', 'Enfermedades del corazon'),
('Pediatria', 'Atencion infantil'),
('Dermatologia', 'Problemas de la piel'),
('Ginecologia', 'Salud femenina'),
('Medicina General', 'Consulta primaria');
GO

-- 52. Insertar 10 médicos.
INSERT INTO Medicos (Nombres, Apellidos, EspecialidadID, Telefono, Email, Salario) VALUES
('Carlos', 'Mendoza', 1, '8888-1111', 'carlos.m@mail.com', 2500),
('Ana', 'Rodriguez', 2, '8888-2222', 'ana.r@mail.com', 2200),
('Luis', 'Martinez', 3, '8888-3333', 'luis.m@mail.com', 2400),
('Sofia', 'Lopez', 4, '8888-4444', 'sofia.l@mail.com', 2600),
('Juan', 'Perez', 5, '8888-5555', 'juan.p@mail.com', 1800),
('Elena', 'Guerra', 1, '8888-6666', 'elena.g@mail.com', 2700),
('Pedro', 'Castro', 2, '8888-7777', 'pedro.c@mail.com', 2300),
('Laura', 'Rizo', 3, '8888-8888', 'laura.r@mail.com', 2450),
('Diego', 'Mejia', 4, '8888-9999', 'diego.m@mail.com', 2650),
('Marta', 'Benavidez', 5, '8888-0000', 'marta.b@mail.com', 1900);
GO

-- 53. Insertar 20 pacientes.
INSERT INTO Pacientes (Nombres, Apellidos, FechaNacimiento, Genero, Direccion, Telefono, Email, Edad) VALUES
('Alejandro', 'Gomez', '1995-04-12', 'M', 'Managua', '7777-0101', 'ale.g@mail.com', 31),
('Maria', 'Vasquez', '2010-08-22', 'F', 'Masaya', '7777-0202', 'mar.v@mail.com', 15),
('Roberto', 'Castillo', '1978-11-05', 'M', 'Leon', '7777-0303', 'rob.c@mail.com', 47),
('Elena', 'Torres', '2002-01-30', 'F', 'Granada', '7777-0404', 'ele.t@mail.com', 24),
('Ricardo', 'Flores', '1965-06-15', 'M', 'Carazo', '7777-0505', 'ric.f@mail.com', 60),
('Julia', 'Miranda', '1990-09-18', 'F', 'Managua', '7777-0606', 'jul.m@mail.com', 35),
('Fernando', 'Reyes', '1985-03-25', 'M', 'Chinandega', '7777-0707', 'fer.r@mail.com', 41),
('Gabriela', 'Duarte', '2015-07-14', 'F', 'Esteli', '7777-0808', 'gaby.d@mail.com', 10),
('Manuel', 'Espinoza', '1950-12-01', 'M', 'Matagalpa', '7777-0909', 'man.e@mail.com', 75),
('Patricia', 'Solis', '1998-05-20', 'F', 'Managua', '7777-1010', 'pat.s@mail.com', 28),
('Jorge', 'Alvarado', '1993-02-11', 'M', 'Leon', '7777-1111', 'jorg.a@mail.com', 33),
('Natalia', 'Ortega', '2005-10-05', 'F', 'Masaya', '7777-1212', 'nat.o@mail.com', 20),
('Sergio', 'Salinas', '1972-08-19', 'M', 'Managua', '7777-1313', 'serg.s@mail.com', 53),
('Clara', 'Montenegro', '1988-04-23', 'F', 'Granada', '7777-1414', 'clar.m@mail.com', 38),
('Andres', 'Bermudez', '2012-01-15', 'M', 'Carazo', '7777-1515', 'andr.b@mail.com', 14),
('Alicia', 'Chavarria', '1960-06-30', 'F', 'Chinandega', '7777-1616', 'alic.c@mail.com', 65),
('Gustavo', 'Obando', '1999-11-22', 'M', 'Esteli', '7777-1717', 'gust.o@mail.com', 26),
('Beatriz', 'Gaitan', '2001-03-08', 'F', 'Matagalpa', '7777-1818', 'beat.g@mail.com', 25),
('Hector', 'Carcamo', '1945-07-17', 'M', 'Managua', '7777-1919', 'hect.c@mail.com', 80),
('Veronica', 'Diaz', '1992-10-29', 'F', 'Rivas', '7777-2020', 'vero.d@mail.com', 33);
GO

-- 54. Insertar 15 citas.
INSERT INTO Citas (PacienteID, MedicoID, FechaCita, Motivo, EstadoCita) VALUES
(1, 1, '2026-06-10 09:00', 'Chequeo', 'Programada'),
(2, 2, '2026-06-11 10:30', 'Control', 'Programada'),
(3, 3, '2026-06-12 14:00', 'Consulta', 'Programada'),
(4, 4, '2026-06-13 08:15', 'Revision', 'Programada'),
(5, 5, '2026-06-14 11:00', 'Gripe', 'Programada'),
(6, 6, '2026-06-15 09:30', 'Presion alta', 'Programada'),
(7, 7, '2026-06-16 13:00', 'Fiebre', 'Programada'),
(8, 8, '2026-06-17 15:15', 'Alergia', 'Programada'),
(9, 9, '2026-06-18 10:00', 'Control', 'Programada'),
(10, 10, '2026-06-19 16:30', 'Malestar', 'Programada'),
(11, 1, '2026-06-20 11:15', 'Arritmia', 'Programada'),
(12, 2, '2026-06-21 08:45', 'Chequeo', 'Programada'),
(13, 3, '2026-06-22 14:30', 'Consulta', 'Programada'),
(14, 4, '2026-06-23 10:45', 'Revision', 'Programada'),
(15, 5, '2026-06-24 12:00', 'Control', 'Programada');
GO

-- 55. Insertar 10 habitaciones.
INSERT INTO Habitaciones (NumeroHabitacion, TipoHabitacion, Estado) VALUES
('101', 'Individual', 'Disponible'),
('102', 'Compartida', 'Disponible'),
('201', 'UCI', 'Ocupada'),
('202', 'Individual', 'Disponible'),
('301', 'Compartida', 'Mantenimiento'),
('103', 'Individual', 'Disponible'),
('104', 'Compartida', 'Ocupada'),
('203', 'UCI', 'Disponible'),
('204', 'Individual', 'Ocupada'),
('302', 'Compartida', 'Disponible');
GO

-- 56. Insertar 10 tratamientos.
INSERT INTO Tratamientos (PacienteID, MedicoID, FechaInicio, FechaFin, Descripcion) VALUES
(1, 1, '2026-06-10', '2026-07-10', 'Tratamiento cardiaco'),
(2, 2, '2026-06-11', '2026-06-18', 'Antibiotico pediatrico'),
(3, 3, '2026-06-12', '2026-06-19', 'Crema dermatologica'),
(4, 4, '2026-06-13', NULL, 'Seguimiento ginecologico'),
(5, 5, '2026-06-14', '2026-06-21', 'Tratamiento antigripal'),
(6, 6, '2026-06-15', '2026-07-15', 'Control de presion'),
(7, 7, '2026-06-16', '2026-06-23', 'Hidratacion constante'),
(8, 8, '2026-06-17', '2026-06-24', 'Antihistaminico diario'),
(9, 9, '2026-06-18', NULL, 'Tratamiento hormonal'),
(10, 10, '2026-06-19', '2026-06-26', 'Analgésico recetado');
GO

-- 57. Insertar 20 medicamentos.
INSERT INTO Medicamentos (NombreMedicamento, ComponenteActivo, Presentacion, Stock, Precio) VALUES
('Paracetamol', 'Acetaminofen', 'Tabletas', 150, 1.50),
('Amoxicilina', 'Amoxicilina', 'Capsulas', 80, 4.20),
('Ibuprofeno', 'Ibuprofeno', 'Tabletas', 200, 2.00),
('Loratadina', 'Loratadina', 'Jarabe', 50, 5.50),
('Omeprazol', 'Omeprazol', 'Capsulas', 120, 3.00),
('Diclofenaco', 'Diclofenaco', 'Ampollas', 60, 2.50),
('Losartan', 'Losartan', 'Tabletas', 180, 4.00),
('Metformina', 'Metformina', 'Tabletas', 140, 3.50),
('Atorvastatina', 'Atorvastatina', 'Tabletas', 90, 5.00),
('Aspirina', 'Acido Acetilsalicilico', 'Tabletas', 300, 1.00),
('Salbutamol', 'Salbutamol', 'Inhalador', 40, 8.50),
('Clonazepam', 'Clonazepam', 'Tabletas', 70, 6.00),
('Enalapril', 'Enalapril', 'Tabletas', 110, 2.20),
('Azitromicina', 'Azitromicina', 'Tabletas', 65, 7.00),
('Fluconazol', 'Fluconazol', 'Capsulas', 45, 4.80),
('Sertralina', 'Sertralina', 'Tabletas', 85, 9.00),
('Ranitidina', 'Ranitidina', 'Tabletas', 160, 1.80),
('Cetirizina', 'Cetirizina', 'Tabletas', 130, 2.10),
('Naproxeno', 'Naproxeno', 'Tabletas', 170, 2.60),
('Insulina', 'Insulina Humana', 'Vial', 25, 22.00);
GO

-- 58. Insertar pacientes con todos los campos.
INSERT INTO Pacientes (Nombres, Apellidos, FechaNacimiento, Genero, Direccion, Telefono, Email, Edad, HabitacionID, FechaRegistro) VALUES
('Ramon', 'Valdez', '1975-02-28', 'M', 'Managua', '7777-2121', 'ramon.v@mail.com', 51, 1, GETDATE());
GO

-- 59. Insertar médicos especialistas.
INSERT INTO Medicos (Nombres, Apellidos, SpecialtyID, Telefono, Email, Salario) VALUES
('Francisco', 'Granera', 1, '8888-1234', 'f.granera@mail.com', 3200);
GO

-- 60. Insertar citas con fecha actual.
INSERT INTO Citas (PacienteID, MedicoID, FechaCita, Motivo, EstadoCita) VALUES
(1, 1, GETDATE(), 'Consulta de urgencia del dia', 'Programada');
GO

-- 61. Insertar citas futuras.
INSERT INTO Citas (PacienteID, MedicoID, FechaCita, Motivo, EstadoCita) VALUES
(2, 2, '2026-12-25 10:00', 'Chequeo programado fin de ano', 'Programada');
GO

-- 62. Insertar habitaciones ocupadas.
INSERT INTO Habitaciones (NumeroHabitacion, TipoHabitacion, Estado) VALUES
('401', 'Individual', 'Ocupada'),
('402', 'Compartida', 'Ocupada');
GO

-- 63. Insertar habitaciones disponibles.
INSERT INTO Habitaciones (NumeroHabitacion, TipoHabitacion, Estado) VALUES
('501', 'Individual', 'Disponible'),
('502', 'Compartida', 'Disponible');
GO

-- 64. Insertar tratamientos activos.
-- Nota: Al no incluir FechaFin o dejarla NULL, se asume activo.
INSERT INTO Tratamientos (PacienteID, MedicoID, FechaInicio, FechaFin, Descripcion) VALUES
(3, 3, GETDATE(), NULL, 'Tratamiento dermatologico activo iniciado hoy');
GO

-- 65. Insertar tratamientos finalizados.
INSERT INTO Tratamientos (PacienteID, MedicoID, FechaInicio, FechaFin, Descripcion) VALUES
(4, 4, '2026-01-01', '2026-02-01', 'Tratamiento ginecologico concluido con exito');
GO