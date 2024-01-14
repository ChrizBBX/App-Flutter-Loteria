using System;
using System.Collections.Generic;

namespace Numerito.API.Data.Entities;

public partial class Persona
{
    public int PersonaId { get; set; }

    public string? Nombres { get; set; }

    public string? Apellidos { get; set; }

    public string? Identidad { get; set; }

    public string? Telefono { get; set; }

    public string? CorreoElectronico { get; set; }

    public string? Direccion { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual ICollection<Usuario> Usuarios { get; set; } = new List<Usuario>();

    public virtual ICollection<Venta> Venta { get; set; } = new List<Venta>();
}
