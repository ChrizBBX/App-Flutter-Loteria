using System;
using System.Collections.Generic;

namespace Numerito.API.Data.Entities;

public partial class Municipio
{
    public int MunicipioId { get; set; }

    public string? MunicipioDescripcion { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }
}
