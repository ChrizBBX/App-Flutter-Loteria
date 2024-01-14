namespace Numerito.API.Services.Ventas.VentasDto
{
    public class VentaDtoC
    {
        public int VentaId { get; set; }

        public string NumeroVenta { get; set; } = null!;

        public int PersonaId { get; set; }

        public int UsuarioId { get; set; }

        public int MetodoPagoId { get; set; }

        public DateTime FechaVenta { get; set; }

        public int UsuarioCreacion { get; set; }

        public DateTime FechaCreacion { get; set; }

        public int? UsuarioModificacion { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public bool? Estado { get; set; }
    }
}
