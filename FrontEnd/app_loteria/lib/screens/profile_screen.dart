// profile_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:app_loteria/models/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import '../toastconfig/toastconfig.dart';
import '../widgets/appbar_roots.dart';
import '../utils/colorPalette.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class UserDataProvider {
  static Future<Usuario> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Usuario(
      usuarioId: prefs.getInt('usuarioId') ?? 0,
      nombreUsuario: prefs.getString('nombreUsuario') ?? '',
      contrasena: '',
      imagen: prefs.getString('imagen') ?? '',
      personaId: prefs.getInt('personaId'),
      fechaCreacion: DateTime.now(),
      sucursalId: prefs.getInt('sucursalId') ?? 0,
      usuarioCreacion: 0,
      admin: prefs.getInt('admin') == 1,
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Usuario _userProfile;
  bool changingPassword = false;
  TextEditingController contraseniaAnteriorController = TextEditingController();
  TextEditingController contraseniaNuevaController = TextEditingController();
  TextEditingController contraseniaConfirmarController =
      TextEditingController();

  bool mostrarContraseniaAnterior = false;
  bool mostrarContraseniaNueva = false;
  bool mostrarContraseniaConfirmar = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
        title: 'Perfil',
        profileImageUrl: _userProfile.imagen,
        onProfilePressed: () {
          if (changingPassword) {
            setState(() {
              changingPassword = false;
            });
          } else {
            Imagen(context);
          }
        },
      ),
      body: changingPassword ? buildChangePasswordUI() : buildUserProfileUI(),
    );
  }

  Widget buildUserProfileUI() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: () {
                    Imagen(context);
                  },
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: NetworkImage(_userProfile.imagen),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorPalette.darkblueColorApp,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      opciones(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 260.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          changingPassword = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: ColorPalette.darkblueColorApp,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.lock_outline,
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Cambiar Contraseña',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Información de Usuario',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.00),
                  buildUserInfoWithIcon(
                    Icons.info_outline,
                    'ID de Usuario',
                    '${_userProfile.personaId ?? 'N/A'}',
                  ),
                  buildDivider(),
                  buildUserInfoWithIcon(
                    Icons.account_circle_outlined,
                    'Nombre de Usuario',
                    _userProfile.nombreUsuario,
                  ),
                  buildDivider(),
                  buildUserInfoWithIcon(
                    Icons.admin_panel_settings_outlined,
                    'Es Administrador',
                    _userProfile.admin ? 'Sí' : 'No',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChangePasswordUI() {
    return Center(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: () {
                  Imagen(context);
                },
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundImage: NetworkImage(_userProfile.imagen),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPalette.darkblueColorApp,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    opciones(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(18),
            child: TextField(
              controller: contraseniaAnteriorController,
              obscureText: !mostrarContraseniaAnterior,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                label: const Text("Contraseña Anterior",
                    style: TextStyle(color: Colors.black)),
                prefixIcon: const Icon(Icons.key, color: Colors.black),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      mostrarContraseniaAnterior = !mostrarContraseniaAnterior;
                    });
                  },
                  child: mostrarContraseniaAnterior
                      ? const Icon(CupertinoIcons.eye_slash_fill,
                          color: Colors.black)
                      : const Icon(CupertinoIcons.eye_fill,
                          color: Colors.black),
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: TextField(
              controller: contraseniaNuevaController,
              obscureText: !mostrarContraseniaNueva,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                label: const Text("Nueva Contraseña",
                    style: TextStyle(color: Colors.black)),
                prefixIcon: const Icon(Icons.key, color: Colors.black),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      mostrarContraseniaNueva = !mostrarContraseniaNueva;
                    });
                  },
                  child: mostrarContraseniaNueva
                      ? const Icon(CupertinoIcons.eye_slash_fill,
                          color: Colors.black)
                      : const Icon(CupertinoIcons.eye_fill,
                          color: Colors.black),
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: TextField(
              controller: contraseniaConfirmarController,
              obscureText: !mostrarContraseniaConfirmar,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                label: const Text("Confirmar Contraseña",
                    style: TextStyle(color: Colors.black)),
                prefixIcon: const Icon(Icons.key, color: Colors.black),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      mostrarContraseniaConfirmar =
                          !mostrarContraseniaConfirmar;
                    });
                  },
                  child: mostrarContraseniaConfirmar
                      ? const Icon(CupertinoIcons.eye_slash_fill,
                          color: Colors.black)
                      : const Icon(CupertinoIcons.eye_fill,
                          color: Colors.black),
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    contraseniaAnteriorController.text = '';
                    contraseniaNuevaController.text = '';
                    contraseniaConfirmarController.text = '';
                    changingPassword = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchAndSendData(
                      context,
                      _userProfile.nombreUsuario,
                      contraseniaAnteriorController.text,
                      contraseniaNuevaController.text,
                      contraseniaConfirmarController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.darkblueColorApp,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Future<void> fetchAndSendData(
      BuildContext context,
      String usuario,
      String contraseniaAnterior,
      String contraseniaNueva,
      String contraseniaConfirmar) async {
    try {
      final peticion = {
        'nombreUsuario': usuario,
        'contrasena': contraseniaAnterior
      };

      final peticionJson = jsonEncode(peticion);
      final response = await http.post(
        Uri.parse('${apiUrl}Usuario/Login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: peticionJson,
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final data = decodedJson["data"];
        if (data != null && data.isNotEmpty) {
          if (contraseniaNueva == contraseniaAnterior) {
            CherryToast.error(
              title: const Text(
                'Las Contraseña nueva no puede ser igual a la anterior',
                style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.justify,
              ),
              borderRadius: 5,
            ).show(context);
          } else {
            if (contraseniaNueva != contraseniaConfirmar) {
              CherryToast.error(
                title: const Text(
                  'Las Contraseñas nuevas no son iguales',
                  style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                  textAlign: TextAlign.justify,
                ),
                borderRadius: 5,
              ).show(context);
            } else {
              editData(context, contraseniaNueva);
            }
          }
        }
      } else {
        CherryToast.error(
          title: const Text(
            'Contraseña Incorrecta',
            style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
            textAlign: TextAlign.justify,
          ),
          borderRadius: 5,
        ).show(context);
      }
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        CherryToast.warning(
          title: const Text('No se pudo conectar al servidor',
              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              textAlign: TextAlign.justify),
          borderRadius: 5,
        ).show(context);
      } else {
        print('Error: $e');
      }
    } finally {}
  }

  Future<void> editData(BuildContext context, String password) async {
    try {
      String fecha = DateTime.now().toUtc().toIso8601String();

      final peticionEdicion = {
        'usuarioId': _userProfile.usuarioId,
        'nombreUsuario': _userProfile.nombreUsuario,
        'contrasena': password,
        'personaId': _userProfile.personaId,
        'sucursalId': _userProfile.sucursalId,
        'usuarioModificacion': _userProfile.usuarioId,
        'fechaModificacion': fecha,
      };

      final peticionJson = jsonEncode(peticionEdicion);
      final response = await http.put(
        Uri.parse('${apiUrl}Usuario/EditarContrasenia'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: peticionJson,
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);

        final respuesta = decodedJson["message"];
        if (respuesta == ('El usuario se ha editado exitosamente')) {
          CherryToast.success(
            title: const Text('Contraseña Editada Exitosamente',
                style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                textAlign: TextAlign.justify),
            borderRadius: 5,
          ).show(context);
          contraseniaAnteriorController.text = '';
          contraseniaNuevaController.text = '';
          contraseniaConfirmarController.text = '';
          changingPassword = false;
        }
      } else {
        CherryToast.error(
          title: const Text('Contraseña Incorrecta',
              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              textAlign: TextAlign.justify),
          borderRadius: 5,
        ).show(context);
      }
    } catch (e) {
      if (e is SocketException) {
        CherryToast.warning(
          title: const Text('No se pudo conectar al servidor',
              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              textAlign: TextAlign.justify),
          borderRadius: 5,
        ).show(context);
      } else {
        print('Error: $e');
      }
    }
  }

  Widget buildUserInfoWithIcon(IconData icon, String title, [String? value]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.0,
          color: ColorPalette.darkblueColorApp,
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3.0),
      height: 1.0,
      color: const Color.fromARGB(180, 158, 158, 158),
    );
  }

  void opciones(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    selImagen(1, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Toma una foto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.camera_alt_outlined,
                          color: ColorPalette.darkblueColorApp,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selImagen(2, context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Elegir de Galeria',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.photo,
                          color: ColorPalette.darkblueColorApp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future selImagen(op, context) async {
    File Imagen;
    // Lógica de seleccionar imagen aquí...

    Navigator.of(context).pop(); // Cerrar el diálogo
  }

  void Imagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(500.0),
            ),
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500.0),
                image: DecorationImage(
                  image: NetworkImage(_userProfile.imagen),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: (300 - 50) / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Image.asset(
                        'images/LogoBlanco.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
