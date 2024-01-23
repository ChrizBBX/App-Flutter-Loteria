using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Numerito.API.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Departamentos",
                columns: table => new
                {
                    DepartamentoId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DepartamentoDescripcion = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Departamentos_DepartamentoId", x => x.DepartamentoId);
                });

            migrationBuilder.CreateTable(
                name: "Municipios",
                columns: table => new
                {
                    MunicipioId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MunicipioDescripcion = table.Column<string>(type: "varchar(1)", unicode: false, maxLength: 1, nullable: true),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Municipios_MunicipioId", x => x.MunicipioId);
                });

            migrationBuilder.CreateTable(
                name: "Numeros",
                columns: table => new
                {
                    NumeroId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Numero = table.Column<int>(type: "int", nullable: false),
                    NumeroDescripcion = table.Column<string>(type: "varchar(150)", unicode: false, maxLength: 150, nullable: true),
                    Limite = table.Column<int>(type: "int", nullable: true),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Numeros_NumeroId", x => x.NumeroId);
                });

            migrationBuilder.CreateTable(
                name: "Personas",
                columns: table => new
                {
                    PersonaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Nombres = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: true),
                    Apellidos = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: true),
                    Identidad = table.Column<string>(type: "varchar(13)", unicode: false, maxLength: 13, nullable: true),
                    Telefono = table.Column<string>(type: "varchar(8)", unicode: false, maxLength: 8, nullable: true),
                    CorreoElectronico = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: true),
                    Direccion = table.Column<string>(type: "nvarchar(250)", maxLength: 250, nullable: true),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Personas_PersonaId", x => x.PersonaId);
                });

            migrationBuilder.CreateTable(
                name: "Sucursales",
                columns: table => new
                {
                    SucursalId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SucursalDescripcion = table.Column<string>(type: "varchar(150)", unicode: false, maxLength: 150, nullable: true),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Sucursales_NumeroId", x => x.SucursalId);
                });

            migrationBuilder.CreateTable(
                name: "Usuarios",
                columns: table => new
                {
                    UsuarioId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NombreUsuario = table.Column<string>(type: "varchar(150)", unicode: false, maxLength: 150, nullable: false),
                    Contrasena = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PersonaId = table.Column<int>(type: "int", nullable: false),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true),
                    Admin = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Usuarios_usuarioId", x => x.UsuarioId);
                    table.ForeignKey(
                        name: "FK_Usuarios_PersonaId_Personas_PersonaId",
                        column: x => x.PersonaId,
                        principalTable: "Personas",
                        principalColumn: "PersonaId");
                });

            migrationBuilder.CreateTable(
                name: "Membresias",
                columns: table => new
                {
                    MembresiaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Descripcion = table.Column<string>(type: "varchar(300)", unicode: false, maxLength: 300, nullable: false),
                    Precio = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Membresias_MembresiaId", x => x.MembresiaId);
                    table.ForeignKey(
                        name: "FK_Membresias_UsuarioCreacion_Usuarios_UsuarioId",
                        column: x => x.UsuarioCreacion,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                    table.ForeignKey(
                        name: "FK_Membresias_UsuarioModificacionn_Usuarios_UsuarioId",
                        column: x => x.UsuarioModificacion,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                });

            migrationBuilder.CreateTable(
                name: "MetodosPago",
                columns: table => new
                {
                    MetodoPagoId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Descripcion = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MetodosPago_MetodoPagoId", x => x.MetodoPagoId);
                    table.ForeignKey(
                        name: "FK_MetodosPago_UsuarioCreacion_Usuarios_UsuarioId",
                        column: x => x.UsuarioCreacion,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                    table.ForeignKey(
                        name: "FK_MetodosPago_UsuarioModificacion_Usuarios_UsuarioId",
                        column: x => x.UsuarioModificacion,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                });

            migrationBuilder.CreateTable(
                name: "Pagos",
                columns: table => new
                {
                    PagoId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UsuarioId = table.Column<int>(type: "int", nullable: false),
                    MembresiaId = table.Column<int>(type: "int", nullable: false),
                    MetodoPagoId = table.Column<int>(type: "int", nullable: false),
                    AutoRenovable = table.Column<bool>(type: "bit", nullable: true),
                    FechaVencimiento = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Pagos_PagoId", x => x.PagoId);
                    table.ForeignKey(
                        name: "FK_Pagos_MebresiaId_Membresias_MembresiaId",
                        column: x => x.MembresiaId,
                        principalTable: "Membresias",
                        principalColumn: "MembresiaId");
                    table.ForeignKey(
                        name: "FK_Pagos_MetodoPagoId_MetodosPago_MetodoPagoId",
                        column: x => x.MetodoPagoId,
                        principalTable: "MetodosPago",
                        principalColumn: "MetodoPagoId");
                    table.ForeignKey(
                        name: "FK_Pagos_UsuarioCreacion_Usuarios_UsuarioId",
                        column: x => x.UsuarioId,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                });

            migrationBuilder.CreateTable(
                name: "Ventas",
                columns: table => new
                {
                    VentaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NumeroVenta = table.Column<string>(type: "varchar(150)", unicode: false, maxLength: 150, nullable: false),
                    PersonaId = table.Column<int>(type: "int", nullable: false),
                    UsuarioId = table.Column<int>(type: "int", nullable: false),
                    MetodoPagoId = table.Column<int>(type: "int", nullable: false),
                    FechaVenta = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioCreacion = table.Column<int>(type: "int", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "datetime", nullable: false),
                    UsuarioModificacion = table.Column<int>(type: "int", nullable: true),
                    FechaModificacion = table.Column<DateTime>(type: "datetime", nullable: true),
                    Estado = table.Column<bool>(type: "bit", nullable: true, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ventas_VentaId", x => x.VentaId);
                    table.ForeignKey(
                        name: "FK_Ventas_MetodoPagoId_MetodosPago_MetodoPagoId",
                        column: x => x.MetodoPagoId,
                        principalTable: "MetodosPago",
                        principalColumn: "MetodoPagoId");
                    table.ForeignKey(
                        name: "FK_Ventas_PersonaId_Personas_PersonaId",
                        column: x => x.PersonaId,
                        principalTable: "Personas",
                        principalColumn: "PersonaId");
                    table.ForeignKey(
                        name: "FK_Ventas_UsuarioCreacion_Usuarios_UsuarioId",
                        column: x => x.UsuarioCreacion,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                    table.ForeignKey(
                        name: "FK_Ventas_UsuarioId_Usuarios_UsuarioId",
                        column: x => x.UsuarioId,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                    table.ForeignKey(
                        name: "FK_Ventas_UsuarioModificacion_Usuarios_UsuarioId",
                        column: x => x.UsuarioModificacion,
                        principalTable: "Usuarios",
                        principalColumn: "UsuarioId");
                });

            migrationBuilder.CreateTable(
                name: "VentaDetalles",
                columns: table => new
                {
                    VentaDetalleID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    VentaId = table.Column<int>(type: "int", nullable: false),
                    Numero = table.Column<int>(type: "int", nullable: false),
                    Valor = table.Column<decimal>(type: "decimal(18,0)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VentaDetalles_VentaDetalleID", x => x.VentaDetalleID);
                    table.ForeignKey(
                        name: "FK_VentaDetalles_VentaId_Ventas_VentaId",
                        column: x => x.VentaId,
                        principalTable: "Ventas",
                        principalColumn: "VentaId");
                });

            migrationBuilder.CreateIndex(
                name: "UQ_Departamentos_DepartamentoDescripcion",
                table: "Departamentos",
                column: "DepartamentoDescripcion",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Membresias_UsuarioCreacion",
                table: "Membresias",
                column: "UsuarioCreacion");

            migrationBuilder.CreateIndex(
                name: "IX_Membresias_UsuarioModificacion",
                table: "Membresias",
                column: "UsuarioModificacion");

            migrationBuilder.CreateIndex(
                name: "IX_MetodosPago_UsuarioCreacion",
                table: "MetodosPago",
                column: "UsuarioCreacion");

            migrationBuilder.CreateIndex(
                name: "IX_MetodosPago_UsuarioModificacion",
                table: "MetodosPago",
                column: "UsuarioModificacion");

            migrationBuilder.CreateIndex(
                name: "UQ_MetodosPago_Descripcion",
                table: "MetodosPago",
                column: "Descripcion",
                unique: true,
                filter: "[Descripcion] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "UQ_Municipios_MunicipioDescripcion",
                table: "Municipios",
                column: "MunicipioDescripcion",
                unique: true,
                filter: "[MunicipioDescripcion] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "UQ_Numeros_Numero",
                table: "Numeros",
                column: "Numero",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Pagos_MembresiaId",
                table: "Pagos",
                column: "MembresiaId");

            migrationBuilder.CreateIndex(
                name: "IX_Pagos_MetodoPagoId",
                table: "Pagos",
                column: "MetodoPagoId");

            migrationBuilder.CreateIndex(
                name: "IX_Pagos_UsuarioId",
                table: "Pagos",
                column: "UsuarioId");

            migrationBuilder.CreateIndex(
                name: "UQ_Personas_Identidad",
                table: "Personas",
                column: "Identidad",
                unique: true,
                filter: "[Identidad] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "UQ_Sucursales_SucursalDescripcion",
                table: "Sucursales",
                column: "SucursalDescripcion",
                unique: true,
                filter: "[SucursalDescripcion] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_Usuarios_PersonaId",
                table: "Usuarios",
                column: "PersonaId");

            migrationBuilder.CreateIndex(
                name: "IX_VentaDetalles_VentaId",
                table: "VentaDetalles",
                column: "VentaId");

            migrationBuilder.CreateIndex(
                name: "IX_Ventas_MetodoPagoId",
                table: "Ventas",
                column: "MetodoPagoId");

            migrationBuilder.CreateIndex(
                name: "IX_Ventas_PersonaId",
                table: "Ventas",
                column: "PersonaId");

            migrationBuilder.CreateIndex(
                name: "IX_Ventas_UsuarioCreacion",
                table: "Ventas",
                column: "UsuarioCreacion");

            migrationBuilder.CreateIndex(
                name: "IX_Ventas_UsuarioId",
                table: "Ventas",
                column: "UsuarioId");

            migrationBuilder.CreateIndex(
                name: "IX_Ventas_UsuarioModificacion",
                table: "Ventas",
                column: "UsuarioModificacion");

            migrationBuilder.CreateIndex(
                name: "UQ_Ventas_NumeroVenta",
                table: "Ventas",
                column: "NumeroVenta",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Departamentos");

            migrationBuilder.DropTable(
                name: "Municipios");

            migrationBuilder.DropTable(
                name: "Numeros");

            migrationBuilder.DropTable(
                name: "Pagos");

            migrationBuilder.DropTable(
                name: "Sucursales");

            migrationBuilder.DropTable(
                name: "VentaDetalles");

            migrationBuilder.DropTable(
                name: "Membresias");

            migrationBuilder.DropTable(
                name: "Ventas");

            migrationBuilder.DropTable(
                name: "MetodosPago");

            migrationBuilder.DropTable(
                name: "Usuarios");

            migrationBuilder.DropTable(
                name: "Personas");
        }
    }
}
