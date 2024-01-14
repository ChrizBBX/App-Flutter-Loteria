CREATE DATABASE Numerito
GO 
USE Numerito


CREATE TABLE Usuarios
(
UsuarioId           INT IDENTITY (1,1),
NombreUsuario       VARCHAR(150) NOT NULL,
Contrasena          NVARCHAR(MAX),
PersonaId           INT NOT NULL,

UsuarioCreacion     INT             NOT NULL,
FechaCreacion       DATETIME        NOT NULL,
UsuarioModificacion INT,
FechaModificacion   DATETIME,
Estado              BIT             DEFAULT 1,
Admin				BIT

CONSTRAINT PK_Usuarios_usuarioId PRIMARY KEY (UsuarioId),
)

GO
INSERT INTO Usuarios VALUES ('admin','123',1,1,GETDATE(),NULL,NULL,1,1)
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
INSERT INTO Personas VALUES ('Legendario','Ramirez','1503198012454','33156532','messileganaaronaldo@gmail.com','Donde tu telefono no esta seguro',1,GETDATE(),NULL,NULL,1)
GO

ALTER TABLE Usuarios
ADD CONSTRAINT FK_Usuarios_PersonaId_Personas_PersonaId FOREIGN KEY (PersonaId) REFERENCES Personas(PersonaId)

CREATE TABLE Departamentos
(
DepartamentoId          INT IDENTITY (1,1),
DepartamentoDescripcion VARCHAR (100)   NOT NULL,

UsuarioCreacion         INT             NOT NULL,
FechaCreacion           DATETIME        NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                             DEFAULT 1

CONSTRAINT PK_Departamentos_DepartamentoId              PRIMARY KEY (DepartamentoId),
CONSTRAINT UQ_Departamentos_DepartamentoDescripcion     UNIQUE      (DepartamentoDescripcion)

)

CREATE TABLE Municipios
(
MunicipioId             INT IDENTITY (1,1),
MunicipioDescripcion    VARCHAR,

UsuarioCreacion         INT             NOT NULL,
FechaCreacion           DATETIME        NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                             DEFAULT 1

CONSTRAINT PK_Municipios_MunicipioId                    PRIMARY KEY (MunicipioId),
CONSTRAINT UQ_Municipios_MunicipioDescripcion           UNIQUE      (MunicipioDescripcion)
)


CREATE TABLE Numeros
(  
NumeroId                INT IDENTITY (1,1),
Numero                  INT                 NOT NULL,
NumeroDescripcion       VARCHAR (150),
Limite					INT,

UsuarioCreacion         INT                 NOT NULL,
FechaCreacion           DATETIME            NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                             DEFAULT  1

CONSTRAINT PK_Numeros_NumeroId                          PRIMARY KEY (NumeroId),
CONSTRAINT UQ_Numeros_Numero                            UNIQUE      (Numero)

)

CREATE TABLE Sucursales
(
SucursalId             INT IDENTITY (1,1),
SucursalDescripcion    VARCHAR (150),


UsuarioCreacion         INT                 NOT NULL,
FechaCreacion           DATETIME            NOT NULL,
UsuarioModificacion     INT,
FechaModificacion       DATETIME,
Estado                  BIT                                DEFAULT 1

CONSTRAINT PK_Sucursales_NumeroId                          PRIMARY KEY (SucursalId),
CONSTRAINT UQ_Sucursales_SucursalDescripcion               UNIQUE      (SucursalDescripcion)
)

CREATE TABLE Ventas
(
    VentaId                INT IDENTITY(1,1),
    NumeroVenta          VARCHAR(150) NOT NULL,
    PersonaId               INT NOT NULL,
    UsuarioId               INT NOT NULL,
    MetodoPagoId            INT NOT NULL,
    FechaVenta             DATETIME NOT NULL,
    
    UsuarioCreacion         INT                 NOT NULL,
    FechaCreacion           DATETIME            NOT NULL,
    UsuarioModificacion     INT,
    FechaModificacion       DATETIME,
    Estado                  BIT                                DEFAULT 1

    CONSTRAINT PK_Ventas_VentaId PRIMARY KEY (VentaId),
    CONSTRAINT UQ_Ventas_NumeroVenta UNIQUE (NumeroVenta),
    CONSTRAINT FK_Ventas_PersonaId_Personas_PersonaId FOREIGN KEY (PersonaId) REFERENCES Personas (PersonaId),
    CONSTRAINT FK_Ventas_UsuarioId_Usuarios_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuarios (UsuarioId),
    CONSTRAINT FK_Ventas_MetodoPagoId_MetodosPago_MetodoPagoId FOREIGN KEY (MetodoPagoId) REFERENCES MetodosPago(MetodoPagoId),
    CONSTRAINT FK_Ventas_UsuarioCreacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioCreacion) REFERENCES Usuarios(UsuarioId),
    CONSTRAINT FK_Ventas_UsuarioModificacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioModificacion) REFERENCES Usuarios(UsuarioId),
)


CREATE TABLE VentaDetalles(
    VentaDetalleID          INT IDENTITY(1,1),
    VentaId                 INT                     NOT NULL,
    Numero					INT                     NOT NULL,
    Valor                   DECIMAL					NOT NULL,

	CONSTRAINT PK_VentaDetalles_VentaDetalleID PRIMARY KEY (VentaDetalleId),
	CONSTRAINT FK_VentaDetalles_VentaId_Ventas_VentaId FOREIGN KEY (VentaId) REFERENCES Ventas (VentaId)
)