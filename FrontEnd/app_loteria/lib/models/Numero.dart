// ignore_for_file: file_names

class Numero {
  final int numeroId;
  final String? numeroDescripcion;
  final int? limite;
  final int usuarioCreacion;
  final DateTime fechaCreacion;
  final int? usuarioModificacion;
  final DateTime? fechaModificacion;
  final bool? estado;

  Numero({
    required this.numeroId,
    this.numeroDescripcion,
    this.limite,
    required this.usuarioCreacion,
    required this.fechaCreacion,
    this.usuarioModificacion,
    this.fechaModificacion,
    this.estado,
  });

  factory Numero.fromJson(Map<String, dynamic> json) {
    return Numero(
      numeroId: json['NumeroId'] as int,
      numeroDescripcion: json['NumeroDescripcion'] as String?,
      limite: json['Limite'] as int?,
      usuarioCreacion: json['UsuarioCreacion'] as int,
      fechaCreacion: DateTime.parse(json['FechaCreacion'] as String),
      usuarioModificacion: json['UsuarioModificacion'] as int?,
      fechaModificacion: json['FechaModificacion'] != null
          ? DateTime.parse(json['FechaModificacion'] as String)
          : null,
      estado: json['Estado'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "NumeroId": numeroId,
      "NumeroDescripcion": numeroDescripcion,
      "Limite": limite,
      "UsuarioCreacion": usuarioCreacion,
      "FechaCreacion": fechaCreacion.toIso8601String(),
      "UsuarioModificacion": usuarioModificacion,
      "FechaModificacion": fechaModificacion?.toIso8601String() ?? null,
      "Estado": estado,
    };
  }
}
