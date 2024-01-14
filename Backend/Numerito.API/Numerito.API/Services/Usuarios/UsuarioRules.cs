using LoteriaApp.WebApi.Utility;
using Numerito.API.Services.Personas;
using Numerito.API.Services.Ventas.Entities;
using Numerito.API.Utility;

namespace Numerito.API.Services.Usuarios
{
    public class UsuarioRules
    {
        PersonaRules personaRules = new PersonaRules();
        public Result<bool> VerificarUsuarioId(List<Usuario> listaUsuarios,int usuarioId)
        {
            var result = listaUsuarios.FirstOrDefault(x => x.UsuarioId == usuarioId);

            if (result == null)
                return Result<bool>.Fault(OutputMessage.FaultUsuarioNotExists);

            return Result<bool>.Success(true);
        }

        public Result<bool> AgregarUsuarioValidaciones(Usuario usuario, List<Persona> listaPersonas,List<Usuario> listaUsuarios)
        {
            Result<bool> validarPersonaId = personaRules.VerificarPersonaId(listaPersonas, usuario.PersonaId);
            if (!validarPersonaId.Ok)
                return Result<bool>.Fault(validarPersonaId.Message);

            Result<bool> validarUsuarioId = VerificarUsuarioId(listaUsuarios, usuario.UsuarioCreacion);
            if (!validarUsuarioId.Ok)
                return Result<bool>.Fault(validarPersonaId.Message);

            return Result<bool>.Success(true);
        }
    }
}
