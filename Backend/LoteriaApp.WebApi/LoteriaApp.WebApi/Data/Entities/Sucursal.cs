﻿using System;
using System.Collections.Generic;

namespace LoteriaApp.WebApi.Data.Entities;

public partial class Sucursal
{
    public int SucursalId { get; set; }

    public string? SucursalDescripcion { get; set; }

    public int UsuarioCreacion { get; set; }

    public DateTime FechaCreacion { get; set; }

    public int? UsuarioModificacion { get; set; }

    public DateTime? FechaModificacion { get; set; }

    public bool? Estado { get; set; }
}
