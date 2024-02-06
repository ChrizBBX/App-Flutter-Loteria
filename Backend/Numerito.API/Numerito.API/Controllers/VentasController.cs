using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Numerito.API.Services.Ventas;
using Numerito.API.Services.Ventas.VentasDto;

namespace Numerito.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VentasController : ControllerBase
    {
        private readonly VentaService _ventaService;

        public VentasController(VentaService ventaService)
        {
            _ventaService = ventaService;
        }


        [HttpPost("AgregarVenta")]
        public IActionResult AgregarVenta(VentaDtoC entidad) 
        {
            var result = _ventaService.AgregarVenta(entidad);
            return Ok(result);
        }

        [HttpGet("GenerarFactura")]
        public IActionResult GenerarFactura(int? ID)
        {
            var result = _ventaService.GenerarFactura(ID);
            return Ok(result);
        }
    }
}
