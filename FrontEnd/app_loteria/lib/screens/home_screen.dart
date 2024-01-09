import 'package:flutter/material.dart';
import 'package:app_loteria/widgets/appbar_roots.dart';
import '../widgets/navbar_roots.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithoutBackButton(
        imageUrl: 'images/LogoBlanco.png',
        profileImageUrl: 'https://i.pinimg.com/736x/ec/65/40/ec65407c06bcdd015a81e76add16d55c.jpg',
        onProfilePressed: () {
          
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 16.0),

          ],
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
