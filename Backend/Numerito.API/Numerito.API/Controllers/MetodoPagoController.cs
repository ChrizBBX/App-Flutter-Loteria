using Microsoft.AspNetCore.Mvc;
using Numerito.API.Services.MetodosPagos;
using Microsoft.AspNetCore.Http;

namespace Numerito.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MetodoPagoController : ControllerBase
    {
        private readonly MetodoPagoService _MetodoPagoService;

        public MetodoPagoController(MetodoPagoService MetodoPagoService)
        {
            _MetodoPagoService = MetodoPagoService;
        }


        [HttpGet("Listado")]
        public IActionResult Listado()
        {
            var result = _MetodoPagoService.Listado();
            return Ok(result);
        }
    }
}
