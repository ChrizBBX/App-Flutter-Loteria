// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:app_loteria/models/Cierre.dart';
import 'package:app_loteria/models/Usuario.dart';
import 'package:app_loteria/screens/cierre/pdfsorteo_screen.dart';
import 'package:app_loteria/screens/sale_screen/factura_screen.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VentaDetalle {
  int ventaDetalleId;
  int numeroId;
  String numeroDescripcion;
  int valor;

  VentaDetalle({
    required this.ventaDetalleId,
    required this.numeroId,
    required this.numeroDescripcion,
    required this.valor,
  });

  factory VentaDetalle.fromJson(Map<String, dynamic> json) {
    return VentaDetalle(
      ventaDetalleId: json["ventaDetalleId"],
      numeroId: json["numeroId"],
      numeroDescripcion: json["numeroDescripcion"],
      valor: json["valor"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ventaDetalleId": ventaDetalleId,
      "numeroId": numeroId,
      "numeroDescripcion": numeroDescripcion,
      "valor": valor,
    };
  }
}

class VentaEncabezado {
  int ventaId;
  DateTime fechaCreacion;
  String nombres;
  String? apellidos;
  String? identidad;
  String metodoPagoDescripcion;
  List<VentaDetalle> detalles;
  String? descripcionNumero;
  int idNumero;
  int cantidad;

  VentaEncabezado({
    required this.ventaId,
    required this.fechaCreacion,
    required this.nombres,
    required this.apellidos,
    required this.identidad,
    required this.metodoPagoDescripcion,
    required this.detalles,
    required this.descripcionNumero,
    required this.idNumero,
    required this.cantidad,
  });

  factory VentaEncabezado.fromJson(Map<String, dynamic> json) {
    return VentaEncabezado(
      ventaId: json["ventaId"],
      fechaCreacion: json["fechaCreacion"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      identidad: json["identidad"],
      metodoPagoDescripcion: json["metodoPagoDescripcion"],
      detalles: (json["detalles"] as List<dynamic>)
          .map((detalle) => VentaDetalle.fromJson(detalle))
          .toList(),
      descripcionNumero: json["descripcionNumero"],
      idNumero: json["idNumero"],
      cantidad: json["cantidad"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ventaId": ventaId,
      "fechaCreacion": fechaCreacion,
      "nombres": nombres,
      "apellidos": apellidos,
      "identidad": identidad,
      "metodoPagoDescripcion": metodoPagoDescripcion,
      "detalles": detalles.map((detalle) => detalle.toJson()).toList(),
      "descripcionNumero": descripcionNumero,
      "idNumero": idNumero,
      "cantidad": cantidad,
    };
  }
}

class Usuarios {
  final int usuarioId;
  final String nombreUsuario;
  final String? contrasena;
  final int personaId;
  final int? sucursalId;
  final int? usuarioCreacion;
  final DateTime fechaCreacion;
  final int? usuarioModificacion;
  final DateTime? fechaModificacion;
  final bool? estado;
  final bool admin;

  Usuarios({
    required this.usuarioId,
    required this.nombreUsuario,
    required this.contrasena,
    required this.personaId,
    this.sucursalId,
    this.usuarioCreacion,
    required this.fechaCreacion,
    this.usuarioModificacion,
    this.fechaModificacion,
    this.estado,
    required this.admin,
  });

  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      usuarioId: json['usuarioId'] as int,
      nombreUsuario: json['nombreUsuario'] as String,
      contrasena: json['contrasena'] as String?,
      personaId: json['personaId'] as int,
      sucursalId: json['sucursalId'] as int?,
      usuarioCreacion: json['usuarioCreacion'] as int?,
      fechaCreacion: json['fechaCreacion'] as DateTime,
      usuarioModificacion: json['usuarioModificacion'] as int?,
      fechaModificacion: json['fechaModificacion'] != null
          ? json['fechaModificacion'] as DateTime
          : null,
      estado: json['estado'] as bool?,
      admin: json['admin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usuarioId": usuarioId,
      "nombreUsuario": nombreUsuario,
      "contrasena": contrasena,
      "personaId": personaId,
      "sucursalId": sucursalId,
      "usuarioCreacion": usuarioCreacion,
      "admin": admin,
      "UsuarioCreacion": usuarioCreacion,
      "FechaCreacion": fechaCreacion.toIso8601String(),
      "UsuarioModificacion": usuarioModificacion,
      "FechaModificacion": fechaModificacion?.toIso8601String(),
      "Estado": estado,
    };
  }
}

class FacturaxCierreScreen extends StatefulWidget {
  final DateTime fechajornada;
  final int id;

