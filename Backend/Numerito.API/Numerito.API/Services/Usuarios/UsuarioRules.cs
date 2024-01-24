using LoteriaApp.WebApi.Utility;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Personas;
using Numerito.API.Services.Sucursales;
using Numerito.API.Utility;

namespace Numerito.API.Services.Usuarios
{
    public class UsuarioRules
    {
        PersonaRules personaRules = new PersonaRules();
        SucursalRules sucursalRules = new SucursalRules();
        public Result<bool> VerificarUsuarioId(List<Usuario> listaUsuarios,int usuarioId)
        {
            var result = listaUsuarios.FirstOrDefault(x => x.UsuarioId == usuarioId);

            if (result == null)
                return Result<bool>.Fault(OutputMessage.FaultUsuarioNotExists);

            return Result<bool>.Success(true);
        }

        public Result<bool> VerificarUsuarioIdEditar(List<Usuario> listaUsuarios, int? usuarioId)
        {
            var result = listaUsuarios.FirstOrDefault(x => x.UsuarioId == usuarioId);

            if (result == null)
                return Result<bool>.Fault($"{OutputMessage.FaultUsuarioNotExists}, UsuarioEditar: {usuarioId}");

            return Result<bool>.Success(true);
        }

        public Result<bool> AgregarUsuarioValidaciones(Usuario usuario, List<Persona> listaPersonas,List<Usuario> listaUsuarios,List<Sucursal> listaSucursales)
        {
            Result<bool> validarPersonaId = personaRules.VerificarPersonaId(listaPersonas, usuario.PersonaId);
            if (!validarPersonaId.Ok)
                return Result<bool>.Fault(validarPersonaId.Message);

            Result<bool> validarUsuarioId = VerificarUsuarioId(listaUsuarios, usuario.UsuarioCreacion);
            if (!validarUsuarioId.Ok)
                return Result<bool>.Fault(validarUsuarioId.Message);

            Result<bool> validarSucursalId = sucursalRules.VerificarSucursalUsuario(listaSucursales,usuario.SucursalId);
            if (!validarSucursalId.Ok)
                return Result<bool>.Fault(validarSucursalId.Message);

            return Result<bool>.Success(true);
        }

        public Result<bool> EditarUsuarioValidaciones(Usuario usuario, List<Usuario> listaUsuarios, List<Sucursal> listaSucursales)
        {
            Result<bool> validarUsuarioId = VerificarUsuarioIdEditar(listaUsuarios, usuario.UsuarioId);
            if (!validarUsuarioId.Ok)
                return Result<bool>.Fault(validarUsuarioId.Message);

            Result<bool> validarUsuarioIdModificador = VerificarUsuarioIdEditar(listaUsuarios, usuario.UsuarioModificacion);
            if (!validarUsuarioIdModificador.Ok)
                return Result<bool>.Fault(validarUsuarioIdModificador.Message);

            return Result<bool>.Success(true);
        }

        public Result<bool> DesactivarUsuarioValidaciones(List<Usuario> listaUsuarios, int usuarioId)
        {
            Result<bool> validarUsuarioId = VerificarUsuarioId(listaUsuarios, usuarioId);
            if (!validarUsuarioId.Ok)
                return Result<bool>.Fault(validarUsuarioId.Message);

            return Result<bool>.Success(true);
        }
    }
}
