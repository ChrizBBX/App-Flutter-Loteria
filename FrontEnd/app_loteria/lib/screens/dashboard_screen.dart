// ignore_for_file: use_build_context_synchronously

import 'package:app_loteria/screens/cierre/cierrelist_screen.dart';
import 'package:app_loteria/screens/persona/createperonsa_screen.dart';
import 'package:app_loteria/screens/persona/listpersona_screen.dart';
import 'package:app_loteria/screens/reportes/reporteCierre_screen.dart';
import 'package:app_loteria/screens/reportes/reporteInventario_screen.dart';
import 'package:app_loteria/screens/reportes/reporteNumerosMasVendidos_screen.dart';
import 'package:app_loteria/screens/reportes/reporteNumerosVendidos_screen.dart';
import 'package:app_loteria/screens/usuario/listusuario_screen.dart';
import 'package:app_loteria/utils/ColorPalette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardListWidget extends StatefulWidget {
  @override
  _CardListWidgetState createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> {
  String nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombreUsuario = prefs.getString('nombreUsuario') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          height: 140,
          width: 430,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: const DecorationImage(
              image: AssetImage("images/Wallpaper_Login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 35,
                left: 0,
                right: 0,
                child: Text(
                  'Bienvenido $nombreUsuario',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                    fontSize: 20.0,
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Text(
                  _getCurrentTime(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  opciones(context);
                },
                child: CardWidget(
                  title: 'Reportes',
                  backgroundImage: 'images/FondoReportes.jpg',
                  icon: Icons.picture_as_pdf_outlined,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListCierreScreen()),
                  );
                },
                child: CardWidget(
                  title: 'Cierre',
                  backgroundImage: 'images/FondoCierres.jpg',
                  icon: Icons.monetization_on_outlined,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListPersonaScreen()),
                  );
                },
                child: CardWidget(
                  backgroundImage: 'images/FondoPersonas.jpg',
                  title: 'Personas',
                  icon: Icons.person,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListUsuarioScreen()),
                  );
                },
                child: CardWidget(
                  title: 'Usuarios',
                  backgroundImage: 'images/FondoUsuarios.jpg',
                  icon: Icons.supervised_user_circle_outlined,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat.jm().format(now);
    return formattedTime;
  }
}

opciones(context) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportePDFInventario()),
                  );
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
                          'Inventario',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(
                        Icons.document_scanner,
                        color: ColorPalette.darkblueColorApp,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _mostrarSelectorFechas(context, 2);
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
                          'Facturas',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(
                        Icons.document_scanner,
                        color: ColorPalette.darkblueColorApp,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _mostrarSelectorFechas(context, 3);
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
                          'Numeros Más Vendidos',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(
                        Icons.document_scanner,
                        color: ColorPalette.darkblueColorApp,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportePDF_Cierre()),
                  );
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
                          'Cierre del Dia',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(
                        Icons.document_scanner,
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

_mostrarSelectorFechas(BuildContext context, opcion) async {
  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime.now().subtract(Duration(days: 365)),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: ColorPalette
              .darkblueColorApp, // Cambia este color según tu preferencia
          accentColor: ColorPalette
              .darkblueColorApp, // Cambia este color según tu preferencia
          colorScheme:
              ColorScheme.light(primary: ColorPalette.darkblueColorApp),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked.start != null && picked.end != null) {
    _generarReporte(context, picked.start, picked.end, opcion);
  }
}

_generarReporte(context, DateTime fechaInicio, DateTime fechaFin, opcion) {
  if (fechaInicio != null && fechaFin != null) {
    switch (opcion) {
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportePDFNumerosVendidos(
              fechaInicio: fechaInicio,
              fechaFin: fechaFin,
            ),
          ),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportePDFTopNumeros(
              fechaInicio: fechaInicio,
              fechaFin: fechaFin,
            ),
          ),
        );
        break;
      default:
    }
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String backgroundImage; // Agregado el parámetro para la imagen de fondo
  final IconData icon;

  const CardWidget({
    required this.title,
    required this.backgroundImage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 335,
      width: 325,
      child: Stack(
        children: [
          Image.asset(
            backgroundImage,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 335,
            width: 325,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 60.0,
                ),
                const SizedBox(height: 20.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
