using System;
using System.Collections.Generic;

namespace Numerito.API.Data.Entities;

public partial class Municipio
{
    public int MunicipioId { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public int DepartamentoId { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }

    public virtual Departamento Departamento { get; set; } = null!;

    public virtual ICollection<Sucursal> Sucursales { get; set; } = new List<Sucursal>();
}
