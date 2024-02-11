namespace Numerito.API.Data.Entities;

public partial class Sucursal
{
    public int SucursalId { get; set; }

    public int? MunicipioId { get; set; }

    public string? Nombre { get; set; }

    public string? Direccion { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual Municipio? Municipio { get; set; }

    public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();
}
