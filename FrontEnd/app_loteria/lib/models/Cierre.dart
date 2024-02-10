// ignore_for_file: file_names

class Cierre {
  final int cierreId;
  final int numeroId;
  final int usuarioId;
  final DateTime fechaCierre;
  final int numeroRegistro;


  Cierre({
    required this.cierreId,
    required this.numeroId,
    required this.usuarioId,
    required this.fechaCierre,
    required this.numeroRegistro
 
  });

  factory Cierre.fromJson(Map<String, dynamic> json) {
    return Cierre(
      cierreId: json['cierreId'] as int,
      numeroId: json['numeroId'] as int,
      usuarioId: json['usuarioId'] as int,
      fechaCierre: json['fechaCierre'] as DateTime,
      numeroRegistro: json['numeroRegistro'],
    );
  }

 Map<String, dynamic> toJson() {
    return {
      "cierreId": cierreId,
      "usuarioId": usuarioId,
      "numeroId": numeroId,
      "fechaCierre": fechaCierre.toIso8601String(),
      "numeroRegistro" : numeroRegistro,
    };
  }
}
