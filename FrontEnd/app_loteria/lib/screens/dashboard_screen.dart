import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.0,
      runSpacing: 16.0,
      children: [
        Container(
          margin: EdgeInsets.all(8.0),
          height: 140,
          width: 430,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
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
                  'Bienvenido Usuario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
            ],
          ),
        ),
        CardWidget(
          title: 'Tarjeta 1',
          color: Colors.blue.shade400,
          icon: Icons.event,
        ),
        CardWidget(
          title: 'Tarjeta 2',
          color: Colors.red.shade400,
          icon: Icons.add,
        ),
        CardWidget(
          title: 'Tarjeta 3',
          color: Colors.purple.shade600,
          icon: Icons.emoji_events_outlined,
        ),
        CardWidget(
          title: 'Tarjeta 4',
          color: Colors.lightGreen.shade600,
          icon: Icons.query_stats_outlined,
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
      margin: EdgeInsets.all(8.0),
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
          SizedBox(height: 10.0),
          Text(
            title,
            style: TextStyle(
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
