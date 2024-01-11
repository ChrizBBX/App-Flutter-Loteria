using LoteriaApp.WebApi.Data.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class MembresiaContext : IEntityTypeConfiguration<Membresia>
    {
        public void Configure(EntityTypeBuilder<Membresia> builder)
        {
            builder.ToTable("Membresias");
            builder.HasKey(e => e.MembresiaId).HasName("PK_Membresias_MembresiaId");

            builder.Property(e => e.Descripcion)
                .HasMaxLength(300)
                .IsUnicode(false);
            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.Precio).HasColumnType("decimal(18, 2)");

            builder.HasOne(d => d.UsuarioCreacionNavigation).WithMany(p => p.MembresiaUsuarioCreacionNavigations)
                .HasForeignKey(d => d.UsuarioCreacion)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Membresias_UsuarioCreacion_Usuarios_UsuarioId");

            builder.HasOne(d => d.UsuarioModificacionNavigation).WithMany(p => p.MembresiaUsuarioModificacionNavigations)
                .HasForeignKey(d => d.UsuarioModificacion)
                .HasConstraintName("FK_Membresias_UsuarioModificacionn_Usuarios_UsuarioId");
        }
    }
}
