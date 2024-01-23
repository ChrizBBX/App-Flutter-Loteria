using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Data.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class VentaContext : IEntityTypeConfiguration<Venta>
    {
        public void Configure(EntityTypeBuilder<Venta> builder)
        {
            builder.ToTable("Ventas");
            builder.HasKey(e => e.VentaId).HasName("PK_Ventas_VentaId");

            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.FechaVenta).HasColumnType("datetime");

            builder.HasOne(d => d.MetodoPago).WithMany(p => p.Venta)
                .HasForeignKey(d => d.MetodoPagoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Ventas_MetodoPagoId_MetodosPago_MetodoPagoId");

            builder.HasOne(d => d.Persona).WithMany(p => p.Venta)
                .HasForeignKey(d => d.PersonaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Ventas_PersonaId_Personas_PersonaId");

            builder.HasOne(d => d.UsuarioCreacionNavigation).WithMany(p => p.VentaUsuarioCreacionNavigations)
                .HasForeignKey(d => d.UsuarioCreacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Ventas_UsuarioCreacion_Usuarios_UsuarioId");

            builder.HasOne(d => d.Usuario).WithMany(p => p.VentaUsuarios)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Ventas_UsuarioId_Usuarios_UsuarioId");

            builder.HasOne(d => d.UsuarioModificacionNavigation).WithMany(p => p.VentaUsuarioModificacionNavigations)
                .HasForeignKey(d => d.UsuarioModificacion)
                .HasConstraintName("FK_Ventas_UsuarioModificacion_Usuarios_UsuarioId");
        }
    }
}
