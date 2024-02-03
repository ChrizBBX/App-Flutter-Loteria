using FluentValidation;
using Numerito.API.Utitily.Scaffolding;
using System;
using System.Collections.Generic;

namespace Numerito.API.Data.Entities;

public partial class Usuario
{
    public int UsuarioId { get; set; }

    public string NombreUsuario { get; set; } = null!;

    public string ImagenUrl { get; set; }

    public string? Contrasena { get; set; }

    public int PersonaId { get; set; }

    public int? SucursalId { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public bool? Admin { get; set; }

    public virtual ICollection<Cierre> Cierres { get; set; } = new List<Cierre>();

    public virtual ICollection<Membresia> MembresiaUsuarioCreacionNavigations { get; set; } = new List<Membresia>();

    public virtual ICollection<Membresia> MembresiaUsuarioModificacionNavigations { get; set; } = new List<Membresia>();

    public virtual ICollection<MetodosPago> MetodosPagoUsuarioCreacionNavigations { get; set; } = new List<MetodosPago>();

    public virtual ICollection<MetodosPago> MetodosPagoUsuarioModificacionNavigations { get; set; } = new List<MetodosPago>();

    public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();

    public virtual Persona Persona { get; set; } = null!;

    public virtual Sucursal? Sucursal { get; set; }

    public virtual ICollection<Venta> VentaUsuarioCreacionNavigations { get; set; } = new List<Venta>();

    public virtual ICollection<Venta> VentaUsuarioModificacionNavigations { get; set; } = new List<Venta>();

    public virtual ICollection<Venta> VentaUsuarios { get; set; } = new List<Venta>();

    public class UsuarioValidations : AbstractValidator<Usuario>
    {
        public UsuarioValidations()
        {
            RuleFor(x => x.NombreUsuario).NotEmpty().MaximumLength(150).WithMessage("Campo nombre Invalido");
            RuleFor(x => x.PersonaId).NotEmpty().WithMessage("Campo persona Invalido");
        }
    }
}
