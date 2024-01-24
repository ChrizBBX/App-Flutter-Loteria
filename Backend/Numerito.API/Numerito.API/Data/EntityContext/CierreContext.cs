using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Numerito.API.Utitily.Scaffolding;

namespace Numerito.API.Data.EntityContext
{
    public class CierreContext : IEntityTypeConfiguration<Cierre>
    {
        public void Configure(EntityTypeBuilder<Cierre> builder) 
        {
            builder.ToTable("Cierres");
            builder.HasKey(e => e.CierreId).HasName("PK_Cierres_CierreId");

            builder.Property(e => e.FechaCierre).HasColumnType("datetime");

            builder.HasOne(d => d.Numero).WithMany(p => p.Cierres)
                .HasForeignKey(d => d.NumeroId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Cierres_NumeroId_Numeros_NumeroId");

            builder.HasOne(d => d.Usuario).WithMany(p => p.Cierres)
                .HasForeignKey(d => d.UsuarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Cierres_UsuarioId_Usuarios_UsuarioId");
        }
    }
}
