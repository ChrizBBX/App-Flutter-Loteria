using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Services.Ventas.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class PersonaContext : IEntityTypeConfiguration<Persona>
    {
        public void Configure(EntityTypeBuilder<Persona> builder)
        {
            builder.ToTable("Personas");
            builder.HasKey(e => e.PersonaId).HasName("PK_Personas_PersonaId");

            builder.HasIndex(e => e.Identidad, "UQ_Personas_Identidad").IsUnique();

            builder.Property(e => e.Apellidos).HasMaxLength(150);
            builder.Property(e => e.CorreoElectronico).HasMaxLength(150);
            builder.Property(e => e.Direccion).HasMaxLength(250);
            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.Identidad)
                .HasMaxLength(13)
                .IsUnicode(false);
            builder.Property(e => e.Nombres).HasMaxLength(150);
            builder.Property(e => e.Telefono)
                .HasMaxLength(8)
                .IsUnicode(false);
        }
    }
}
