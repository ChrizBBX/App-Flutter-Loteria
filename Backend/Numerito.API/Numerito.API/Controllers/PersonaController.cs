using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Numerito.API.Services.Personas;

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
    }
}
