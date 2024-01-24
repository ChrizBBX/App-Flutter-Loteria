
class VentaJsonDetalle {
  int? numeroId;
  int? valor;

  VentaJsonDetalle({
    this.numeroId,
    this.valor,
  });

  Map<String, dynamic> toJson() {
    return {
      "numeroId": numeroId,
      "valor": valor,
    };
  }
}

class VentaJsonEncabezado {
  int? personaId;
  int? usuarioId;
  int? metodoPagoId;
  String fechaVenta;
  int? usuarioCreacion;
  List<VentaJsonDetalle> ventaDetalles;

  VentaJsonEncabezado({
    this.personaId,
    this.usuarioId,
    this.metodoPagoId,
    required this.fechaVenta,
    this.usuarioCreacion,
    required this.ventaDetalles,
  });

  Map<String, dynamic> toJson() {
    return {
      "personaId": personaId,
      "usuarioId": usuarioId,
      "metodoPagoId": metodoPagoId,
      "fechaVenta": fechaVenta,
      "usuarioCreacion": usuarioCreacion,
      "ventaDetalles": ventaDetalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}
