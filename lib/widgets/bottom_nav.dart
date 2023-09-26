import 'package:flutter/material.dart';
import 'package:nyimpang_cooperative/utils/iconly/iconly_bold.dart';
import 'package:nyimpang_cooperative/utils/styles.dart';
import 'package:nyimpang_cooperative/views/chat.dart';
import 'package:nyimpang_cooperative/views/home.dart';
import 'package:nyimpang_cooperative/views/profile.dart';

/// This is the stateful widget that the main application instantiates.
class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Chat(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Styles.primaryColor, //Repository.navbarColor(context),
        selectedLabelStyle: TextStyle(color: Styles.secondaryColor),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Styles.secondaryColor, //Repository.selectedItemColor(context),
        unselectedItemColor: Styles.whiteColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyBold.Profile),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
