using AutoMapper;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Utility;

namespace Numerito.API.Services.Sucursales
{
    public class SucursalService
    {
        private readonly NumeritoContext _context;
        private readonly SucursalRules _sucursalRules;
        private readonly IMapper _mapper;

        public SucursalService(NumeritoContext context, SucursalRules sucursalRules, IMapper mapper)
        {
            _context = context;
            _sucursalRules = sucursalRules;
            _mapper = mapper;
        }

        public Result<List<Sucursal>> Listado()
        {

            var result = (from Sucursal in _context.Sucursales.AsQueryable().Where(x => x.Estado == true)
                          select new Sucursal
                          {
                              SucursalId = Sucursal.SucursalId,
                              Nombre = Sucursal.Nombre,
                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<Sucursal>>.Success(new List<Sucursal>());


            return Result<List<Sucursal>>.Success(result);
        }


    }
}
