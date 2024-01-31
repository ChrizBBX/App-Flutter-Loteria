using AutoMapper;
using LoteriaApp.WebApi.Utility;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Numeros.NumeroDto;
using Numerito.API.Utility;

namespace Numerito.API.Services.Numeros
{
    public class NumeroService
    {
        private readonly NumeritoContext _context;
        private readonly NumeroRules _NumeroRules;
        private readonly IMapper _mapper;

        public NumeroService(NumeritoContext context, NumeroRules NumeroRules, IMapper mapper)
        {
            _context = context;
            _NumeroRules = NumeroRules;
            _mapper = mapper;
        }

        public Result<List<Numero>> Listado()
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

        public Result<string> EditarLimite(NumeroDtos entidad)
        {
            var listaNumeros = _context.Numeros.AsQueryable().ToList();



            var numero = listaNumeros.FirstOrDefault(x => x.NumeroId == entidad.NumeroId);
            if (numero == null) return Result<string>.Fault(OutputMessage.FaultNumeroNotExists);

            numero.Limite = entidad.Limite;
            numero.UsuarioModificacion = entidad.UsuarioModificacion;
            numero.FechaModificacion = entidad.FechaModificacion;


            _context.Numeros.Update(numero);

            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessUpdateNumero);
        }
    }
}
