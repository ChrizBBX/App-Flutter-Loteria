using System;
using System.Collections.Generic;

namespace Numerito.API.Services.Ventas.Entities;

public partial class Pago
{
    public int PagoId { get; set; }

    public int UsuarioId { get; set; }

    public int MembresiaId { get; set; }

    public int MetodoPagoId { get; set; }

    public bool? AutoRenovable { get; set; }

    public DateTime FechaVencimiento { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual Membresia Membresia { get; set; } = null!;

    public virtual MetodosPago MetodoPago { get; set; } = null!;

    public virtual Usuario Usuario { get; set; } = null!;
}
