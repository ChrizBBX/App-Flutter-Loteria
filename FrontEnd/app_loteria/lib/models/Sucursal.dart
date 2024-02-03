class Sucursal {
  late final int sucursalId;
  final int? municipioId;
  final String nombre;
  final String? direccion;

  Sucursal({
    required this.sucursalId,
    this.municipioId,
    required this.nombre,
    this.direccion,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      sucursalId: json['SucursalId'] as int,
      municipioId: json['MunicipioId'] as int?,
      nombre: json['Nombre'] as String,
      direccion: json['Direccion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "SucursalId": sucursalId,
      "MunicipioId": municipioId,
      "Nombre": nombre,
      "Direccion": direccion,
    };
  }
}
