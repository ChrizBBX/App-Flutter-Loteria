using FluentValidation;

namespace Numerito.API.Data.Entities;

public partial class Venta
{
    public int VentaId { get; set; }

    public int PersonaId { get; set; }

    public int UsuarioId { get; set; }

    public int MetodoPagoId { get; set; }

    public DateTime FechaVenta { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual MetodosPago MetodoPago { get; set; } = null!;

    public virtual Persona Persona { get; set; } = null!;

    public virtual Usuario Usuario { get; set; } = null!;

    public virtual Usuario UsuarioCreacionNavigation { get; set; } = null!;

    public virtual Usuario? UsuarioModificacionNavigation { get; set; }

    public virtual ICollection<VentaDetalle> VentaDetalles { get; set; } = new List<VentaDetalle>();

    public class VentaValidations : AbstractValidator<Venta>
    {
        public VentaValidations()
        {
            RuleFor(x => x.PersonaId).NotEmpty();
            RuleFor(x => x.UsuarioId).NotEmpty();
            RuleFor(x => x.MetodoPagoId).NotEmpty();
        }
    }
}
