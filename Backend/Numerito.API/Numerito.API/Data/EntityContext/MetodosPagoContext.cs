using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Services.Ventas.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class MetodosPagoContext : IEntityTypeConfiguration<MetodosPago>
    {
        public void Configure(EntityTypeBuilder<MetodosPago> builder)
        {
            builder.ToTable("MetodosPago");
            builder.HasKey(e => e.MetodoPagoId).HasName("PK_MetodosPago_MetodoPagoId");

            builder.ToTable("MetodosPago");

            builder.HasIndex(e => e.Descripcion, "UQ_MetodosPago_Descripcion").IsUnique();

            builder.Property(e => e.Descripcion)
                .HasMaxLength(100)
                .IsUnicode(false);
            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");

            builder.HasOne(d => d.UsuarioCreacionNavigation).WithMany(p => p.MetodosPagoUsuarioCreacionNavigations)
                .HasForeignKey(d => d.UsuarioCreacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_MetodosPago_UsuarioCreacion_Usuarios_UsuarioId");

            builder.HasOne(d => d.UsuarioModificacionNavigation).WithMany(p => p.MetodosPagoUsuarioModificacionNavigations)
                .HasForeignKey(d => d.UsuarioModificacion)
                .HasConstraintName("FK_MetodosPago_UsuarioModificacion_Usuarios_UsuarioId");
        }
    }
}
