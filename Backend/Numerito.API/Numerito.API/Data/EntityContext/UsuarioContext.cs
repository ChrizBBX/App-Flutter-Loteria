using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Data.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class UsuarioContext : IEntityTypeConfiguration<Usuario>
    {
        public void Configure(EntityTypeBuilder<Usuario> builder)
        {
            builder.ToTable("Usuarios");
            builder.HasKey(e => e.UsuarioId).HasName("PK_Usuarios_usuarioId");

            builder.HasIndex(e => e.NombreUsuario, "UQ_Usuarios_NombreUsuario").IsUnique();

            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.NombreUsuario)
                .HasMaxLength(150)
                .IsUnicode(false);

            builder.HasOne(d => d.Persona).WithMany(p => p.Usuarios)
                .HasForeignKey(d => d.PersonaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Usuarios_PersonaId_Personas_PersonaId");

            builder.HasOne(d => d.Sucursal).WithMany(p => p.Usuarios)
                .HasForeignKey(d => d.SucursalId)
                .HasConstraintName("FK_Usuarios_SucursalId_Sucursales_SucursalId");
        }
    }
}
