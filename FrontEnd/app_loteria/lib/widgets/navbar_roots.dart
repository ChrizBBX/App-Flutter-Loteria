import 'package:app_loteria/utils/colorPalette.dart';
import 'package:flutter/material.dart';

class NavBarRoots extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  const NavBarRoots({required this.selectedIndex, required this.onTabTapped});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: ColorPalette.darkblueColorApp,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color.fromRGBO(255, 255, 255, 1),
      unselectedItemColor: Color.fromARGB(130, 255, 255, 255),
      selectedLabelStyle: TextStyle(
        fontFamily: 'RobotoMono',
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      currentIndex: widget.selectedIndex,
      onTap: widget.onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_shopping_cart),
          label: "Nueva Venta",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pin),
          label: "Números",
        ),
      ],
    );
  }
}
