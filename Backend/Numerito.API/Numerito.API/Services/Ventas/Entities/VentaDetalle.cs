using System;
using System.Collections.Generic;

namespace Numerito.API.Services.Ventas.Entities;

public partial class VentaDetalle
{
    public int VentaDetalleId { get; set; }

    public int VentaId { get; set; }

    public int Numero { get; set; }

    public decimal Valor { get; set; }

    public virtual Venta Venta { get; set; } = null!;
}
