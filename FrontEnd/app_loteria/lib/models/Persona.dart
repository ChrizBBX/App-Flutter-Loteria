class Persona {
  late final int personaId;
  final String nombres;
  final String? apellidos;
  final String? identidad;
  final String? telefono;
  final String? correoElectronico;
  final String? direccion;
  int? usuarioCreacion;
  final DateTime fechaCreacion;
  final int? usuarioModificacion;
  final DateTime? fechaModificacion;
  final bool? estado;

  Persona({
    required this.personaId,
    required this.nombres,
    this.apellidos,
    this.identidad,
    this.telefono,
    this.correoElectronico,
    this.direccion,
    this.usuarioCreacion,
    required this.fechaCreacion,
    this.usuarioModificacion,
    this.fechaModificacion,
    this.estado,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      personaId: json['personaId'] as int,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String?,
      identidad: json['identidad'] as String?,
      telefono: json['telefono'] as String?,
      correoElectronico: json['correoElectronico'] as String?,
      direccion: json['direccion'] as String?,
      usuarioCreacion: json['usuarioCreacion'] as int,
      fechaCreacion: json['fechaCreacion'] as DateTime,
      usuarioModificacion: json['usuarioModificacion'] as int?,
      fechaModificacion: json['fechaModificacion'] as DateTime?,
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "personaId": personaId,
      "nombres": nombres,
      "apellidos": apellidos,
      "identidad": identidad,
      "telefono": telefono,
      "correoElectronico": correoElectronico,
      "direccion": direccion,
      "UsuarioCreacion": usuarioCreacion,
      "FechaCreacion": fechaCreacion.toIso8601String(),
      "UsuarioModificacion": usuarioModificacion,
      "FechaModificacion": fechaModificacion?.toIso8601String() ?? null,
      "Estado": estado,
    };
  }
}
