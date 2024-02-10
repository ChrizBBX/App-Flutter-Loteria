// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:app_loteria/models/Cierre.dart';
import 'package:app_loteria/models/Usuario.dart';
import 'package:app_loteria/screens/cierre/facturasxcierre_screen.dart';
import 'package:app_loteria/screens/cierre/pdfcierre_screen.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/api.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ListCierreScreen extends StatefulWidget {
  const ListCierreScreen({super.key});

  @override
  _ListCierreScreenState createState() => _ListCierreScreenState();
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

class _ListCierreScreenState extends State<ListCierreScreen> {
  List<Cierre> cierres = [];
  List<Cierre> filteredcierres = [];
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt('usuarioId') ?? 0;
      final response =
          await http.get(Uri.parse('${apiUrl}Cierre/Listado?id=$id'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          cierres = data.map((item) {
            item['fechaCierre'] = DateTime.parse(item['fechaCierre']);
            return Cierre.fromJson(item);
          }).toList();
          filteredcierres = List.from(cierres);
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

  void _filterCierres(String query) {
    setState(() {
      filteredcierres = cierres.where((cierre) {
        String formattedDate =
            DateFormat('d/M/y').format(cierre.fechaCierre).toLowerCase();
        String lowercaseQuery = query.toLowerCase();
        return formattedDate.contains(lowercaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: 'Listado de Cierres',
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
              nuevocierreDialog();
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
              'Nuevo',
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
              onChanged: _filterCierres,
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
              itemCount: filteredcierres.length,
              itemBuilder: (context, index) {
                final cierre = filteredcierres[index];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(_getSorteMessage(cierre.numeroRegistro)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Número Ganador: ${cierre.numeroId}'),
                        Text(
                            'Fecha: ${DateFormat('d/M/y').format(cierre.fechaCierre)}'),
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
                                    builder: (context) => FacturaxCierreScreen(
                                          id: cierre.numeroRegistro,
                                          fechajornada: cierre.fechaCierre,
                                        )),
                              );
                            },
                            icon: const Icon(Icons.list_alt,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
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
                                    builder: (context) => ReportePDF_CierreSorteo(
                                          id: cierre.numeroRegistro,
                                          fechajornada: cierre.fechaCierre,
                                        )),
                              );
                            },
                            icon: const Icon(Icons.print,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: IconButton(
                            onPressed: () => _showDeleteConfirmationDialog(
                                cierre.cierreId.toString()),
                            icon: const Icon(Icons.delete,
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

  String _getSorteMessage(int numeroRegistro) {
    switch (numeroRegistro) {
      case 1:
        return 'Sorte 11 AM';
      case 2:
        return 'Sorte 3 PM';
      case 3:
        return 'Sorte 9 PM';
      default:
        return 'Sorte Desconocido';
    }
  }

  void _showDeleteConfirmationDialog(String? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Cierre'),
          content:
              const Text('¿Estás seguro de que quieres eliminar este Cierre?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.darkblueColorApp,
              ),
              onPressed: () {
                if (id != null) {
                  _deleteCierre(int.parse(id));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void nuevocierreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _numController = TextEditingController();

        return AlertDialog(
          title: const Text('Nuevo Cierre'),
          contentPadding: const EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _numController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  counterText: '',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _NuevoCierre(_numController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _NuevoCierre(num) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Cierre userData = Cierre(
      cierreId: 0,
      usuarioId: prefs.getInt('usuarioId') ?? 0,
      numeroId: int.parse(num),
      fechaCierre: DateTime.now(),
      numeroRegistro: 0,
    );

    String userJson = jsonEncode(userData);

    try {
      final response = await http.post(
        Uri.parse('${apiUrl}Cierre/AgregarCierre'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: userJson,
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final respuesta = decodedJson["message"];
        if (respuesta.toString().contains("El cierre")) {
          CherryToast.success(
            title: Text('$respuesta',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
          _fetchCierreList();
        } else if (respuesta.toString().contains("Ya se han realizado")) {
          CherryToast.warning(
            title: Text('$respuesta',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        } else {
          CherryToast.error(
            title: Text('Ha ocurrido un error Inesperado',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        }
      } else {}
    } catch (e) {}
  }

  void _deleteCierre(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('${apiUrl}Cierre/EliminarCierre?id=$id'));

      if (response.statusCode == 200) {
        _fetchCierreList();
        final decodedJson = jsonDecode(response.body);
        final respuesta = decodedJson["message"];
        if (respuesta
            .toString()
            .contains("Se ha eliminado el cierre exitosamente")) {
          CherryToast.success(
            title: Text('$respuesta',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        } else if (respuesta
            .toString()
            .contains("El cierre seleccionado no existe")) {
          CherryToast.warning(
            title: Text('$respuesta',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        } else {
          CherryToast.error(
            title: Text('Ha ocurrido un error Inesperado',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        }
      } else {}
    } catch (e) {}
  }
}
