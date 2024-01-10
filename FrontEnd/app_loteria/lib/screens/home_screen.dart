// home_screen.dart
import 'package:app_loteria/screens/dashboard_screen.dart';
import 'package:app_loteria/screens/number_configuration_screen.dart';
import 'package:app_loteria/screens/sale_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import '../widgets/navbar_roots.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  Widget _getSelectedComponent() {
    switch (_selectedIndex) {
      case 0:
        return Sale_Screen();
      case 1:
        return CardListWidget();
      case 2:
        return NumberConfigurationScreen();
      default:
        return SizedBox.shrink();
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithoutBackButton(
        imageUrl: 'images/LogoBlanco.png',
        profileImageUrl: 'https://64.media.tumblr.com/6a5a68b858b592f3bc84d2e7f4be90bb/8a8beb1bdd1ae19a-48/s1280x1920/38303321aed4091d34600f8d9147378d46b29d35.jpg',
        onProfilePressed: () {
          
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: _getSelectedComponent(),
        ),
      ),
      bottomNavigationBar: NavBarRoots(
        selectedIndex: _selectedIndex,
        onTabTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
