using System;
using System.Collections.Generic;

namespace LoteriaApp.WebApi.Data.Entities;

public partial class PedidoDetalle
{
    public int PedidoDetalleId { get; set; }

    public int PedidoId { get; set; }

    public int Numero { get; set; }

    public decimal Valor { get; set; }

    public virtual Pedido Pedido { get; set; } = null!;
}
