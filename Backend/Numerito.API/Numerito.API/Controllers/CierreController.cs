using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Numerito.API.Services.Cierres;
using Numerito.API.Services.Cierres.CierreDtos;

namespace Numerito.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CierreController : ControllerBase
    {
        private readonly CierreService _service;

        public CierreController(CierreService service)
        {
            _service = service;
        }

        [HttpPost("AgregarCierre")]
        public IActionResult AgregarCierre(CierreDto entidad)
        {
            var result = _service.AgregarCierre(entidad);
            return Ok(result);
        }

    }
}
