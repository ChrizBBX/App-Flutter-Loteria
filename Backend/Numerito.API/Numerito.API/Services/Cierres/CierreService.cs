using AutoMapper;
using FluentValidation.Results;
using LoteriaApp.WebApi.Data.EntityContext;
using LoteriaApp.WebApi.Utility;
using Microsoft.EntityFrameworkCore;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Cierres.CierreDtos;
using Numerito.API.Utility;
using Numerito.API.Utitily.Scaffolding;
using static Numerito.API.Data.Entities.Venta;
using static Numerito.API.Services.Reportes.ReportesService;
using static Numerito.API.Utitily.Scaffolding.Cierre;

namespace Numerito.API.Services.Cierres
{
    public class CierreService
    {
        private readonly NumeritoContext _context;
        private readonly CierreRules _cierreRules;
        private readonly IMapper _mapper;

        public CierreService(NumeritoContext context, CierreRules cierreRules,IMapper mapper)
        {
            _context = context;
            _cierreRules = cierreRules;
            _mapper = mapper;
        }
        public Result<string> AgregarCierre(CierreDto entidad)
        {
            var cierre = _mapper.Map<Cierre>(entidad);
            CierreValidations validator = new CierreValidations();
            ValidationResult validationResult = validator.Validate(cierre);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

            var listaCierres = _context.Cierres.AsQueryable().ToList();
            var listaUsuarios = _context.Usuarios.AsQueryable().ToList();
            var listaNumeros = _context.Numeros.AsQueryable().ToList();

            var validaciones = _cierreRules.AgregarCierreValidaciones(listaCierres, listaUsuarios, listaNumeros, cierre);
            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            _context.Cierres.Add(cierre);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessInsertCierre);
        }

        public Result<List<CierreDto>> Listado(int id)
        {
            var result = (from c in _context.Cierres
                          where c.UsuarioId == id
                          orderby c.FechaCierre
                          select new CierreDto
                          {
                              CierreId = c.CierreId,
                              NumeroId = c.NumeroId,
                              FechaCierre = c.FechaCierre
                          })
                         .ToList();

            if (result.Count < 1)
                return Result<List<CierreDto>>.Success(new List<CierreDto>());

            var numberedResults = new List<CierreDto>();
            DateTime currentDate = result[0].FechaCierre.Date;
            int counter = 1;

            foreach (var cierreDto in result)
            {
                if (cierreDto.FechaCierre.Date != currentDate)
                {
                    currentDate = cierreDto.FechaCierre.Date;
                    counter = 1;
                }

                cierreDto.NumeroRegistro = counter;
                numberedResults.Add(cierreDto);
                counter++;
            }

            return Result<List<CierreDto>>.Success(numberedResults);
        }



        public Result<List<VentaCompleta>> FacturasxJornada(int id, DateTime facturafechajornada)
        {
            var horaInicio = new TimeSpan(0, 0, 0);
            var horaFin = new TimeSpan(0, 50, 0);

            switch (id)
            {
                case 1:
                     horaInicio = new TimeSpan(6, 0, 0);
                     horaFin = new TimeSpan(10, 50, 0);
                    break;
                case 2:
                    horaInicio = new TimeSpan(11, 10, 0);
                    horaFin = new TimeSpan(14, 50, 0);
                    break;
                case 3:
                    horaInicio = new TimeSpan(3, 10, 0);
                    horaFin = new TimeSpan(20, 50, 0);
                    break;
                default:
                    break;
            }
            var result = (from ventaDetalle in _context.VentaDetalles
                          join venta in _context.Ventas on ventaDetalle.VentaId equals venta.VentaId
                          join persona in _context.Personas on venta.PersonaId equals persona.PersonaId
                          join metodopago in _context.MetodosPagos on venta.MetodoPagoId equals metodopago.MetodoPagoId
                          join numero in _context.Numeros on ventaDetalle.NumeroId equals numero.NumeroId
                          where venta.FechaVenta.Date == facturafechajornada.Date && (
                                venta.FechaVenta.TimeOfDay >= horaInicio &&
                                venta.FechaVenta.TimeOfDay <= horaFin)
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

            if (result.Count < 1)
                return Result<List<VentaCompleta>>.Success(new List<VentaCompleta>());

            return Result<List<VentaCompleta>>.Success(result);
        }

        public Result<string> EliminarCierre(int id)
        {

            var listaCierres = _context.Cierres.AsQueryable().ToList();
            
            var cierre = listaCierres.FirstOrDefault(x => x.CierreId == id);
            if (cierre == null) return Result<string>.Fault(OutputMessage.FaultCierreNotExists);

            _context.Cierres.Remove(cierre);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessDeleteCierre);
        }

        public Result<List<VentaCompleta>> CantidadNumCierre(DateTime fecha, int idusuario, int id)
        {

            var horaInicio = new TimeSpan(0, 0, 0);
            var horaFin = new TimeSpan(0, 50, 0);

            switch (id)
            {
                case 1:
                    horaInicio = new TimeSpan(6, 0, 0);
                    horaFin = new TimeSpan(10, 50, 0);
                    break;
                case 2:
                    horaInicio = new TimeSpan(11, 10, 0);
                    horaFin = new TimeSpan(14, 50, 0);
                    break;
                case 3:
                    horaInicio = new TimeSpan(3, 10, 0);
                    horaFin = new TimeSpan(20, 50, 0);
                    break;
                default:
                    break;
            }
            var result = (from ventaDetalle in _context.VentaDetalles
                          join venta in _context.Ventas on ventaDetalle.VentaId equals venta.VentaId
                          where venta.FechaVenta.Date == fecha.Date && (
                               venta.FechaVenta.TimeOfDay >= horaInicio &&
                               venta.FechaVenta.TimeOfDay <= horaFin) &&
                               venta.UsuarioCreacion == idusuario
                          group new { ventaDetalle, venta } by ventaDetalle.NumeroId into grouped
                          select new VentaCompleta
                          {
                              IdNumero = grouped.Key,
                              Cantidad = (int)grouped.Sum(x => x.ventaDetalle.Valor / 5),
                              Detalles = grouped.Select(x => new DetalleVenta
                              {
                                  VentaDetalleId = x.ventaDetalle.VentaDetalleId,
                                  NumeroId = x.ventaDetalle.NumeroId,
                                  NumeroDescripcion = x.ventaDetalle.Numero.NumeroDescripcion,
                                  Valor = x.ventaDetalle.Valor,
                              }).ToList()
                          }).ToList();


            if (result.Count < 1)
                return Result<List<VentaCompleta>>.Success(new List<VentaCompleta>());

            return Result<List<VentaCompleta>>.Success(result);
        }

    }
}
