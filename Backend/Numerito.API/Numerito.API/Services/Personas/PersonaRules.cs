using LoteriaApp.WebApi.Utility;
using Numerito.API.Data.Entities;
using Numerito.API.Utility;

namespace Numerito.API.Services.Personas
{
    public class PersonaRules
    {
        public Result<bool> VerificarPersonaId(List<Persona> listaPersonas, int personaId)
        {
            var result = listaPersonas.FirstOrDefault(x => x.PersonaId == personaId);

            if (result == null)
                return Result<bool>.Fault(OutputMessage.FaultPersonaNotExists);

            return Result<bool>.Success(true);
        }
    }
}
