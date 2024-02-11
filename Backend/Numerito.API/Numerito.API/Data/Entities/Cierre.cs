using FluentValidation;
using Numerito.API.Data.Entities;

namespace Numerito.API.Utitily.Scaffolding;

public partial class Cierre
{
    public int CierreId { get; set; }

    public int NumeroId { get; set; }

    public int UsuarioId { get; set; }

    public DateTime FechaCierre { get; set; }

    public virtual Numero Numero { get; set; } = null!;

    public virtual Usuario Usuario { get; set; } = null!;

    public class CierreValidations : AbstractValidator<Cierre>
    {
        public CierreValidations()
        {
            // RuleFor(x => x.NumeroId).NotEmpty().WithMessage("El numero no puede estar vacio");
            RuleFor(x => x.UsuarioId).NotEmpty().WithMessage("El usuario no puede estar vacio");
            RuleFor(x => x.FechaCierre).NotEmpty().WithMessage("La fecha de cierre no es valida");
        }
    }
}
