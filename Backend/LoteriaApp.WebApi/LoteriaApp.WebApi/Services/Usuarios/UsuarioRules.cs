using LoteriaApp.WebApi.Data.Entities;
using LoteriaApp.WebApi.Utility;

namespace LoteriaApp.WebApi.Services.Usuarios
{
    public class UsuarioRules
    {
        public Result<bool> AgregarUsuarioValidaciones(Usuario usuario, List<Persona> listaPersonas)
        {


            return Result<bool>.Success(true);
        }
    }
}
