import 'dart:convert';

import 'package:app_loteria/models/Persona.dart';
import 'package:app_loteria/models/Usuario.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';
import 'package:app_loteria/utils/colorPalette.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/api.dart';

class EditPersonForm extends StatefulWidget {
  final Persona persona;

  EditPersonForm({required this.persona});

  @override
  _EditPersonFormState createState() => _EditPersonFormState();
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

class _EditPersonFormState extends State<EditPersonForm> {
  final _formKey = GlobalKey<FormState>();
  late Usuario _userProfile;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _identidadController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeControllers();
  }

  void _loadUserData() async {
    Usuario userProfile = await UserDataProvider.getUserData();
    setState(() {
      _userProfile = userProfile;
    });
  }

  void _initializeControllers() {
    Persona persona = widget.persona;

    _idController.text = persona.personaId.toString();
    _nombresController.text = persona.nombres;
    _apellidosController.text = persona.apellidos ?? '';
    _identidadController.text = persona.identidad ?? '';
    _telefonoController.text = persona.telefono ?? '';
    _correoController.text = persona.correoElectronico ?? '';
    _direccionController.text = persona.direccion ?? '';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        title: 'Editar Persona',
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
                        'images/EditarPersona.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nombresController,
                  decoration: const InputDecoration(labelText: 'Nombres'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa los nombres';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                ),
                TextFormField(
                  controller: _identidadController,
                  decoration: const InputDecoration(labelText: 'Identidad'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa la identidad';
                    } else if (value.length != 13) {
                      return 'La identidad debe tener 13 números';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa el teléfono';
                    } else if (value.length != 8) {
                      return 'El teléfono debe tener 8 números';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _correoController,
                  decoration:
                      const InputDecoration(labelText: 'Correo Electrónico'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _EditarPersona();
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

  void _EditarPersona() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Persona personaData = Persona(
      personaId: int.parse(_idController.text),
      nombres: _nombresController.text,
      apellidos: _apellidosController.text,
      identidad: _identidadController.text,
      telefono: _telefonoController.text,
      correoElectronico: _correoController.text,
      direccion: _direccionController.text,
      usuarioCreacion: prefs.getInt('usuarioId'),
      fechaCreacion: DateTime.now(),
      usuarioModificacion: prefs.getInt('usuarioId') ?? 0,
      fechaModificacion: DateTime.now(),
      estado: null,
    );

    String personaJson = jsonEncode(personaData);

    try {
      final response = await http.put(
        Uri.parse('${apiUrl}Persona/EditarPersona'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: personaJson,
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final respuesta = decodedJson["message"];
        if (respuesta
            .toString()
            .contains("La Persona se ha editado exitosamente")) {
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
            .contains("Ya existe una persona con este número de identidad")) {
          CherryToast.warning(
            title: Text('$respuesta',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.start),
            borderRadius: 5,
          ).show(context);
        } else if (respuesta
            .toString()
            .contains("La persona seleccionada no existe")) {
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
