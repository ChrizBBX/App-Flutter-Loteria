// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:app_loteria/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/utils/ColorPalette.dart';
import 'package:app_loteria/api.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

Future<void> fetchData(
    BuildContext context, String username, String password) async {
  try {
    final peticion = {'nombreUsuario': username, 'contrasena': password};
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
      final message = decodedJson["message"];
      if (message == 'El usuario o contraseña es incorrecto') {
        CherryToast.warning(
          title: const Text('Usuario o Contraseña Incorrecto',
              style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              textAlign: TextAlign.start),
          borderRadius: 5,
        ).show(context);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('usuarioId', data[0]['usuarioId']);
        prefs.setString('nombreUsuario', data[0]['nombreUsuario'].toString());
        prefs.setString('imagen', /* data[0]['imagen'].toString()*/ 'https://64.media.tumblr.com/6a5a68b858b592f3bc84d2e7f4be90bb/8a8beb1bdd1ae19a-48/s1280x1920/38303321aed4091d34600f8d9147378d46b29d35.jpg');
        prefs.setInt('sucursalId', data[0]['sucursalId'] ?? 0);
        prefs.setInt('personaId', data[0]['personaId'] ?? 0);
        prefs.setString('fechaSus', data[0]['fechaSus'] ?? '');

        bool adminValue = data[0]['admin'];
        int adminIntValue = adminValue ? 1 : 0;
        prefs.setInt('admin', adminIntValue);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } else {
      CherryToast.error(
        title: const Text('No se ha podido conectar al servidor',
            style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
            textAlign: TextAlign.start),
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
    } else {}
  } finally {}
}

class _loginScreenState extends State<loginScreen> {
  bool passToggle = true;
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Wallpaper_Login.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Image.asset(
                                "images/LogoBlanco.png",
                                height: 230,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(18),
                            child: Text(
                              'INICIO DE SESIÓN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RobotoMono',
                                fontSize: 25,
                                color: ColorPalette.whiteColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 18, left: 18, bottom: 18),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                                });
                              },
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                label: Text("Usuario",
                                    style: TextStyle(color: Colors.white)),
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.white),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              obscureText: passToggle ? true : false,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                label: const Text("Contraseña",
                                    style: TextStyle(color: Colors.white)),
                                prefixIcon:
                                    const Icon(Icons.key, color: Colors.white),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    if (passToggle == true) {
                                      passToggle = false;
                                    } else {
                                      passToggle = true;
                                    }
                                    setState(() {});
                                  },
                                  child: passToggle
                                      ? const Icon(
                                          CupertinoIcons.eye_slash_fill,
                                          color: Colors.white)
                                      : const Icon(CupertinoIcons.eye_fill,
                                          color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 18.00),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: InkWell(
                              onTap: () {
                                if (username.isNotEmpty &&
                                    password.isNotEmpty) {
                                  fetchData(context, username, password);
                                } else {
                                  CherryToast.warning(
                                    title: const Text(
                                        'Llene los campos correctamente',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 226, 226, 226)),
                                        textAlign: TextAlign.justify),
                                    borderRadius: 5,
                                  ).show(context);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorPalette.primaryColorApp,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "Iniciar sesión",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RobotoMono',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
