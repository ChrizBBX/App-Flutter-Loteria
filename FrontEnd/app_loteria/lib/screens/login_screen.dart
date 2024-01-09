import 'dart:convert';
import 'package:app_loteria/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simexpro/screens/recover_password_screen.dart';
//import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/utils/ColorPalette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_loteria/api.dart';
import 'package:app_loteria/toastconfig/toastconfig.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}


Future<void> fetchData(
    BuildContext context, String username, String password) async {
  try {
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
          
    // final tarea = {'usua_Nombre': username, 'usua_Contrasenia': password};
    // final jsonTarea = jsonEncode(tarea);
    // final response = await http.post(
    //   Uri.parse('${apiUrl}Usuarios/Login'),
    //   headers: {
    //     'XApiKey': apiKey,
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonTarea,
    // );
    // if (response.statusCode == 200) {
    //   print(response);
    //   final decodedJson = jsonDecode(response.body);
    //   final data = decodedJson["data"];
    //   print(data);
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setInt('usua_Id', data['usua_Id']);
    //   prefs.setString('username', data['usua_Nombre']);
    //   prefs.setString('email', data['empl_CorreoElectronico']);
    //   prefs.setString('userfullname', data['emplNombreCompleto']);
    //   prefs.setString('rol', data['role_Descripcion']);
    //   prefs.setBool('esAduana', data['empl_EsAduana']);
    //   prefs.setString('image', data['usua_Image']);
     
    // } else {
    //   CherryToast.error(
    //     title: Text('El usuario o contraseña son incorrectos',
    //         style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
    //         textAlign: TextAlign.justify),
    //     borderRadius: 5,
    //   ).show(context);
    // }
  } catch (e) {
    if (e.toString().contains('Failed host lookup')) {
      CherryToast.error(
        title: Text('No se pudo conectar al servidor',
            style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
            textAlign: TextAlign.justify),
        borderRadius: 5,
      ).show(context);
    }
  }
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
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Image.asset(
                              "images/LogoBlanco.png",
                              height: 230,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(18),
                              child: Text(
                                'INICIO DE SESIÓN',
                                style: GoogleFonts.dongle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: ColorPalette.whiteColor,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 18, left: 18, bottom: 18),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  username = value;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                label: Text("Usuario",
                                    style: GoogleFonts.dongle(
                                        color: Colors.white)),
                                prefixIcon:
                                    const Icon(Icons.person, color: Colors.white),
                              ),
                              style: GoogleFonts.dongle(color: Colors.white),
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
                                label: Text("Contraseña",
                                    style: GoogleFonts.dongle(
                                        color: Colors.white)),
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
                                      ? const Icon(CupertinoIcons.eye_slash_fill,
                                          color: Colors.white)
                                      : const Icon(CupertinoIcons.eye_fill,
                                          color: Colors.white),
                                ),
                              ),
                              style: GoogleFonts.dongle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //       RecoverPasswordScreen(),
                                    //   ),
                                    // );
                                  },
                                  child: Text(
                                    "¿Contraseña olvidada?",
                                    style: GoogleFonts.dongle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: ColorPalette.whiteColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                child: Center(
                                  child: Text(
                                    "Iniciar sesión",
                                    style: GoogleFonts.dongle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
