using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Services.Ventas.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class DepartamentoContext : IEntityTypeConfiguration<Departamento>
    {
        public void Configure(EntityTypeBuilder<Departamento> builder)
        {
            builder.ToTable("Departamentos");
            builder.HasKey(e => e.DepartamentoId).HasName("PK_Departamentos_DepartamentoId");

            builder.HasIndex(e => e.DepartamentoDescripcion, "UQ_Departamentos_DepartamentoDescripcion").IsUnique();

            builder.Property(e => e.DepartamentoDescripcion)
                .HasMaxLength(100)
                .IsUnicode(false);
            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
        }
    }
}
