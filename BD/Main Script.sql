CREATE DATABASE Numerito
GO 
USE Numerito


CREATE TABLE Usuarios
(
UsuarioId           INT IDENTITY (1,1),
NombreUsuario       VARCHAR(150) NOT NULL,
Contrasena          NVARCHAR(MAX),
PersonaId           INT NOT NULL,
SucursalId			INT,

UsuarioCreacion     INT             NOT NULL,
FechaCreacion       DATETIME        NOT NULL,
UsuarioModificacion INT,
FechaModificacion   DATETIME,
Estado              BIT             DEFAULT 1,
Admin				BIT

CONSTRAINT PK_Usuarios_usuarioId PRIMARY KEY (UsuarioId),
CONSTRAINT UQ_Usuarios_NombreUsuario UNIQUE (NombreUsuario)
)

GO
INSERT INTO Usuarios VALUES ('admin','123',1,NULL,1,GETDATE(),NULL,NULL,1,1)
GO

CREATE TABLE MetodosPago
(
MetodoPagoId        INT IDENTITY(1,1),
Descripcion         VARCHAR(100),
    
UsuarioCreacion     INT             NOT NULL,
FechaCreacion       DATETIME        NOT NULL,
UsuarioModificacion INT,
FechaModificacion   DATETIME,
Estado              BIT             DEFAULT 1

CONSTRAINT PK_MetodosPago_MetodoPagoId PRIMARY KEY(MetodoPagoId)
CONSTRAINT FK_MetodosPago_UsuarioCreacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioCreacion) REFERENCES Usuarios (UsuarioId),
CONSTRAINT FK_MetodosPago_UsuarioModificacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioModificacion) REFERENCES Usuarios (UsuarioId),
CONSTRAINT UQ_MetodosPago_Descripcion UNIQUE (Descripcion)
)

CREATE TABLE Membresias
(
MembresiaId INT IDENTITY(1,1),
Descripcion VARCHAR(300) NOT NULL,
Precio		DECIMAL(18,2),

UsuarioCreacion     INT             NOT NULL,
FechaCreacion       DATETIME        NOT NULL,
UsuarioModificacion INT,
FechaModificacion   DATETIME,
Estado              BIT             DEFAULT 1

CONSTRAINT PK_Membresias_MembresiaId PRIMARY KEY(MembresiaId),
CONSTRAINT FK_Membresias_UsuarioCreacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioCreacion) REFERENCES Usuarios (UsuarioId),
CONSTRAINT FK_Membresias_UsuarioModificacionn_Usuarios_UsuarioId FOREIGN KEY (UsuarioModificacion) REFERENCES Usuarios (UsuarioId)
)

CREATE TABLE Pagos
(
PagoId INT IDENTITY(1,1),
UsuarioId INT NOT NULL,
MembresiaId INT NOT NULL,
MetodoPagoId INT NOT NULL,
AutoRenovable BIT,
FechaVencimiento DateTime NOT NULL,

UsuarioCreacion     INT             NOT NULL,
FechaCreacion       DATETIME        NOT NULL,
UsuarioModificacion INT,
FechaModificacion   DATETIME,
Estado              BIT             DEFAULT 1

CONSTRAINT PK_Pagos_PagoId PRIMARY KEY (PagoId),
CONSTRAINT FK_Pagos_UsuarioId_Usuarios_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuarios (UsuarioId),
CONSTRAINT FK_Pagos_MetodoPagoId_MetodosPago_MetodoPagoId FOREIGN KEY (MetodoPagoId) REFERENCES MetodosPago (MetodoPagoId),
CONSTRAINT FK_Pagos_MebresiaId_Membresias_MembresiaId FOREIGN KEY (MembresiaId) REFERENCES Membresias (MembresiaId),
CONSTRAINT FK_Pagos_UsuarioCreacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuarios (UsuarioId),
CONSTRAINT FK_Pagos_UsuarioModificacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuarios (UsuarioId)
)

GO

CREATE TABLE Personas
(
PersonaId           INT IDENTITY (1,1),
Nombres             NVARCHAR (150),
Apellidos           NVARCHAR (150),
Identidad           VARCHAR  (13),
Telefono            VARCHAR  (8),
CorreoElectronico   NVARCHAR (150),
Direccion           NVARCHAR (250),

UsuarioCreacion     INT             NOT NULL,
FechaCreacion       DATETIME        NOT NULL,
UsuarioModificacion INT,
FechaModificacion   DATETIME,
Estado              BIT                         DEFAULT 1

CONSTRAINT PK_Personas_PersonaId                PRIMARY KEY(PersonaId),
CONSTRAINT UQ_Personas_Identidad                UNIQUE (Identidad)
)

GO
INSERT INTO Personas VALUES ('Consumidor Final',NULL,NULL,NULL,NULL,NULL,1,GETDATE(),NULL,NULL,1)
GO

ALTER TABLE Usuarios
ADD CONSTRAINT FK_Usuarios_PersonaId_Personas_PersonaId FOREIGN KEY (PersonaId) REFERENCES Personas(PersonaId)

