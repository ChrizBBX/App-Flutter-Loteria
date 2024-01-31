namespace LoteriaApp.WebApi.Services.Usuarios.UsuarioDto
{
    public class UsuarioDto
    {
        public int UsuarioId { get; set; }

        public string NombreUsuario { get; set; } = null!;

       // public string ImagenUrl { get; set; }


        public string? Contrasena { get; set; }

        public int PersonaId { get; set; }

        public int? SucursalId { get; set; }

        public int UsuarioCreacion { get; set; }

        public DateTime FechaCreacion { get; set; }

        public int? UsuarioModificacion { get; set; }

        public DateTime? FechaModificacion { get; set; }

        public bool? Estado { get; set; }

        public bool? Admin { get; set; }
    }
}
