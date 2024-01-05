import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:simexpro/screens/recover_password_screen.dart';
//import 'package:simexpro/widgets/navbar_roots.dart';
import 'package:http/http.dart' as http;
import 'package:app_loteria/utils/ColorPalette.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:simexpro/api.dart';
//import 'package:simexpro/toastconfig/toastconfig.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Wallpaper_Login.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Card(
                      color: Color.fromARGB(0, 0, 0, 0),
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
                              padding: EdgeInsets.all(18),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                label: Text("Usuario",
                                    style: GoogleFonts.dongle(color: Colors.white)),
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.white),
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                label: Text("Contraseña",
                                    style: GoogleFonts.dongle(color: Colors.white)),
                                prefixIcon:
                                    Icon(Icons.key, color: Colors.white),
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
                                      ? Icon(CupertinoIcons.eye_slash_fill,
                                          color: Colors.white)
                                      : Icon(CupertinoIcons.eye_fill,
                                          color: Colors.white),
                                ),
                              ),
                              style: GoogleFonts.dongle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
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
                                  // fetchData(context, username, password);
                                } else {
                                  // CherryToast.warning(
                                  //   title: Text(
                                  //       'Llene los campos correctamente',
                                  //       style: TextStyle(
                                  //           color: Color.fromARGB(
                                  //               255, 226, 226, 226)),
                                  //       textAlign: TextAlign.justify),
                                  //   borderRadius: 5,
                                  // ).show(context);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorPalette.primaryColorApp,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
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
                  SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
