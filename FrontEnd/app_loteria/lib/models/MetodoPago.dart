// ignore_for_file: file_names

class MetodoPago {
  final int metodoPagoId;
  final String descripcion;
  final int usuarioCreacion;
  final String fechaCreacion;
  final int? usuarioModificacion;
  final String? fechaModificacion;
  final dynamic estado;

  MetodoPago({
    required this.metodoPagoId,
    required this.descripcion,
    required this.usuarioCreacion,
    required this.fechaCreacion,
    this.usuarioModificacion,
    this.fechaModificacion,
    this.estado,
  });

  factory MetodoPago.fromJson(Map<String, dynamic> json) {
    return MetodoPago(
      metodoPagoId: json['metodoPagoId'] as int,
      descripcion: json['descripcion'] as String,
      usuarioCreacion: json['usuarioCreacion'] as int,
      fechaCreacion: json['fechaCreacion'] as String,
      usuarioModificacion: json['usuarioModificacion'] as int?,
      fechaModificacion: json['fechaModificacion'] as String?,
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "metodoPagoId": metodoPagoId,
      "descripcion": descripcion,
      "usuarioCreacion": usuarioCreacion,
      "fechaCreacion": fechaCreacion,
      "usuarioModificacion": usuarioModificacion,
      "fechaModificacion": fechaModificacion,
      "estado": estado,
    };
  }
}
