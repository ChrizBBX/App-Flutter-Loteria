using System;
using System.Collections.Generic;
using LoteriaApp.WebApi.Data.Entities;
using LoteriaApp.WebApi.Data.EntityContext;
using Microsoft.EntityFrameworkCore;

namespace LoteriaApp.WebApi.Data;

public partial class LoteriaContext : DbContext
{
    public LoteriaContext()
    {
    }

    public LoteriaContext(DbContextOptions<LoteriaContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Departamento> Departamentos { get; set; }

    public virtual DbSet<Membresia> Membresias { get; set; }

    public virtual DbSet<MetodosPago> MetodosPagos { get; set; }

    public virtual DbSet<Municipio> Municipios { get; set; }

    public virtual DbSet<Numero> Numeros { get; set; }

    public virtual DbSet<Pago> Pagos { get; set; }

    public virtual DbSet<Pedido> Pedidos { get; set; }

    public virtual DbSet<PedidoDetalle> PedidoDetalles { get; set; }

    public virtual DbSet<Persona> Personas { get; set; }

    public virtual DbSet<Sucursal> Sucursales { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfiguration(new DepartamentoContext());
        modelBuilder.ApplyConfiguration(new MembresiaContext());
        modelBuilder.ApplyConfiguration(new MetodosPagoContext());
        modelBuilder.ApplyConfiguration(new MunicipioContext());
        modelBuilder.ApplyConfiguration(new NumeroContext());
        modelBuilder.ApplyConfiguration(new PagoContext());
        modelBuilder.ApplyConfiguration(new PedidoContext());
        modelBuilder.ApplyConfiguration(new PedidoDetalleContext());
        modelBuilder.ApplyConfiguration(new PersonaContext());
        modelBuilder.ApplyConfiguration(new SucursalContext());
        modelBuilder.ApplyConfiguration(new UsuarioContext());

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
