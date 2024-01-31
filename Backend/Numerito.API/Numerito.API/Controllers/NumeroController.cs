using Microsoft.AspNetCore.Mvc;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Numeros;
using Numerito.API.Services.Numeros.NumeroDto;

namespace Numerito.API.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class NumeroController : ControllerBase
    {
        private readonly NumeroService _NumeroService;

        public NumeroController(NumeroService NumeroService)
        {
            _NumeroService = NumeroService;
        }


        [HttpGet("Listado")]
        public IActionResult Listado()
        {
            var result = _NumeroService.Listado();
            return Ok(result);
        }

        [HttpPut("EditarLimite")]
        public IActionResult EditarLimite(NumeroDtos entidad)
        {
            var result = _NumeroService.EditarLimite(entidad);
            return Ok(result);
        }
    }
}
