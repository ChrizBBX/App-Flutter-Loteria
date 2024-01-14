using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Services.Ventas.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class MunicipioContext : IEntityTypeConfiguration<Municipio>
    {
        public void Configure(EntityTypeBuilder<Municipio> builder)
        {
            builder.ToTable("Municipios");
            builder.HasKey(e => e.MunicipioId).HasName("PK_Municipios_MunicipioId");

            builder.HasIndex(e => e.MunicipioDescripcion, "UQ_Municipios_MunicipioDescripcion").IsUnique();

            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.MunicipioDescripcion)
                .HasMaxLength(1)
                .IsUnicode(false);
        }
    }
}
