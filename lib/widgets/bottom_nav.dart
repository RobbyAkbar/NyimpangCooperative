import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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
      bottomNavigationBar: ConvexAppBar(
        activeColor: Styles.secondaryColor,
        backgroundColor: Styles.primaryColor, //Repository.navbarColor(context),
        items: [
          TabItem(
            icon: Icon(IconlyBold.Home, color: Styles.whiteColor),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(IconlyBold.Chat, color: Styles.whiteColor),
            title: 'Chat',
          ),
          TabItem(
            icon: Icon(IconlyBold.Profile, color: Styles.whiteColor),
            title: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
