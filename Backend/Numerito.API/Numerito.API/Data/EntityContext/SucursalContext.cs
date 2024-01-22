using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Data.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class SucursalContext : IEntityTypeConfiguration<Sucursal>
    {
        public void Configure(EntityTypeBuilder<Sucursal> builder)
        {
            builder.ToTable("Sucursales");
            builder.HasKey(e => e.SucursalId).HasName("PK_Sucursales_NumeroId");

            builder.HasIndex(e => e.Nombre, "UQ_Sucursales_SucursalDescripcion").IsUnique();

            builder.Property(e => e.Direccion)
                .HasMaxLength(250)
                .IsUnicode(false);
            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.Nombre)
                .HasMaxLength(150)
                .IsUnicode(false);

            builder.HasOne(d => d.Municipio).WithMany(p => p.Sucursales)
                .HasForeignKey(d => d.MunicipioId)
                .HasConstraintName("FK_Sucursales_MunicipioId_Municipios_MunicipioId");
        }
    }
}
