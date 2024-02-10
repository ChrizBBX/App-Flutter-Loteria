namespace Numerito.API.Services.Cierres.CierreDtos
{
    public class CierreDto
    {
        public int CierreId { get; set; }

        public int NumeroId { get; set; }

        public int UsuarioId { get; set; }

        public DateTime FechaCierre { get; set; }
        public int NumeroRegistro { get; internal set; }
    }
}
