namespace Numerito.API.Services.Numeros.NumeroDto
{
    public class NumeroDtos
    {
        public int NumeroId { get; set; }

        public string? NumeroDescripcion { get; set; }

        public int? Limite { get; set; }

        public int UsuarioCreacion { get; set; }

        public DateTime FechaCreacion { get; set; }

        public int? UsuarioModificacion { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public bool? Estado { get; set; }
    }
}
