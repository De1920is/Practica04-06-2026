-- Parte I

CREATE DATABASE EmpresaSQL;
GO

USE EmpresaSQL;
GO

CREATE TABLE TDepartamento (
    nDepartamentoID INT IDENTITY(1,1),
    cNombreDepartamento VARCHAR(50) NOT NULL,
    CONSTRAINT PK_TDepartamento PRIMARY KEY (nDepartamentoID),
    CONSTRAINT UQ_cNombreDepartamento UNIQUE (cNombreDepartamento)
);

CREATE TABLE TCargo (
    nCargoID INT IDENTITY(1,1),
    cNombreCargo VARCHAR(50) NOT NULL,
    CONSTRAINT PK_TCargo PRIMARY KEY (nCargoID),
    CONSTRAINT UQ_cNombreCargo UNIQUE (cNombreCargo)
);

CREATE TABLE TEmpleado (
    nEmpleadoID INT IDENTITY(1,1),
    cNIF VARCHAR(20) NOT NULL,
    cNombre VARCHAR(50) NOT NULL,
    cApellido VARCHAR(50) NOT NULL,
    nDepartamentoID INT,
    nCargoID INT,
    dFechaContratacion DATE CONSTRAINT DF_dFechaContratacion DEFAULT GETDATE(),
    nSalario DECIMAL(10,2),
    CONSTRAINT PK_TEmpleado PRIMARY KEY (nEmpleadoID),
    CONSTRAINT UQ_cNIF UNIQUE (cNIF),
    CONSTRAINT CK_nSalario CHECK (nSalario > 300)
);

ALTER TABLE TEmpleado
ADD CONSTRAINT FK_TEmpleado_TDepartamento FOREIGN KEY (nDepartamentoID)
REFERENCES TDepartamento(nDepartamentoID);

ALTER TABLE TEmpleado
ADD CONSTRAINT FK_TEmpleado_TCargo FOREIGN KEY (nCargoID)
REFERENCES TCargo(nCargoID);

REFERENCES TCargo(nCargoID);
    nProyectoID INT IDENTITY(1,1),
    cNombreProyecto VARCHAR(100) NOT NULL,
    dFechaInicio DATE NOT NULL,
    dFechaFinalizacion DATE,
    CONSTRAINT PK_TProyecto PRIMARY KEY (nProyectoID)
);

CREATE TABLE TEmpleadoProyecto (
    nEmpleadoID INT,
    nProyectoID INT,
    CONSTRAINT PK_TEmpleadoProyecto PRIMARY KEY (nEmpleadoID, nProyectoID),
    CONSTRAINT FK_TEmpleadoProyecto_TEmpleado FOREIGN KEY (nEmpleadoID) REFERENCES TEmpleado(nEmpleadoID),
    CONSTRAINT FK_TEmpleadoProyecto_TProyecto FOREIGN KEY (nProyectoID) REFERENCES TProyecto(nProyectoID)
);

--Parte II

ALTER TABLE TEmpleado ADD cEmail VARCHAR(100);

ALTER TABLE TEmpleado ADD cTelefono VARCHAR(15);

ALTER TABLE TEmpleado ALTER COLUMN cNombre VARCHAR(100) NOT NULL;

ALTER TABLE TEmpleado ALTER COLUMN cApellido VARCHAR(100) NOT NULL;

ALTER TABLE TEmpleado ADD cDireccion VARCHAR(250);

ALTER TABLE TEmpleado ADD nEdad INT;

ALTER TABLE TEmpleado ADD CONSTRAINT CK_nEdad CHECK (nEdad BETWEEN 18 AND 65);

ALTER TABLE TEmpleado ADD CONSTRAINT UQ_cEmail UNIQUE (cEmail);

ALTER TABLE TEmpleado ADD bActivo BIT CONSTRAINT DF_bActivo DEFAULT 1;

ALTER TABLE TEmpleado DROP COLUMN cDireccion;

