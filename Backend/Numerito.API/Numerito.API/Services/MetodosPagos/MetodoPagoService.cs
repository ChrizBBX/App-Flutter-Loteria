using AutoMapper;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Utility;

namespace Numerito.API.Services.MetodosPagos
{
    public class MetodoPagoService
    {
        private readonly NumeritoContext _context;
        private readonly MetodoPagoRules _MetodoPagoRules;
        private readonly IMapper _mapper;

        public MetodoPagoService(NumeritoContext context, MetodoPagoRules MetodoPagoRules, IMapper mapper)
        {
            _context = context;
            _MetodoPagoRules = MetodoPagoRules;
            _mapper = mapper;
        }

        public Result<List<MetodosPago>> Listado()
        {

            var result = (from MetodosPago in _context.MetodosPagos.AsQueryable()
                          select new MetodosPago
                          {
                              MetodoPagoId = MetodosPago.MetodoPagoId,
                              Descripcion = MetodosPago.Descripcion,
                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<MetodosPago>>.Success(new List<MetodosPago>());

            return Result<List<MetodosPago>>.Success(result);
        }
    }
}
