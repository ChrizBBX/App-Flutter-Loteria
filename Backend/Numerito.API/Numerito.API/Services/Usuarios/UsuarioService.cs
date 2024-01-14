using FluentValidation;
using FluentValidation.Results;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using LoteriaApp.WebApi.Utility;
using Microsoft.OpenApi.Any;
using Numerito.API.Data;
using Numerito.API.Services.Ventas.Entities;
using Numerito.API.Utility;
using static Numerito.API.Services.Ventas.Entities.Usuario;

namespace Numerito.API.Services.Usuarios
{
    public class UsuarioService
    {
        private readonly NumeritoContext _context;
        private readonly UsuarioRules _rules;
        public UsuarioService(NumeritoContext loteriaContext, UsuarioRules rules)
        {
            _context = loteriaContext;
            _rules = rules;
        }

        public Result<List<UsuarioDto>> Login(UsuarioDtoL entidad)
        {
            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);

            var result = (from usuario in _context.Usuarios.AsQueryable()
                          where usuario.NombreUsuario == entidad.NombreUsuario && usuario.Contrasena == password
                          select new UsuarioDto
                          {
                              UsuarioId = usuario.UsuarioId,
                              NombreUsuario = usuario.NombreUsuario,
                              PersonaId = usuario.PersonaId,
                              Admin = usuario.Admin,
                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<UsuarioDto>>.Fault(OutputMessage.FaultLogin);

            return Result<List<UsuarioDto>>.Success(result);
        }

        public Result<string> AgregarUsuarios(UsuarioDtoC entidad)
        {
            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);

            Usuario usuario = new Usuario()
            {
                NombreUsuario = entidad.NombreUsuario,
                Contrasena = password,
                PersonaId = entidad.PersonaId,

                UsuarioCreacion = entidad.UsuarioCreacion,
                FechaCreacion = DateTime.Now,
                Admin = true
            };

            UsuarioValidations validator = new UsuarioValidations();
            validator.RuleFor(x => x.UsuarioCreacion).NotEmpty().WithMessage("Campo UsuarioCreacion Invalido");

            ValidationResult validationResult = validator.Validate(usuario);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

           var listaUsuarios = _context.Usuarios.AsQueryable().Where(x => x.Estado == true).ToList();
           var listaPersonas = _context.Personas.AsQueryable().Where(x => x.Estado == true).ToList();
           var validaciones = _rules.AgregarUsuarioValidaciones(usuario, listaPersonas,listaUsuarios);

            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            _context.Add(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessInsertUsuario);
        }
    }
}
