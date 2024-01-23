namespace LoteriaApp.WebApi.Services.Usuarios.UsuarioDto
{
    public class UsuarioDtoC
    {
        public string NombreUsuario { get; set; } = null!;

        public string? Contrasena { get; set; }

        public int PersonaId { get; set; }
        public int? SucursalId { get; set; }

        public int UsuarioCreacion { get; set; }
        public bool? Admin { get; set; }
    }
}
