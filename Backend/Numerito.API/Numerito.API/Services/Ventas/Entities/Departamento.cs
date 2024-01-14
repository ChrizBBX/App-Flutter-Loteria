using System;
using System.Collections.Generic;

namespace Numerito.API.Services.Ventas.Entities;

public partial class Departamento
{
    public int DepartamentoId { get; set; }

    public string DepartamentoDescripcion { get; set; } = null!;

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }
}
