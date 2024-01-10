CREATE DATABASE Loteria
GO 
USE Loteria


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




CREATE TABLE Personas
(
PersonaId           INT IDENTITY (1,1),
Nombres             NVARCHAR (150)  NOT NULL,
Apellidos           NVARCHAR (150)  NOT NULL,
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

CREATE TABLE Pedidos
(
    PedidoId                INT IDENTITY(1,1),
    NumeroPedido            VARCHAR(150) NOT NULL,
    PersonaId               INT NOT NULL,
    UsuarioId               INT NOT NULL,
    MetodoPagoId            INT NOT NULL,
    FechaPedido             DATETIME NOT NULL,
    
    UsuarioCreacion         INT                 NOT NULL,
    FechaCreacion           DATETIME            NOT NULL,
    UsuarioModificacion     INT,
    FechaModificacion       DATETIME,
    Estado                  BIT                                DEFAULT 1

    CONSTRAINT PK_Pedidos_PedidoId PRIMARY KEY (PedidoId),
    CONSTRAINT UQ_Pedidos_NumeroPedido UNIQUE (NumeroPedido),
    CONSTRAINT FK_Pedidos_PersonaId_Personas_PersonaId FOREIGN KEY (PersonaId) REFERENCES Personas (PersonaId),
    CONSTRAINT FK_Pedidos_UsuarioId_Usuarios_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuarios (UsuarioId),
    CONSTRAINT FK_Pedidos_MetodoPagoId_MetodosPago_MetodoPagoId FOREIGN KEY (MetodoPagoId) REFERENCES MetodosPago(MetodoPagoId),
    CONSTRAINT FK_Pedidos_UsuarioCreacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioCreacion) REFERENCES Usuarios(UsuarioId),
    CONSTRAINT FK_Pedidos_UsuarioModificacion_Usuarios_UsuarioId FOREIGN KEY (UsuarioModificacion) REFERENCES Usuarios(UsuarioId),
)


CREATE TABLE PedidoDetalles(
    PedidoDetalleId         INT IDENTITY(1,1),
    PedidoId                INT                     NOT NULL,
    Numero					INT                     NOT NULL,
    Valor                   DECIMAL					NOT NULL,

	CONSTRAINT PK_PedidoDetalles_PedidoDetalleId PRIMARY KEY (PedidoDetalleId),
	CONSTRAINT FK_PedidoDetalles_PedidoId_Pedidos_PedidoId FOREIGN KEY (PedidoId) REFERENCES Pedidos (PedidoId)
)