using LoteriaApp.WebApi.Data.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class PedidoDetalleContext : IEntityTypeConfiguration<PedidoDetalle>
    {
        public void Configure(EntityTypeBuilder<PedidoDetalle> builder)
        {
            builder.ToTable("PedidoDetalles");
            builder.HasKey(e => e.PedidoDetalleId).HasName("PK_PedidoDetalles_PedidoDetalleId");

            builder.Property(e => e.Valor).HasColumnType("decimal(18, 0)");

            builder.HasOne(d => d.Pedido).WithMany(p => p.PedidoDetalles)
                .HasForeignKey(d => d.PedidoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_PedidoDetalles_PedidoId_Pedidos_PedidoId");
        }
    }
}
