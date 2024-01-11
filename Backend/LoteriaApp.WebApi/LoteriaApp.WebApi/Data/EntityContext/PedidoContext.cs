using LoteriaApp.WebApi.Data.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class PedidoContext : IEntityTypeConfiguration<Pedido>
    {
        public void Configure(EntityTypeBuilder<Pedido> builder)
        {
            builder.ToTable("Pedidos");
            builder.HasKey(e => e.PedidoId).HasName("PK_Pedidos_PedidoId");

            builder.HasIndex(e => e.NumeroPedido, "UQ_Pedidos_NumeroPedido").IsUnique();

            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.FechaPedido).HasColumnType("datetime");
            builder.Property(e => e.NumeroPedido)
                .HasMaxLength(150)
                .IsUnicode(false);

            builder.HasOne(d => d.MetodoPago).WithMany(p => p.Pedidos)
                .HasForeignKey(d => d.MetodoPagoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pedidos_MetodoPagoId_MetodosPago_MetodoPagoId");

            builder.HasOne(d => d.Persona).WithMany(p => p.Pedidos)
                .HasForeignKey(d => d.PersonaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pedidos_PersonaId_Personas_PersonaId");

            builder.HasOne(d => d.UsuarioCreacionNavigation).WithMany(p => p.PedidoUsuarioCreacionNavigations)
                .HasForeignKey(d => d.UsuarioCreacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pedidos_UsuarioCreacion_Usuarios_UsuarioId");

            builder.HasOne(d => d.Usuario).WithMany(p => p.PedidoUsuarios)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Pedidos_UsuarioId_Usuarios_UsuarioId");

            builder.HasOne(d => d.UsuarioModificacionNavigation).WithMany(p => p.PedidoUsuarioModificacionNavigations)
                .HasForeignKey(d => d.UsuarioModificacion)
                .HasConstraintName("FK_Pedidos_UsuarioModificacion_Usuarios_UsuarioId");
        }
    }
}
