using System;
using System.Collections.Generic;

namespace LoteriaApp.WebApi.Data.Entities;

public partial class Numero
{
    public int NumeroId { get; set; }

    public int Numero1 { get; set; }

    public string? NumeroDescripcion { get; set; }

    public int? Limite { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }
}
