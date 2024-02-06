// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app_loteria/models/Persona.dart';
import 'package:app_loteria/models/Sucursal.dart';
import 'package:app_loteria/models/Usuario.dart';
import 'package:app_loteria/screens/usuario/listusuario_screen.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/api.dart';
import 'package:collection/collection.dart';

class EditUserForm extends StatefulWidget {
  final Usuarios usuario;

  EditUserForm({required this.usuario});

  @override
  _EditUserFormState createState() => _EditUserFormState();
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
      personaId: prefs.getInt('personaId') ?? 0,
      sucursalId: prefs.getInt('sucursalId') ?? 0,
      usuarioCreacion: 0,
      admin: prefs.getInt('admin') == 1,
    );
  }
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  late Usuario _userProfile;
  List<Persona> personas = [];
  List<Sucursal> sucursales = [];

  final TextEditingController _nombreUsuarioController =
      TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool _isAdmin = false;
  int? _selectedPersona;
  int? _selectedSucursal;

  @override
  void initState() {
    super.initState();
    _fetchPersonList();
    _fetchSucursalList();
    _loadUserData();
    _initializeControllers();
  }

  DateTime? parseDateTime(String? dateString) {
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  void _fetchPersonList() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}Persona/Listado'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          personas = data.map((item) {
            item['fechaCreacion'] = parseDateTime(item['fechaCreacion']);
            item['fechaModificacion'] =
                parseDateTime(item['fechaModificacion']);

            return Persona.fromJson(item);
          }).toList();
        });
      } else {}
    } catch (e) {}
  }

  void _fetchSucursalList() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}Sucursal/Listado'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          sucursales = data.map((item) {
            return Sucursal.fromJson(item);
          }).toList();
        });
      } else {}
    } catch (e) {}
  }

  void _loadUserData() async {
    Usuario userProfile = await UserDataProvider.getUserData();
    setState(() {
      _userProfile = userProfile;
    });
  }

  void _initializeControllers() {
    Usuarios usuario = widget.usuario;

    _nombreUsuarioController.text = usuario.nombreUsuario;
    _contrasenaController.text = '';
    _isAdmin = usuario.admin;
    _selectedPersona = usuario.personaId;
    _selectedSucursal = usuario.sucursalId ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: 'Editar Usuario',
        profileImageUrl: _userProfile.imagen,
        onProfilePressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      width: 170.0,
                      height: 170.0,
                      child: Image.asset(
                        'images/EditarUsuario.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nombreUsuarioController,
                  readOnly: true,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de Usuario'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa el nombre de usuario';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contrasenaController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) {
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _selectedPersona,
                  items: [
                    const DropdownMenuItem<int>(
                      value: 0,
                      child: Text('Seleccione'),
                    ),
                    ...personas.map((persona) {
                      return DropdownMenuItem<int>(
                        value: persona.personaId,
                        child: Text(persona.nombres),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPersona = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Persona'),
                  validator: (value) {
                    if (value == 0) {
                      return 'Por favor, selecciona una persona';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _selectedSucursal,
                  items: [
                    const DropdownMenuItem<int>(
                      value: 0,
                      child: Text('Seleccione'),
                    ),
                    ...sucursales.map((sucursal) {
                      return DropdownMenuItem<int>(
                        value: sucursal.sucursalId,
                        child: Text(sucursal.nombre),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSucursal = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Sucursal'),
                  validator: (value) {
                    if (value == 0) {
                      return 'Por favor, selecciona una sucursal';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
                  value: _isAdmin,
                  items: [
                    const DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Sí'),
                    ),
                    const DropdownMenuItem<bool>(
                      value: false,
                      child: Text('No'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _isAdmin = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Admin'),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecciona una opción para Admin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _EditarUsuario();
                    }
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
                    'Guardar Cambios',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _EditarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Usuarios userData = Usuarios(
      usuarioId: widget.usuario.usuarioId,
      nombreUsuario: _nombreUsuarioController.text,
      contrasena: _contrasenaController.text,
      personaId: _selectedPersona ?? 0,
      sucursalId: _selectedSucursal ?? 0,
      usuarioCreacion: prefs.getInt('usuarioId') ?? 0,
      fechaCreacion: DateTime.now(),
      usuarioModificacion: prefs.getInt('usuarioId') ?? 0,
      admin: _isAdmin,
      fechaModificacion: DateTime.now(),
    );

    String userJson = jsonEncode(userData.toJson());

    try {
      final response = await http.put(
        Uri.parse('${apiUrl}Usuario/EditarUsuarios'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: userJson,
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final respuesta = decodedJson["message"];
        if (respuesta
            .toString()
            .contains("El usuario se ha editado exitosamente")) {
          CherryToast.success(
            title: Text('$respuesta',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        } else if (respuesta
            .toString()
            .contains("Hay campos vacios o la entidad es invalida")) {
          CherryToast.warning(
            title: Text('$respuesta',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        } else if (respuesta
            .toString()
            .contains("El Usuario seleccionado no existe")) {
          CherryToast.warning(
            title: Text('$respuesta',
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
