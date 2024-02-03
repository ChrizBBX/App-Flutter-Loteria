using Microsoft.AspNetCore.Mvc;
using Numerito.API.Services.Numeros;
using Numerito.API.Services.Reportes;

namespace Numerito.API.Controllers
{
        [Route("api/[controller]")]
        [ApiController]
    public class ReporteController : ControllerBase
    {

        private readonly ReportesService _reportesService ;

        public ReporteController(ReportesService reportesService)
        {
            _reportesService = reportesService;
        }


        [HttpGet("Inventario")]
        public IActionResult Inventario()
        {
            var result = _reportesService.ReporteInventario();
            return Ok(result);
        }

        [HttpGet("NumerosVendidos")]
        public IActionResult NumerosVendidos(DateTime fecha_inicio, DateTime fecha_fin)
        {
            var result = _reportesService.NumerosVendidos(fecha_inicio, fecha_fin);
            return Ok(result);
        }
    }
}
