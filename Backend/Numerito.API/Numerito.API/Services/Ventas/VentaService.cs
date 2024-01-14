using FluentValidation.Results;
using LoteriaApp.WebApi.Utility;
using Numerito.API.Services.Ventas.Entities;
using Numerito.API.Services.Ventas.VentasDto;
using Numerito.API.Utility;
using static Numerito.API.Services.Ventas.Entities.Venta;

namespace Numerito.API.Services.Ventas
{
    public class VentaService
    {

        public Result<string> AgregarVenta(VentaDtoC entidad)
        {
            Venta venta = new Venta
            {
                NumeroVenta = entidad.NumeroVenta,
                PersonaId = entidad.PersonaId,
                UsuarioId = entidad.UsuarioId,
                MetodoPagoId = entidad.MetodoPagoId,
                FechaVenta = entidad.FechaVenta,

                UsuarioCreacion = entidad.UsuarioCreacion,
                FechaCreacion = entidad.FechaVenta,
                FechaModificacion = null,
                UsuarioModificacion = null,
                Estado = true
            };

            VentaValidations validator = new VentaValidations();
            ValidationResult validationResult = validator.Validate(venta);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

            return Result<string>.Success("");
        }
    }
}
