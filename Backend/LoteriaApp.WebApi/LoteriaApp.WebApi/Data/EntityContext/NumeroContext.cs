using LoteriaApp.WebApi.Data.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LoteriaApp.WebApi.Data.EntityContext
{
    public class NumeroContext : IEntityTypeConfiguration<Numero>
    {
        public void Configure(EntityTypeBuilder<Numero> builder) 
        {
            builder.ToTable("Numeros");
            builder.HasKey(e => e.NumeroId).HasName("PK_Numeros_NumeroId");

            builder.HasIndex(e => e.Numero1, "UQ_Numeros_Numero").IsUnique();

            builder.Property(e => e.Estado).HasDefaultValue(true);
            builder.Property(e => e.FechaCreacion).HasColumnType("datetime");
            builder.Property(e => e.FechaModificacion).HasColumnType("datetime");
            builder.Property(e => e.Numero1).HasColumnName("Numero");
            builder.Property(e => e.NumeroDescripcion)
                .HasMaxLength(150)
                .IsUnicode(false);
        }
    }
}
