using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Services.Ventas.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class SucursalContext : IEntityTypeConfiguration<Sucursal>
    {
        public void Configure(EntityTypeBuilder<Sucursal> builder)
        {
            builder.ToTable("Sucursales");
            builder.HasKey(e => e.SucursalId).HasName("PK_Sucursales_NumeroId");

            builder.HasIndex(e => e.SucursalDescripcion, "UQ_Sucursales_SucursalDescripcion").IsUnique();

            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.SucursalDescripcion)
                .HasMaxLength(150)
                .IsUnicode(false);
        }
    }
}
