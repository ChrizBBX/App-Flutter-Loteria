using AutoMapper;
using LoteriaApp.WebApi.Utility;
using Numerito.API.Data.Entities;
using Numerito.API.Data;
using Numerito.API.Services.Numeros.NumeroDto;
using Numerito.API.Utility;
using Numerito.API.Services.Numeros;
using System.Drawing;

namespace Numerito.API.Services.Reportes
{
    public class ReportesService
    {
        private readonly NumeritoContext _context;
        private readonly NumeroRules _NumeroRules;
        private readonly IMapper _mapper;


        public class VentaCompleta
        {
            public int VentaId { get; set; }
            public DateTime fechaCreacion { get; set; }
            public string Nombres { get; set; }
            public string Apellidos { get; set; }
            public string Identidad { get; set; }
            public string MetodoPagoDescripcion { get; set; }
            public List<DetalleVenta> Detalles { get; set; }
        }

        public class DetalleVenta
        {
            public int VentaDetalleId { get; set; }
            public int NumeroId { get; set; }
            public string NumeroDescripcion { get; set; }
            public decimal Valor { get; set; }
        }


        public ReportesService(NumeritoContext context, NumeroRules NumeroRules, IMapper mapper)
        {
            _context = context;
            _NumeroRules = NumeroRules;
            _mapper = mapper;
        }


        public Result<List<Numero>> ReporteInventario()
        {

            var result = (from Numero in _context.Numeros.AsQueryable().Where(x => x.Estado == true)
                          select new Numero
                          {
                              NumeroId = Numero.NumeroId,
                              NumeroDescripcion = Numero.NumeroDescripcion,
                              Limite = Numero.Limite,

                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<Numero>>.Success(new List<Numero>());


            return Result<List<Numero>>.Success(result);
        }

        public Result<List<VentaCompleta>> NumerosVendidos(DateTime fecha_inicio, DateTime fecha_fin)
        {
            var result = (from ventaDetalle in _context.VentaDetalles
                          join venta in _context.Ventas on ventaDetalle.VentaId equals venta.VentaId
                          join persona in _context.Personas on venta.PersonaId equals persona.PersonaId
                          join metodopago in _context.MetodosPagos on venta.MetodoPagoId equals metodopago.MetodoPagoId
                          join numero in _context.Numeros on ventaDetalle.NumeroId equals numero.NumeroId
                          where venta.FechaCreacion >= fecha_inicio && venta.FechaCreacion <= fecha_fin
                          select new VentaCompleta
                          {
                              VentaId = venta.VentaId,
                              fechaCreacion = venta.FechaCreacion,
                              Nombres = persona.Nombres,
                              Apellidos = persona.Apellidos,
                              Identidad = persona.Identidad,
                              MetodoPagoDescripcion = metodopago.Descripcion,
                              Detalles = new List<DetalleVenta>
                           {
                               new DetalleVenta
                               {
                                   VentaDetalleId = ventaDetalle.VentaDetalleId,
                                   NumeroId = ventaDetalle.NumeroId,
                                   NumeroDescripcion = numero.NumeroDescripcion,
                                   Valor = ventaDetalle.Valor,
                               }
                           }
                          }).ToList();


            if (result.Count < 1)
                return Result<List<VentaCompleta>>.Success(new List<VentaCompleta>());

            return Result<List<VentaCompleta>>.Success(result);
        }


    }
}

