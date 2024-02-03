class Usuario {
  int? usuarioId;
  String nombreUsuario;
  String contrasena;
  String imagen;
  int? personaId;
  int sucursalId;
  bool admin;
  int? usuarioCreacion;
  final DateTime fechaCreacion;
  final int? usuarioModificacion;
  final DateTime? fechaModificacion;
  final bool? estado;

  Usuario({
    this.usuarioId,
    required this.nombreUsuario,
    required this.contrasena,
    required this.imagen,
    this.personaId,
    required this.sucursalId,
    this.admin = false,
    this.usuarioCreacion,
    required this.fechaCreacion,
    this.usuarioModificacion,
    this.fechaModificacion,
    this.estado,
  });


factory Usuario.fromJson(Map<String, dynamic> json) {
  return Usuario(
    usuarioId: json['usuarioId'],
    nombreUsuario: json['nombreUsuario'],
    contrasena: json['contrasena'],
    imagen: json['imagen'],
    personaId: json['personaId'],
    sucursalId: json['sucursalId'],
    admin: json['admin'] ?? false,
    usuarioCreacion: json['usuarioCreacion'],
    fechaCreacion: DateTime.parse(json['fechaCreacion']),
    usuarioModificacion: json['usuarioModificacion'],
    fechaModificacion: json['fechaModificacion'] != null
        ? DateTime.parse(json['fechaModificacion'])
        : null,
    estado: json['estado'],
  );
}

  Map<String, dynamic> toJson() {
    return {
      "usuarioId": usuarioId,
      "nombreUsuario": nombreUsuario,
      "contrasena": contrasena,
      "imagen": imagen,
      "personaId": personaId,
      "sucursalId": sucursalId,
      "usuarioCreacion": usuarioCreacion,
      "admin": admin,
      "UsuarioCreacion": usuarioCreacion,
      "FechaCreacion": fechaCreacion.toIso8601String(),
      "UsuarioModificacion": usuarioModificacion,
      "FechaModificacion": fechaModificacion?.toIso8601String() ?? null,
      "Estado": estado,
    };
  }
}
