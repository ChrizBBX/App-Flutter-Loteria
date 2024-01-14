using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Numerito.API.Services.Usuarios;

namespace Numerito.API.Controllers
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

        [HttpPost("Login")]
        public IActionResult Login(UsuarioDtoL entidad) 
        {
            var result = _usuarioService.Login(entidad);
            return Ok(result);
        }

        [HttpPost("AgregarUsuarios")]
        public IActionResult AgregarUsuarios(UsuarioDtoC entidad) 
        {
            var result = _usuarioService.AgregarUsuarios(entidad);
            return Ok(result);
        }
    }
}