CREATE TABLE Departamentos
(
DepartamentoId          INT IDENTITY (1,1),
Codigo					VARCHAR(2)		NOT NULL,
Nombre					VARCHAR (100)   NOT NULL,

UsuarioCreacion         INT             NOT NULL,
FechaCreacion           DATETIME        NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                             DEFAULT 1

CONSTRAINT PK_Departamentos_DepartamentoId              PRIMARY KEY (DepartamentoId),
CONSTRAINT UQ_Departamentos_Codigo						UNIQUE      (Codigo),
CONSTRAINT UQ_Departamentos_Nombre     UNIQUE      (Nombre)
)

CREATE TABLE Municipios
(
MunicipioId             INT IDENTITY (1,1),
Codigo					VARCHAR(4) NOT NULL,
Nombre					VARCHAR(150) NOT NULL,
DepartamentoId			INT NOT NULL,

UsuarioCreacion         INT             NOT NULL,
FechaCreacion           DATETIME        NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                             DEFAULT 1

CONSTRAINT PK_Municipios_MunicipioId                    PRIMARY KEY (MunicipioId),
CONSTRAINT UQ_Municipios_Nombre							UNIQUE      (Nombre),
CONSTRAINT UQ_Municipios_Codigo							UNIQUE		(Codigo),
CONSTRAINT FK_Municipios_DepartamentoId_Departamentos_DepartamentoId FOREIGN KEY (DepartamentoId) REFERENCES Departamentos (DepartamentoId)
)


CREATE TABLE Numeros
(  
NumeroId                INT NOT NULL,
NumeroDescripcion       VARCHAR (150),
Limite					INT,

UsuarioCreacion         INT                 NOT NULL,
FechaCreacion           DATETIME            NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                             DEFAULT  1

CONSTRAINT PK_Numeros_NumeroId                          PRIMARY KEY (NumeroId),
)

CREATE TABLE Sucursales
(
SucursalId				INT IDENTITY (1,1),
MunicipioId				INT,
Nombre					VARCHAR (150),
Direccion				VARCHAR(250),


UsuarioCreacion         INT                 NOT NULL,
FechaCreacion           DATETIME            NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                                DEFAULT 1

CONSTRAINT PK_Sucursales_NumeroId                          PRIMARY KEY (SucursalId),
CONSTRAINT UQ_Sucursales_SucursalDescripcion               UNIQUE      (Nombre),
CONSTRAINT FK_Sucursales_MunicipioId_Municipios_MunicipioId FOREIGN KEY (MunicipioId) REFERENCES Municipios (MunicipioId)
)

ALTER TABLE Usuarios
ADD CONSTRAINT FK_Usuarios_SucursalId_Sucursales_SucursalId FOREIGN KEY (SucursalId) REFERENCES Sucursales (SucursalId)

CREATE TABLE Ventas
(
    VentaId					INT IDENTITY(1,1),
    PersonaId               INT NOT NULL,
    UsuarioId               INT NOT NULL,
    MetodoPagoId            INT NOT NULL,
    FechaVenta				DATETIME NOT NULL,
    
    UsuarioCreacion         INT                 NOT NULL,
    FechaCreacion           DATETIME            NOT NULL,
    UsuarioModificacion     INT,
    FechaModificacion       DATETIME,
    Estado                  BIT                                DEFAULT 1

    CONSTRAINT PK_Ventas_VentaId PRIMARY KEY (VentaId),
    CONSTRAINT FK_Ventas_PersonaId_Personas_PersonaId FOREIGN KEY (PersonaId) REFERENCES Personas (PersonaId),
    CONSTRAINT FK_Ventas_UsuarioId_Usuarios_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuarios (UsuarioId),
    CONSTRAINT FK_Ventas_MetodoPagoId_MetodosPago_MetodoPagoId FOREIGN KEY (MetodoPagoId) REFERENCES MetodosPago(MetodoPagoId),
    CONSTRAINT FK_Ventas_UsuarioCreacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioCreacion) REFERENCES Usuarios(UsuarioId),
    CONSTRAINT FK_Ventas_UsuarioModificacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioModificacion) REFERENCES Usuarios(UsuarioId),
)


CREATE TABLE VentaDetalles(
    VentaDetalleID          INT IDENTITY(1,1),
    VentaId                 INT                     NOT NULL,
    NumeroId				INT                     NOT NULL,
    Valor                   DECIMAL					NOT NULL,

	CONSTRAINT PK_VentaDetalles_VentaDetalleID PRIMARY KEY (VentaDetalleId),
	CONSTRAINT FK_VentaDetalles_NumeroId_Numeros_NumeroId FOREIGN KEY (NumeroId) REFERENCES Numeros(NumeroId),
	CONSTRAINT FK_VentaDetalles_VentaId_Ventas_VentaId FOREIGN KEY (VentaId) REFERENCES Ventas (VentaId)
)

/*Insert de MetodosPago por defecto*/
INSERT INTO MetodosPago 
(Descripcion, 
UsuarioCreacion, 
FechaCreacion, 
UsuarioModificacion, 
FechaModificacion,
Estado)
VALUES ('Efectivo',1,GETDATE(),NULL,NULL,1)

/*Insert de Numero por defecto*/
INSERT INTO Numeros 
(NumeroId, 
NumeroDescripcion, 
Limite, 
UsuarioCreacion, 
FechaCreacion,
UsuarioModificacion, 
FechaModificacion, 
Estado)
VALUES (0,'Avion',1000,1,GETDATE(),NULL,NULL,1)

SELECT * FROM Ventas
SELECT * FROM VentaDetalles
SELECT * FROM Numeros
SELECT * FROM Usuarios