using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
using LoteriaApp.WebApi.Data.EntityContext;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using LoteriaApp.WebApi.Utility;
using Microsoft.EntityFrameworkCore;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Personas.PersonasDtos;
using Numerito.API.Utility;
using Numerito.API.Utitily.Scaffolding;
using static Numerito.API.Data.Entities.Persona;
using static Numerito.API.Data.Entities.Usuario;

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
            
            var result = (from Persona in _context.Personas.AsQueryable().Where(x => x.Estado == true)
                          select new Persona
                          {
                              PersonaId = Persona.PersonaId,
                              Nombres = Persona.Nombres,
                              Apellidos = Persona.Apellidos,
                              Identidad = Persona.Identidad,
                              Telefono = Persona.Telefono,
                              CorreoElectronico = Persona.CorreoElectronico,
                              Direccion = Persona.Direccion,

                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<Persona>>.Success(new List<Persona>());


            return Result<List<Persona>>.Success(result);
        }

        public Result<string> AgregarPersona(PersonaDto entidad)
        {
            
            Persona persona = new Persona()
            {
                Nombres = entidad.Nombres,
                Apellidos = entidad.Apellidos,
                Identidad = entidad.Identidad,
                Telefono = entidad.Telefono,
                CorreoElectronico = entidad.CorreoElectronico,
                Direccion = entidad.Direccion,
                UsuarioCreacion = entidad.UsuarioCreacion,
                FechaCreacion = entidad.FechaCreacion
                
            };

            PersonaValidations validator = new PersonaValidations();
            validator.RuleFor(x => x.UsuarioCreacion).NotEmpty().WithMessage("Campo UsuarioCreacion Invalido");

            ValidationResult validationResult = validator.Validate(persona);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityPersona);
            }

            var listaPersonas = _context.Personas.AsQueryable().Where(x => x.Identidad == persona.Identidad).ToList();

            if (listaPersonas.Count > 0)
                return Result<string>.Success(OutputMessage.FaultPersonaIdentidadExists);




            _context.Add(persona);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessInsertUsuario);
        }

        public Result<string> EditarPersona(PersonaDto entidad)
        {
            var listaPersonas = _context.Personas.AsQueryable().ToList();
            
            var persona = listaPersonas.FirstOrDefault(x => x.PersonaId == entidad.PersonaId);
            if (persona == null) return Result<string>.Fault(OutputMessage.FaultPersonaNotExists);
            
            var identidad = listaPersonas.FirstOrDefault(x => x.Identidad == entidad.Identidad && x.PersonaId != entidad.PersonaId);
            if (identidad != null) return Result<string>.Fault(OutputMessage.FaultPersonaIdentidadExists);

            PersonaValidations validator = new PersonaValidations();
            validator.RuleFor(x => x.UsuarioModificacion).NotEmpty().WithMessage("Campo UsuarioCreacion Invalido");

            persona.Nombres = entidad.Nombres;
            persona.Apellidos = entidad.Apellidos;
            persona.Identidad = entidad.Identidad;
            persona.Telefono = entidad.Telefono;
            persona.CorreoElectronico = entidad.CorreoElectronico;
            persona.Direccion = entidad.Direccion;

            _context.Personas.Update(persona);

            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessUpdatePersona);
        }

    }
}
