namespace Numerito.API.Data.Entities;

public partial class VentaDetalle
{
    public int VentaDetalleId { get; set; }

    public int VentaId { get; set; }

    public int NumeroId { get; set; }

    public decimal Valor { get; set; }

    public virtual Numero Numero { get; set; } = null!;

    public virtual Venta Venta { get; set; } = null!;
}
