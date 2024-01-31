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
