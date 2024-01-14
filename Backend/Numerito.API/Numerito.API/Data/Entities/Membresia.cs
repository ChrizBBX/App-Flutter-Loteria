using System;
using System.Collections.Generic;

namespace Numerito.API.Data.Entities;

public partial class Membresia
{
    public int MembresiaId { get; set; }

    public string Descripcion { get; set; } = null!;

    public decimal? Precio { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();

    public virtual Usuario UsuarioCreacionNavigation { get; set; } = null!;

    public virtual Usuario? UsuarioModificacionNavigation { get; set; }
}
