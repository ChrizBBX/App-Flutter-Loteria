using LoteriaApp.WebApi.Services.Usuarios;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace LoteriaApp.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsuarioController : ControllerBase
    {
        private readonly UsuarioService _usuarioService;

        public UsuarioController(UsuarioService usuarioService)
        {
            _usuarioService = usuarioService;
        }

        [HttpPost("AgregarUsuarios")]
        public IActionResult AgregarUsuarios(UsuarioDtoC entidad)
        {
            var result = _usuarioService.AgregarUsuarios(entidad);
            return Ok(result);
        }
    }
}
