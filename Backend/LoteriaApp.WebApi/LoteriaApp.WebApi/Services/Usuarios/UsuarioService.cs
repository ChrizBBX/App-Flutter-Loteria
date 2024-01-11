using FluentValidation.Results;
using LoteriaApp.WebApi.Data;
using LoteriaApp.WebApi.Data.Entities;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using LoteriaApp.WebApi.Utility;
using Microsoft.AspNetCore.Http.HttpResults;
using static LoteriaApp.WebApi.Data.Entities.Usuario;

namespace LoteriaApp.WebApi.Services.Usuarios
{
    public class UsuarioService
    {
        private readonly LoteriaContext _context;
        private readonly UsuarioRules _rules;
        public UsuarioService(LoteriaContext loteriaContext, UsuarioRules rules)
        {
            _context = loteriaContext;
            _rules = rules;
        }

        public Result<List<Usuario>> Login(UsuarioDtoL entidad) 
        {
            var usuario = _context.Usuarios.FirstOrDefault(x => x.NombreUsuario == entidad.NombreUsuario && x.Contrasena  == entidad.Contrasena);
            
            if (usuario == null)
                return Result<List<Usuario>>.Fault("Esto fallo");

            return Result.Success(usuario);
        }

        public Result<string> AgregarUsuarios(UsuarioDtoC entidad)
        {
            Usuario usuario = new Usuario()
            {
                NombreUsuario = entidad.NombreUsuario,
                Contrasena = entidad.Contrasena,
                PersonaId = entidad.PersonaId,

                UsuarioCreacion = entidad.UsuarioCreacion,
                FechaCreacion = DateTime.Now,
                Admin = true
            };

            UsuarioValidations validator = new UsuarioValidations();
            ValidationResult validationResult = validator.Validate(usuario);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

            var listaPersonas = _context.Personas.Where(x => x.Estado == true).ToList();
            var validaciones = _rules.AgregarUsuarioValidaciones(usuario,listaPersonas);

            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);
            
            _context.Add(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessInsertUsuario);
        }
    }
}
