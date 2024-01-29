using AutoMapper;
using FluentValidation.Results;
using LoteriaApp.WebApi.Data.EntityContext;
using LoteriaApp.WebApi.Utility;
using Microsoft.EntityFrameworkCore;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Utility;
using Numerito.API.Utitily.Scaffolding;
using static Numerito.API.Data.Entities.Venta;
using static Numerito.API.Utitily.Scaffolding.Cierre;

namespace Numerito.API.Services.Personas
{
    public class PersonaService
    {
        private readonly NumeritoContext _context;
        private readonly PersonaRules _PersonaRules;
        private readonly IMapper _mapper;

        public PersonaService(NumeritoContext context, PersonaRules PersonaRules, IMapper mapper)
        {
            _context = context;
            _PersonaRules = PersonaRules;
            _mapper = mapper;
        }
        public Result<List<Persona>> Listado()
        {
            
            var result = (from Persona in _context.Personas.AsQueryable()
                          select new Persona
                          {
                              PersonaId = Persona.PersonaId,
                              Nombres = Persona.Nombres,
                              Apellidos = Persona.Apellidos,
                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<Persona>>.Fault(OutputMessage.FaultLogin);

            return Result<List<Persona>>.Success(result);
        }
    }
}
