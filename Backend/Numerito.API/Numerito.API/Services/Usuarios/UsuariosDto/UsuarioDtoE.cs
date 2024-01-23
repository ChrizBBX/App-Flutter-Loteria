namespace Numerito.API.Services.Usuarios.UsuariosDto
{
    public class UsuarioDtoE
    {
        public int UsuarioId { get; set; }
        public string NombreUsuario { get; set; } = null!;

        public string? Contrasena { get; set; }

        public int PersonaId { get; set; }
        public int? SucursalId { get; set; }
        public DateTime? FechaModificacion { get; set; }

        public int? UsuarioModificacion { get; set; }
        public bool? Admin { get; set; }
    }
}
