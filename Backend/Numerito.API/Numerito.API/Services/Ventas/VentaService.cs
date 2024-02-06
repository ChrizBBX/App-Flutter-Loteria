using FluentValidation.Results;
using LoteriaApp.WebApi.Data.EntityContext;
using LoteriaApp.WebApi.Utility;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Ventas.VentasDto;
using Numerito.API.Utility;
using static Numerito.API.Data.Entities.Venta;
using static Numerito.API.Services.Reportes.ReportesService;

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
                var listaNumeros = _context.Numeros.AsQueryable().ToList();

                var validaciones = _ventaRules.ValidacionesAgregarVenta(venta, listaPersonas,listaUsuarios,listaMetodosPago);
                if (!validaciones.Ok)
                    return Result<string>.Fault(validaciones.Message);

                _context.Ventas.Add(venta);
                _context.SaveChanges();

                int nuevoID = venta.VentaId;

                foreach ( var item in entidad.VentaDetalles)
                {
                    var validacionesDetalle = _ventaRules.ValidarNumero(listaNumeros, item.NumeroId, item.Valor);
                    if (!validacionesDetalle.Ok)
                        return Result<string>.Fault(validacionesDetalle.Message);

                    VentaDetalle ventaDetalle = new VentaDetalle
                    {
                        VentaId = venta.VentaId,
                        NumeroId = item.NumeroId,
                        Valor = item.Valor,
                    };

                    #region ActualizarStock
                    var Numero = listaNumeros.Where(x => x.NumeroId == item.NumeroId).FirstOrDefault();

                    int cantidadRestar = item.Valor / 5;

                    if (cantidadRestar > Numero.Limite)
                    {
                        Numero.Limite = 0;
                        _context.Numeros.Update(Numero);
                    }
                    else
                    {
                        Numero.Limite = Numero.Limite - cantidadRestar;
                        _context.Numeros.Update(Numero);
                    }
                    #endregion


                    _context.VentaDetalles.Add(ventaDetalle);
                }

                _context.SaveChanges();
                _context.Database.CommitTransaction();
                return Result<string>.Success($"{OutputMessage.SuccessInsertVenta} - {nuevoID}");

            }
            catch (Exception ex)
            {
                _context.Database.RollbackTransaction();
                return Result<string>.Fault(OutputMessage.Error);
            }
        }
        
        public Result<List<VentaCompleta>> GenerarFactura(int? ID)
        {
            var result = (from ventaDetalle in _context.VentaDetalles
                          join venta in _context.Ventas on ventaDetalle.VentaId equals venta.VentaId
                          join persona in _context.Personas on venta.PersonaId equals persona.PersonaId
                          join metodopago in _context.MetodosPagos on venta.MetodoPagoId equals metodopago.MetodoPagoId
                          join numero in _context.Numeros on ventaDetalle.NumeroId equals numero.NumeroId
                          where venta.VentaId == ID
                          select new
                          {
                              VentaId = venta.VentaId,
                              fechaCreacion = venta.FechaCreacion,
                              Nombres = persona.Nombres,
                              Apellidos = persona.Apellidos,
                              Identidad = persona.Identidad,
                              MetodoPagoDescripcion = metodopago.Descripcion,
                              Detalle = new DetalleVenta
                              {
                                  VentaDetalleId = ventaDetalle.VentaDetalleId,
                                  NumeroId = ventaDetalle.NumeroId,
                                  NumeroDescripcion = numero.NumeroDescripcion,
                                  Valor = ventaDetalle.Valor,
                              }
                          })
                          .GroupBy(x => x.VentaId)
                          .Select(group => new VentaCompleta
                          {
                              VentaId = group.Key,
                              fechaCreacion = group.First().fechaCreacion,
                              Nombres = group.First().Nombres,
                              Apellidos = group.First().Apellidos,
                              Identidad = group.First().Identidad,
                              MetodoPagoDescripcion = group.First().MetodoPagoDescripcion,
                              Detalles = group.Select(x => x.Detalle).ToList()
                          })
                          .ToList();

            return Result<List<VentaCompleta>>.Success(result);
        }
    }
}
