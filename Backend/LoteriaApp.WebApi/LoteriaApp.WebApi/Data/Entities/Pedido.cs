using System;
using System.Collections.Generic;

namespace LoteriaApp.WebApi.Data.Entities;

public partial class Pedido
{
    public int PedidoId { get; set; }

    public string NumeroPedido { get; set; } = null!;

    public int PersonaId { get; set; }

    public int UsuarioId { get; set; }

    public int MetodoPagoId { get; set; }

    public DateTime FechaPedido { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual MetodosPago MetodoPago { get; set; } = null!;

    public virtual ICollection<PedidoDetalle> PedidoDetalles { get; set; } = new List<PedidoDetalle>();

    public virtual Persona Persona { get; set; } = null!;

    public virtual Usuario Usuario { get; set; } = null!;

    public virtual Usuario UsuarioCreacionNavigation { get; set; } = null!;

    public virtual Usuario? UsuarioModificacionNavigation { get; set; }
}
