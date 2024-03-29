﻿using FluentValidation;
using System;
using System.Collections.Generic;

namespace LoteriaApp.WebApi.Data.Entities;

public partial class Usuario
{
    public int UsuarioId { get; set; }

    public string NombreUsuario { get; set; } = null!;

    public string? Contrasena { get; set; }

    public int PersonaId { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public bool? Admin { get; set; }

    public virtual ICollection<Membresia> MembresiaUsuarioCreacionNavigations { get; set; } = new List<Membresia>();

    public virtual ICollection<Membresia> MembresiaUsuarioModificacionNavigations { get; set; } = new List<Membresia>();

    public virtual ICollection<MetodosPago> MetodosPagoUsuarioCreacionNavigations { get; set; } = new List<MetodosPago>();

    public virtual ICollection<MetodosPago> MetodosPagoUsuarioModificacionNavigations { get; set; } = new List<MetodosPago>();

    public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();

    public virtual ICollection<Pedido> PedidoUsuarioCreacionNavigations { get; set; } = new List<Pedido>();

    public virtual ICollection<Pedido> PedidoUsuarioModificacionNavigations { get; set; } = new List<Pedido>();

    public virtual ICollection<Pedido> PedidoUsuarios { get; set; } = new List<Pedido>();

    public virtual Persona Persona { get; set; } = null!;

    public class UsuarioValidations : AbstractValidator<Usuario>
    {
        public UsuarioValidations()
        {
            RuleFor(x => x.NombreUsuario).NotEmpty().MaximumLength(150).WithMessage("Campo nombre Invalido");
            RuleFor(x => x.Contrasena).NotEmpty().WithMessage("Campo contraseña Invalido");
            RuleFor(x => x.PersonaId).NotEmpty().WithMessage("Campo persona Invalido");
        }
    }
}
