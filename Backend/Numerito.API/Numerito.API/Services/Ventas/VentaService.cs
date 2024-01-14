using FluentValidation.Results;
using LoteriaApp.WebApi.Data.EntityContext;
using LoteriaApp.WebApi.Utility;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Ventas.VentasDto;
using Numerito.API.Utility;
using static Numerito.API.Data.Entities.Venta;

namespace Numerito.API.Services.Ventas
{
    public class VentaService
    {
        private readonly NumeritoContext _context;
        private readonly VentaRules _ventaRules;
        public VentaService(NumeritoContext context,VentaRules ventaRules)
        {
                _context = context;
                _ventaRules = ventaRules;
        }
        public Result<string> AgregarVenta(VentaDtoC entidad)
        {
            try
            {
                _context.Database.BeginTransaction();
                Venta venta = new Venta
                {
                    VentaId = 0,
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
                    _context.Database.RollbackTransaction();
                    return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
                }

                var listaPersonas = _context.Personas.AsQueryable().ToList();
                var listaUsuarios = _context.Usuarios.AsQueryable().ToList();
                var listaMetodosPago = _context.MetodosPagos.AsQueryable().ToList();



                var validaciones = _ventaRules.ValidacionesAgregarVenta(venta, listaPersonas,listaUsuarios,listaMetodosPago);
                if (!validaciones.Ok)
                    return Result<string>.Fault(validaciones.Message);

                _context.Ventas.Add(venta);
                _context.SaveChanges();
                _context.Database.CommitTransaction();
                return Result<string>.Success(OutputMessage.SuccessInsertVenta);
            }
            catch (Exception ex)
            {
                _context.Database.RollbackTransaction();
                return Result<string>.Fault(OutputMessage.Error);
            }
        }
    }
}
