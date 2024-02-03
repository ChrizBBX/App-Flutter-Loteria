using Microsoft.AspNetCore.Mvc;
using Numerito.API.Services.Sucursales;

namespace Numerito.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SucursalController : ControllerBase
    {
        private readonly SucursalService _sucursalService;

        public SucursalController(SucursalService sucursalService)
        {
            _sucursalService = sucursalService;
        }

        [HttpGet("Listado")]
        public IActionResult Listado()
        {
            var result = _sucursalService.Listado();
            return Ok(result);
        }
    }
}
