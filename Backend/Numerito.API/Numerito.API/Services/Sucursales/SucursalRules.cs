using LoteriaApp.WebApi.Utility;
using Numerito.API.Data.Entities;
using Numerito.API.Utility;

namespace Numerito.API.Services.Sucursales
{
    public class SucursalRules
    {
        public Result<bool> VerificarSucursalUsuario(List<Sucursal> listaSucursales, int? sucursalId)
        {
            if(sucursalId == 0)
                return Result<bool>.Success(true);

            var result = listaSucursales.FirstOrDefault(x => x.SucursalId == sucursalId);
            if (result == null)
                return Result<bool>.Fault($"{OutputMessage.FaultSucursalNotExists}, Sucursal: {sucursalId}");

            return Result<bool>.Success(true);
        }
    }
}
