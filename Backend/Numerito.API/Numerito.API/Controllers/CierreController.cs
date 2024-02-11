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

        [HttpGet("Listado")]
        public IActionResult Listado(int id)
        {
            var result = _service.Listado(id);
            return Ok(result);
        }

        [HttpGet("CantidadNumCierre")]
        public IActionResult CantidadNumCierre(DateTime fecha, int idusuario, int id)
        {
            var result = _service.CantidadNumCierre(fecha, idusuario, id);
            return Ok(result);
        }

        [HttpGet("FacturasxJornada")]
        public IActionResult FacturasxJornada(int id, DateTime fechajornada)
        {
            var result = _service.FacturasxJornada(id, fechajornada);
            return Ok(result);
        }

        [HttpPost("AgregarCierre")]
        public IActionResult AgregarCierre(CierreDto entidad)
        {
            var result = _service.AgregarCierre(entidad);
            return Ok(result);
        }

        [HttpDelete("EliminarCierre")]
        public IActionResult EliminarCierre(int id)
        {
            var result = _service.EliminarCierre(id);
            return Ok(result);
        }

    }
}
