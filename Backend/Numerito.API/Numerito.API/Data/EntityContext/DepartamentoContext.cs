using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Data.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class DepartamentoContext : IEntityTypeConfiguration<Departamento>
    {
        public void Configure(EntityTypeBuilder<Departamento> builder)
        {
            builder.ToTable("Departamentos");
            builder.HasKey(e => e.DepartamentoId).HasName("PK_Departamentos_DepartamentoId");

            builder.HasIndex(e => e.Codigo, "UQ_Departamentos_Codigo").IsUnique();

            builder.HasIndex(e => e.Nombre, "UQ_Departamentos_Nombre").IsUnique();

            builder.Property(e => e.Codigo)
                .HasMaxLength(2)
                .IsUnicode(false);
            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.Nombre)
                .HasMaxLength(100)
                .IsUnicode(false);
        }
    }
}
