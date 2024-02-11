using Numerito.API.Utitily.Scaffolding;

namespace Numerito.API.Data.Entities;

public partial class Numero
{
    public int NumeroId { get; set; }

    public string? NumeroDescripcion { get; set; }

    public int? Limite { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual ICollection<Cierre> Cierres { get; set; } = new List<Cierre>();

    public virtual ICollection<VentaDetalle> VentaDetalles { get; set; } = new List<VentaDetalle>();
}
