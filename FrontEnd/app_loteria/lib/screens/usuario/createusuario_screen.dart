import 'dart:convert';
import 'package:app_loteria/models/Persona.dart';
import 'package:app_loteria/models/Sucursal.dart';
import 'package:app_loteria/models/Usuario.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/api.dart';

class NewUserForm extends StatefulWidget {
  @override
  _NewUserFormState createState() => _NewUserFormState();
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

class _NewUserFormState extends State<NewUserForm> {
  final _formKey = GlobalKey<FormState>();
  late Usuario _userProfile;
  List<Persona> personas = [];
  List<Sucursal> sucursales = [];

  final TextEditingController _nombreUsuarioController =
      TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  Persona? _selectedPersona;
  Sucursal? _selectedSucursal;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPersonList();
    _fetchSucursalList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: 'Registro de Usuario',
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
                        'images/AgregarUsuario.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nombreUsuarioController,
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
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una contraseña';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Persona>(
                  value: _selectedPersona,
                  items: [
                    DropdownMenuItem<Persona>(
                      value: null,
                      child: Text('Seleccione'),
                    ),
                    ...personas.map((persona) {
                      return DropdownMenuItem<Persona>(
                        value: persona,
                        child: Text(persona.nombres),
                      );
                    }).toList(),
                  ],
                  onChanged: (Persona? value) {
                    setState(() {
                      _selectedPersona = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Persona'),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecciona una persona';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Sucursal>(
                  value: _selectedSucursal,
                  items: [
                    DropdownMenuItem<Sucursal>(
                      value: null,
                      child: Text('Seleccione'),
                    ),
                    ...sucursales.map((sucursal) {
                      return DropdownMenuItem<Sucursal>(
                        value: sucursal,
                        child: Text(sucursal.nombre),
                      );
                    }).toList(),
                  ],
                  onChanged: (Sucursal? value) {
                    setState(() {
                      _selectedSucursal = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Sucursal'),
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Por favor, selecciona una sucursal';
                  //   }
                  //   return null;
                  // },
                ),
                // Campo de selección para Admin
                DropdownButtonFormField<bool>(
                  value: _isAdmin,
                  items: [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: const Text('Sí'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: const Text('No'),
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
                      _NuevoUsuario();
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
                    'Guardar',
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

  void _NuevoUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Usuario userData = Usuario(
      usuarioId: 0,
      nombreUsuario: _nombreUsuarioController.text,
      contrasena: _contrasenaController.text,
      personaId: _selectedPersona!.personaId,
      sucursalId: _selectedSucursal?.sucursalId ?? 0,
      usuarioCreacion: prefs.getInt('usuarioId') ?? 0,
      admin: _isAdmin,
      imagen: '',
      fechaCreacion: DateTime.now(),
    );

    String userJson = jsonEncode(userData);

    try {
      final response = await http.post(
        Uri.parse('${apiUrl}Usuario/AgregarUsuarios'),
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
            .contains("El usuario se ha agregado exitosamente")) {
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
