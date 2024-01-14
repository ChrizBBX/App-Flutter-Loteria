using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Data.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class VentaDetalleContext : IEntityTypeConfiguration<VentaDetalle>
    {
        public void Configure(EntityTypeBuilder<VentaDetalle> builder)
        {
            builder.ToTable("VentaDetalles");
            builder.HasKey(e => e.VentaDetalleId).HasName("PK_VentaDetalles_VentaDetalleID");

            builder.Property(e => e.VentaDetalleId).HasColumnName("VentaDetalleID");
            builder.Property(e => e.Valor).HasColumnType("decimal(18, 0)");

            builder.HasOne(d => d.Venta).WithMany(p => p.VentaDetalles)
                .HasForeignKey(d => d.VentaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_VentaDetalles_VentaId_Ventas_VentaId");
        }
    }
}
