using LoteriaApp.WebApi.Utility;
using Numerito.API.Data.Entities;
using Numerito.API.Services.MetodosPagos;
using Numerito.API.Services.Personas;
using Numerito.API.Services.Usuarios;
using Numerito.API.Utility;
using System.Net;

namespace Numerito.API.Services.Ventas
{
    public class VentaRules
    {
        PersonaRules personaRules = new PersonaRules();
        UsuarioRules usuarioRules = new UsuarioRules();
        MetodoPagoRules metodoPagoRules = new MetodoPagoRules();

        public Result<bool> ValidacionesAgregarVenta(Venta entidad, List<Persona> listaPersonas,List<Usuario> listaUsuarios,List<MetodosPago> listaMetodosPago)
        {
            Result<bool> validacionPersonaId = personaRules.VerificarPersonaId(listaPersonas, entidad.PersonaId);
            if (!validacionPersonaId.Ok)
                return Result<bool>.Fault(validacionPersonaId.Message);

            Result<bool> validacionUsuarioId = usuarioRules.VerificarUsuarioId(listaUsuarios, entidad.UsuarioId);
            if (!validacionUsuarioId.Ok)
                return Result<bool>.Fault(validacionUsuarioId.Message);

            Result<bool> validacionMetodoPagoId = metodoPagoRules.ValidarMetodoPagoId(listaMetodosPago, entidad.MetodoPagoId);
            if (!validacionMetodoPagoId.Ok)
                return Result<bool>.Fault(validacionMetodoPagoId.Message);

            return Result<bool>.Success(true);
        }

        public Result<bool> ValidarNumero(List<Numero> listaNumeros, int numeroId, int valor)
        {
            var result = listaNumeros.FirstOrDefault(x => x.NumeroId == numeroId);
            if (result == null)
                return Result<bool>.Fault($"{OutputMessage.FaultNumeroNotExists}, Numero: {numeroId}");

            var limite = result.Limite * 5;
            if (valor > limite)
                return Result<bool>.Fault($"{OutputMessage.FaultNumeroLimit}, Numero: {numeroId}, Maximo : {limite}");

            return Result<bool>.Success(true);
        }
    }
}
