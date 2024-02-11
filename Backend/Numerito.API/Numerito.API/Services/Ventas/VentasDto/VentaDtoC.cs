namespace Numerito.API.Services.Ventas.VentasDto
{
    public class VentaDtoC
    {
        public int PersonaId { get; set; }

        public int UsuarioId { get; set; }

        public int MetodoPagoId { get; set; }

        public DateTime FechaVenta { get; set; }

        public int UsuarioCreacion { get; set; }

        public List<VentaDetalleDtoC> VentaDetalles { get; set; }
    }
}
