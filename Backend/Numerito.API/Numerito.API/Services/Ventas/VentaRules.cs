using Numerito.API.Services.Personas;
using Numerito.API.Services.Usuarios;
using Numerito.API.Services.Ventas.Entities;
using Numerito.API.Utility;

namespace Numerito.API.Services.Ventas
{
    public class VentaRules
    {
        PersonaRules personaRules = new PersonaRules();
        UsuarioRules usuarioRules = new UsuarioRules();
        public Result<bool> ValidacionesAgregarVenta(Venta entidad, List<Persona> listaPersonas,List<Usuario> listaUsuarios)
        {
            Result<bool> validacionPersonaId = personaRules.VerificarPersonaId(listaPersonas, entidad.PersonaId);
            if (!validacionPersonaId.Ok)
                return Result<bool>.Fault(validacionPersonaId.Message);

            Result<bool> validacionUsuarioId = usuarioRules.VerificarUsuarioId(listaUsuarios, entidad.UsuarioId);
            if (!validacionUsuarioId.Ok)
                return Result<bool>.Fault(validacionUsuarioId.Message);

            return Result<bool>.Success(true);
        }
    }
}
