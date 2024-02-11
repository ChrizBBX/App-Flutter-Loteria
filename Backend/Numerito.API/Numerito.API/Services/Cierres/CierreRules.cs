using LoteriaApp.WebApi.Utility;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Usuarios;
using Numerito.API.Utility;
using Numerito.API.Utitily.Scaffolding;

namespace Numerito.API.Services.Cierres
{
    public class CierreRules
    {
        UsuarioRules usuarioRules = new UsuarioRules();
        public Result<bool> AgregarCierreValidaciones(List<Cierre> listaCierres, List<Usuario> listaUsuarios, List<Numero> listaNumeros, Cierre entidad)
        {
            Result<bool> verificarUsuarioId = usuarioRules.VerificarUsuarioId(listaUsuarios, entidad.UsuarioId);
            if (!verificarUsuarioId.Ok)
                return Result<bool>.Fault(verificarUsuarioId.Message);

            Result<bool> verificarCierre = ValidarCierre(listaCierres, entidad.FechaCierre, entidad.UsuarioId);
            if (!verificarCierre.Ok)
                return Result<bool>.Fault(verificarCierre.Message);

            return Result<bool>.Success(true);
        }

        public Result<bool> ValidarCierre(List<Cierre> listaCierres, DateTime Fecha, int usuarioId)
        {
            var result = (from cierre in listaCierres
                          where usuarioId == cierre.UsuarioId && Fecha.Day == cierre.FechaCierre.Day
                          select cierre
                         ).ToList();

            if (result.Count > 2)
                return Result<bool>.Fault(OutputMessage.FaultLimitCierre);

            return Result<bool>.Success(true);
        }
    }
}
