// ignore_for_file: file_names

class Cierre {
  final int cierreId;
  final int numeroId;
  final int usuarioId;
  final DateTime fechaCierre;


  Cierre({
    required this.cierreId,
    required this.numeroId,
    required this.usuarioId,
    required this.fechaCierre,
 
  });

  factory Cierre.fromJson(Map<String, dynamic> json) {
    return Cierre(
      cierreId: json['cierreId'] as int,
      numeroId: json['numeroId'] as int,
      usuarioId: json['usuarioId'] as int,
      fechaCierre: json['fechaCierre'] as DateTime,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "metodoPagoId": cierreId,
      "descripcion": numeroId,
      "usuarioId": usuarioId,
      "fechaCierre": fechaCierre,
    };
  }
}