  const FacturaxCierreScreen({
    Key? key,
    required this.id,
    required this.fechajornada,
  }) : super(key: key);
  @override
  _FacturaxCierreScreenState createState() => _FacturaxCierreScreenState();
}

class UserDataProvider {
  static Future<Usuario> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Usuario(
      usuarioId: prefs.getInt('usuarioId') ?? 0,
      nombreUsuario: prefs.getString('nombreUsuario') ?? '',
      contrasena: '',
      imagen: prefs.getString('imagen') ?? '',
      fechaCreacion: DateTime.now(),
      personaId: prefs.getInt('personaId'),
      sucursalId: prefs.getInt('sucursalId') ?? 0,
      usuarioCreacion: 0,
      admin: prefs.getInt('admin') == 1,
    );
  }
}

class _FacturaxCierreScreenState extends State<FacturaxCierreScreen> {
  List<VentaEncabezado> facturas = [];
  List<VentaEncabezado> filteredfacturas = [];
  late Usuario _userProfile;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCierreList();
    _loadUserData();
  }

  Future<void> _fetchCierreList() async {
    try {
      int id = widget.id;
      String formattedfechajornada =
          DateFormat('yyyy-MM-dd').format(widget.fechajornada);
      final response = await http.get(Uri.parse(
          '${apiUrl}Cierre/FacturasxJornada?id=$id&fechajornada=$formattedfechajornada'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          facturas = data.map((item) {
            item['fechaCreacion'] = DateTime.parse(item['fechaCreacion']);
            return VentaEncabezado.fromJson(item);
          }).toList();
          filteredfacturas = List.from(facturas);
        });
      } else {}
    } catch (e) {}
  }

  @override
  void _loadUserData() async {
    Usuario userProfile = await UserDataProvider.getUserData();
    setState(() {
      _userProfile = userProfile;
    });
  }

  void _filterFacturas(String query) {
    setState(() {
      filteredfacturas = facturas.where((factura) {
        String formattedDate = DateFormat('d/M/y')
            .format(factura.fechaCreacion as DateTime)
            .toLowerCase();
        String lowercaseQuery = query.toLowerCase();
        return formattedDate.contains(lowercaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: 'Listado de Facturas',
        profileImageUrl: _userProfile.imagen,
        onProfilePressed: () {},
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (PDFSorteo(
                          id: widget.id,
                          fechajornada: widget.fechajornada,
                        ))),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorPalette.darkblueColorApp,
              minimumSize: const Size(365.0, 45.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'PDF Facturas del Sorteo',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterFacturas,
              decoration: InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredfacturas.length,
              itemBuilder: (context, index) {
                final factura = filteredfacturas[index];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Factura #: ${factura.ventaId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Fecha de Venta: ${DateFormat('d/M/y').format(factura.fechaCreacion)}'),
                        Text('Identidad: ${factura.identidad ?? 'N/A'}'),
                        Text(
                            'Cliente: ${factura.nombres} ${factura.apellidos ?? ''}'),
                        Text(
                            'Método de Pago: ${factura.metodoPagoDescripcion}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            color: ColorPalette.darkblueColorApp,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (FacturaPDF(
                                        ID: factura.ventaId.toString()))),
                              );
                            },
                            icon: const Icon(Icons.print,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
