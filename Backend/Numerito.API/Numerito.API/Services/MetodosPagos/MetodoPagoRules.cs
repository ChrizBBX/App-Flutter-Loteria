using LoteriaApp.WebApi.Utility;
using Numerito.API.Data.Entities;
using Numerito.API.Utility;

namespace Numerito.API.Services.MetodosPagos
{
    public class MetodoPagoRules
    {
        public Result<bool> ValidarMetodoPagoId(List<MetodosPago> listaMetodosPago,int metodoPagoId)
        {
            var result = listaMetodosPago.FirstOrDefault(x => x.MetodoPagoId == metodoPagoId);

            if (result == null)
                return Result<bool>.Fault(OutputMessage.FaultMetodoPagoNotExists);

            return Result<bool>.Success(true);
        }
    }
}
