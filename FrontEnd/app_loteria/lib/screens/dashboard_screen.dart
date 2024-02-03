import 'package:app_loteria/screens/persona/createperonsa_screen.dart';
import 'package:app_loteria/screens/persona/listpersona_screen.dart';
import 'package:app_loteria/screens/reportes/reporteInventario_screen.dart';
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
  late String nombreUsuario;

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
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.0,
      runSpacing: 16.0,
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPersonaScreen()),
            );
          },
          child: CardWidget(
            title: 'Personas',
            color: Colors.blue.shade400,
            icon: Icons.person,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListUsuarioScreen()),
            );
          },
          child: CardWidget(
            title: 'Usuarios',
            color: Colors.red.shade400,
            icon: Icons.supervised_user_circle_outlined,
          ),
        ),
        GestureDetector(
          onTap: () {
            opciones(context);
          },
          child: CardWidget(
            title: 'Reportes',
            color: Colors.purple.shade600,
            icon: Icons.picture_as_pdf_outlined,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportePDFInventario()),
            );
          },
          child: CardWidget(
            title: 'Tarjeta 4',
            color: Colors.lightGreen.shade600,
            icon: Icons.query_stats_outlined,
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
                    MaterialPageRoute(builder: (context) => const ReportePDFInventario()),
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
                          'Reporte de Inventario',
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
                    MaterialPageRoute(builder: (context) => const ReportePDFNumerosVendidos()),
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
                          'Reporte de Numeros Vendidos',
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

class CardWidget extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const CardWidget({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );
  }
}