ALTER TABLE TEmpleado ALTER COLUMN cTelefono VARCHAR(20);

ALTER TABLE TEmpleado ADD cGenero CHAR(1);

ALTER TABLE TEmpleado ADD CONSTRAINT CK_cGenero CHECK (cGenero IN ('M', 'F'));

ALTER TABLE TEmpleado ADD dFechaNacimiento DATE;

CREATE TABLE TSucursal (
    nSucursalID INT IDENTITY(1,1),
    cNombreSucursal VARCHAR(100) NOT NULL,
    CONSTRAINT PK_TSucursal PRIMARY KEY (nSucursalID)
);

--Parte III

INSERT INTO TDepartamento (cNombreDepartamento) VALUES
('Tecnología'), ('Recursos Humanos'), ('Finanzas'), ('Ventas'), ('Operaciones');

INSERT INTO TCargo (cNombreCargo) VALUES
('Desarrollador'), ('Analista RRHH'), ('Contador'), ('Asesor de Ventas'), ('Gerente');

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cEmail, cTelefono, cGenero, dFechaNacimiento) VALUES

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cEmail, cTelefono, cGenero, dFechaNacimiento) VALUES
('NIF001', 'Enrique', 'Arana', 1, 1, 1500.00, 19, 'enrique@empresa.com', '8888-8881', 'M', '2006-09-11'),
('NIF002', 'Rodrigo', 'Quintana', 1, 5, 2500.00, 25, 'rodrigo@empresa.com', '8888-8882', 'M', '2001-04-15'),
('NIF003', 'Claudio', 'Gomez', 2, 2, 450.00, 23, 'claudio@empresa.com', '8888-8883', 'M', '2003-02-20'),
('NIF004', 'Axel', 'Lopez', 3, 3, 1200.00, 28, 'axel@empresa.com', '8888-8884', 'M', '1998-07-30'),
('NIF005', 'Jorge', 'Martinez', 4, 4, 350.00, 31, 'jorge@empresa.com', '8888-8885', 'M', '1995-11-12'),
('NIF006', 'Sergio', 'Perez', 5, 4, 600.00, 35, 'sergio@empresa.com', '8888-8886', 'M', '1991-01-05'),
('NIF007', 'Jonas', 'Garcia', 1, 1, 1100.00, 22, 'jonas@empresa.com', '8888-8887', 'M', '2004-08-24'),
('NIF008', 'Gunther', 'Silva', 3, 3, 1300.00, 40, 'gunther@empresa.com', '8888-8888', 'M', '1886-05-18'),
('NIF009', 'Maria', 'Guzman', 2, 2, 850.00, 26, 'maria@empresa.com', '8888-8889', 'F', '2000-12-01'),
('NIF010', 'Ana', 'Castro', 4, 4, 950.00, 29, 'ana@empresa.com', '8888-8890', 'F', '1997-03-14');

INSERT INTO TProyecto (cNombreProyecto, dFechaInicio, dFechaFinalizacion) VALUES
('Sistema ERP', '2026-01-10', '2026-08-30'),
('Auditoria Financiera', '2026-03-01', NULL),
('Plataforma Web', '2026-05-15', '2026-12-15');

INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES 
(1, 1), (2, 1), (7, 1),
(4, 2), (8, 2),
(1, 3), (10, 3);

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cEmail, cGenero) VALUES
('NIF011', 'Luis', 'Torres', 5, 4, 400.00, 24, 'luis@empresa.com', 'M');

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cEmail, cGenero) VALUES
('NIF012', 'Elena', 'Rojas', 1, 1, 1400.00, 27, 'elena@empresa.com', 'F');

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cEmail, cGenero) VALUES
('NIF013', 'Carlos', 'Mendoza', 4, 4, 550.00, 33, 'carlos@empresa.com', 'M');

INSERT INTO TDepartamento (cNombreDepartamento) VALUES 
('Logística'), ('Calidad'), ('Soporte Técnico');

