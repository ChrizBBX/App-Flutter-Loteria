// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:app_loteria/models/Usuario.dart';
import 'package:app_loteria/screens/usuario/createusuario_screen.dart';
import 'package:app_loteria/screens/usuario/editusuario_screen.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/api.dart';
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
      "FechaModificacion": fechaModificacion?.toIso8601String() ?? null,
      "Estado": estado,
    };
  }
}

class ListUsuarioScreen extends StatefulWidget {
  @override
  _ListUsuarioScreenState createState() => _ListUsuarioScreenState();
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

class _ListUsuarioScreenState extends State<ListUsuarioScreen> {
  List<Usuarios> usuarios = [];
  List<Usuarios> filteredUsuarios = [];
  late Usuario _userProfile;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserList();
    _loadUserData();
  }

  Future<void> _fetchUserList() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}Usuario/Listado'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          usuarios = data.map((item) {
            // Convertir las fechas de String a DateTime
            item['fechaCreacion'] = DateTime.parse(item['fechaCreacion']);
            item['fechaModificacion'] = item['fechaModificacion'] != null
                ? DateTime.parse(item['fechaModificacion'])
                : null;

            return Usuarios.fromJson(item);
          }).toList();
          filteredUsuarios = List.from(usuarios);
        });
      } else {
        // Manejar el error de la solicitud HTTP
        print('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores de red u otros
      print('Error: $e');
    }
  }

  @override
  void _loadUserData() async {
    Usuario userProfile = await UserDataProvider.getUserData();
    setState(() {
      _userProfile = userProfile;
    });
  }

  void _filterUsuarios(String query) {
    setState(() {
      filteredUsuarios = usuarios
          .where((usuario) =>
              usuario.nombreUsuario
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (usuario.personaId.toString().contains(query)) ||
              (usuario.sucursalId.toString().contains(query)))
          .toList();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: 'Listado de Usuarios',
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
                MaterialPageRoute(builder: (context) => NewUserForm()),
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
              onChanged: _filterUsuarios,
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
              itemCount: filteredUsuarios.length,
              itemBuilder: (context, index) {
                final usuario = filteredUsuarios[index];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Nombre de Usuario: ${usuario.nombreUsuario}'),
                    subtitle: Text('ID de Persona: ${usuario.personaId}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón de Editar con fondo amarillo
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Navegar a la pantalla de edición de usuario
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditUserForm(usuario: usuario),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        // Botón de Eliminar con fondo rojo
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: IconButton(
                            onPressed: () => _showDeleteConfirmationDialog(
                                usuario.usuarioId.toString()),
                            icon: const Icon(Icons.delete),
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

  void _showDeleteConfirmationDialog(String? usuarioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Usuario'),
          content:
              const Text('¿Estás seguro de que quieres eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (usuarioId != null) {
                  _deleteUsuario(int.parse(usuarioId));
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

  void _deleteUsuario(int usuarioId) async {
    try {
      final response =
          await http.put(Uri.parse('${apiUrl}Usuario/DesactivarUsuarios?usuarioId=$usuarioId'));

      if (response.statusCode == 200) {
        _fetchUserList();
        CherryToast.success(title: const Text('Usuario eliminado exitosamente'))
            .show(context);
      } else {
        print(
            'Error en la solicitud HTTP para eliminar usuario: ${response.statusCode}');
        CherryToast.warning(
                title: const Text('Error al intentar eliminar el usuario'))
            .show(context);
      }
    } catch (e) {
      print('Error: $e');
      CherryToast.warning(
              title: const Text('Error al intentar eliminar el usuario'))
          .show(context);
    }
  }
}
