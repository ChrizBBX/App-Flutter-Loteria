using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Personas;
using Numerito.API.Services.Personas.PersonasDtos;
using Numerito.API.Services.Usuarios;

namespace Numerito.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PersonaController : ControllerBase
    {
            private readonly PersonaService _PersonaService;

            public PersonaController(PersonaService PersonaService)
            {
                _PersonaService = PersonaService;
            }


            [HttpGet("Listado")]
            public IActionResult Listado()
            {
                var result = _PersonaService.Listado();
                return Ok(result);
            }

            [HttpPost("AgregarPersona")]
            public IActionResult AgregarPersona(PersonaDto entidad)
            {
                var result = _PersonaService.AgregarPersona(entidad);
                return Ok(result);
            }

            [HttpPut("EditarPersona")]
            public IActionResult EditarPersona(PersonaDto entidad)
            {
                var result = _PersonaService.EditarPersona(entidad);
                return Ok(result);
            }

            [HttpPut("DesactivarPersona")]
            public IActionResult DesactivarPersona(int PersonaId)
            {
                var result = _PersonaService.DesactivarPersona(PersonaId);
                return Ok(result);
            }
    }
}
