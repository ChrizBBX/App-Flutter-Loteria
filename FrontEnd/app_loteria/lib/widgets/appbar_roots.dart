import 'package:app_loteria/screens/home_screen.dart';
import 'package:app_loteria/screens/login_screen.dart';
import 'package:app_loteria/screens/profile_screen.dart';
import 'package:app_loteria/utils/ColorPalette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/Usuario.dart';

class AppBarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String profileImageUrl;
  final VoidCallback onProfilePressed;

  const AppBarWithBackButton({
    Key? key,
    required this.title,
    required this.profileImageUrl,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoMono',
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
        },
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'mi_perfil') {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            } else if (value == 'cerrar_sesion') {
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => loginScreen(),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'mi_perfil',
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Mi Perfil'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'cerrar_sesion',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Cerrar Sesión'),
                ],
              ),
            ),
          ],
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ],
      backgroundColor: ColorPalette.darkblueColorApp,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarWithoutBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String imageUrl;
  final String profileImageUrl;
  final VoidCallback onProfilePressed;

  const AppBarWithoutBackButton({
    Key? key,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        imageUrl,
        height: 170,
        width: 210,
        fit: BoxFit.fitHeight,
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'mi_perfil') {
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            } else if (value == 'cerrar_sesion') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => loginScreen(),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'mi_perfil',
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Mi Perfil'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'cerrar_sesion',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Cerrar Sesión'),
                ],
              ),
            ),
          ],
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
      ],
      backgroundColor: ColorPalette.darkblueColorApp,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
