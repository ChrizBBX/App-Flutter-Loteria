using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Data.Entities;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class MunicipioContext : IEntityTypeConfiguration<Municipio>
    {
        public void Configure(EntityTypeBuilder<Municipio> builder)
        {
            builder.ToTable("Municipios");
            builder.HasKey(e => e.MunicipioId).HasName("PK_Municipios_MunicipioId");

            builder.HasIndex(e => e.Codigo, "UQ_Municipios_Codigo").IsUnique();

            builder.HasIndex(e => e.Nombre, "UQ_Municipios_Nombre").IsUnique();

            builder.Property(e => e.Codigo)
                .HasMaxLength(4)
                .IsUnicode(false);
            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.Nombre)
                .HasMaxLength(150)
                .IsUnicode(false);

            builder.HasOne(d => d.Departamento).WithMany(p => p.Municipios)
                .HasForeignKey(d => d.DepartamentoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Municipios_DepartamentoId_Departamentos_DepartamentoId");
        }
    }
}
