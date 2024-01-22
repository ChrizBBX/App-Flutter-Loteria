using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Numerito.API.Migrations
{
    /// <inheritdoc />
    public partial class VentaDetalle_ToInt : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "Valor",
                table: "VentaDetalles",
                type: "int",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "decimal(18,0)");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<decimal>(
                name: "Valor",
                table: "VentaDetalles",
                type: "decimal(18,0)",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");
        }
    }
}
