using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using LoteriaApp.WebApi.Utility;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Utility;
using static Numerito.API.Data.Entities.Usuario;


namespace Numerito.API.Services.Usuarios
{
    public class UsuarioService
    {
        private readonly NumeritoContext _context;
        private readonly UsuarioRules _rules;
        private readonly IMapper _mapper;

        public UsuarioService(NumeritoContext loteriaContext, UsuarioRules rules, IMapper mapper)
        {
            _context = loteriaContext;
            _rules = rules;
            _mapper = mapper;
        }

        public Result<List<UsuarioDto>> Listado()
        {

            var result = (from Usuario in _context.Usuarios.AsQueryable().Where(x => x.Estado == true)
                          select new UsuarioDto
                          {
                              UsuarioId = Usuario.UsuarioId,
                              NombreUsuario = Usuario.NombreUsuario,

                              PersonaId = Usuario.PersonaId,
                              SucursalId = Usuario.SucursalId,
                              Admin = Usuario.Admin,

                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<UsuarioDto>>.Success(new List<UsuarioDto>());


            return Result<List<UsuarioDto>>.Success(result);
        }

        public Result<List<UsuarioDto>> Login(UsuarioDtoL entidad)
        {
            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);

            List<Usuario> listaUsuarios = _context.Usuarios.ToList();
            var result = (from usuario in listaUsuarios
                          join pago in _context.Pagos
                              on usuario.UsuarioId equals pago.UsuarioId into pagosJoin
                          from pago in pagosJoin.DefaultIfEmpty()
                          where usuario.NombreUsuario == entidad.NombreUsuario && usuario.Contrasena == password
                          select new UsuarioDto
                          {
                              UsuarioId = usuario.UsuarioId,
                              NombreUsuario = usuario.NombreUsuario,
                              PersonaId = usuario.PersonaId,
                              Admin = usuario.Admin,
                              FechaSus = pago != null ? pago.FechaVencimiento : (DateTime?)null
                          }).ToList();



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
                SucursalId = entidad.SucursalId,

                UsuarioCreacion = entidad.UsuarioCreacion,
                FechaCreacion = DateTime.Now,
                Admin = true
            };

            UsuarioValidations validator = new UsuarioValidations();
            validator.RuleFor(x => x.UsuarioCreacion).NotEmpty().WithMessage("Campo UsuarioCreacion Invalido");
            validator.RuleFor(x => x.Contrasena).NotEmpty().WithMessage("Campo contraseña Invalido");

            ValidationResult validationResult = validator.Validate(usuario);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

            var listaUsuarios = _context.Usuarios.AsQueryable().Where(x => x.Estado == true).ToList();
            var listaPersonas = _context.Personas.AsQueryable().Where(x => x.Estado == true).ToList();
            var listaSucursales = _context.Sucursales.AsQueryable().Where(x => x.Estado == true).ToList();
            var validaciones = _rules.AgregarUsuarioValidaciones(usuario, listaPersonas, listaUsuarios, listaSucursales);

            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            if (entidad.SucursalId == 0)
                usuario.SucursalId = null;

            _context.Add(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessInsertUsuario);
        }

        public Result<string> EditarUsuarios(UsuarioDto entidad)
        {
            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);


            UsuarioValidations validator = new UsuarioValidations();
            validator.RuleFor(x => x.UsuarioModificacion).NotEmpty().WithMessage("Campo UsuarioModificacion Invalido");

            //var listaUsuarios = _context.Usuarios.AsQueryable().ToList();
            List<Usuario> listaUsuarios = _context.Usuarios.ToList();


            var usuario = listaUsuarios.FirstOrDefault(x => x.UsuarioId == entidad.UsuarioId);
            if (usuario == null) return Result<string>.Fault(OutputMessage.FaultUsuarioNotExists);

            usuario.Contrasena = password;
            usuario.UsuarioModificacion = usuario.UsuarioModificacion;
            usuario.FechaModificacion = entidad.FechaModificacion;
            usuario.NombreUsuario = usuario.NombreUsuario;

            if (!string.IsNullOrEmpty(usuario.Contrasena))
            {
                usuario.Contrasena = password;
            }

            usuario.PersonaId = usuario.PersonaId;
            usuario.SucursalId = usuario.SucursalId == 0 ? null : usuario.SucursalId;
            usuario.UsuarioModificacion = usuario.UsuarioModificacion;
            usuario.FechaModificacion = usuario.FechaModificacion ?? DateTime.Now;
            _context.Usuarios.Update(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessUpdateUsuario);
        }


        public Result<string> DesactivarUsuarios(int usuarioId)
        {

            var listaUsuarios = _context.Usuarios.AsQueryable().ToList();
            var validaciones = _rules.DesactivarUsuarioValidaciones(listaUsuarios, usuarioId);

            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            var usuario = listaUsuarios.FirstOrDefault(x => x.UsuarioId == usuarioId);
            if (usuario == null) return Result<string>.Fault(OutputMessage.FaultUsuarioNotExists);

            usuario.Estado = false;
            _context.Usuarios.Update(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessDisableUsuario);
        }

        public Result<string> EditarContrasenia(UsuarioDto entidad)
        {
            var listaUsuarios = _context.Usuarios.AsQueryable().ToList();

            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);

            var usuario = listaUsuarios.FirstOrDefault(x => x.UsuarioId == entidad.UsuarioId);
            if (usuario == null) return Result<string>.Fault(OutputMessage.FaultUsuarioNotExists);

            usuario.Contrasena = password;
            usuario.UsuarioModificacion = usuario.UsuarioModificacion;
            usuario.FechaModificacion = entidad.FechaModificacion;

            _context.Usuarios.Update(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessUpdateUsuario);
        }

        public Result<string> EditarImagen(UsuarioDto entidad)
        {
            var listaUsuarios = _context.Usuarios.AsQueryable().ToList();



            var usuario = listaUsuarios.FirstOrDefault(x => x.UsuarioId == entidad.UsuarioId);
            if (usuario == null) return Result<string>.Fault(OutputMessage.FaultUsuarioNotExists);

            //usuario.ImagenUrl = entidad.ImagenUrl;
            usuario.UsuarioModificacion = entidad.UsuarioModificacion;
            usuario.FechaModificacion = entidad.FechaModificacion;

            _context.Usuarios.Update(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessUpdateUsuario);
        }
    }
}
