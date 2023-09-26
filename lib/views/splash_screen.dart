import 'package:flutter/material.dart';
import 'package:nyimpang_cooperative/models/auth.dart';
import 'package:nyimpang_cooperative/views/auth_screens/login_page.dart';
import 'package:nyimpang_cooperative/widgets/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    screenNavigate();
  }

  Future<void> screenNavigate() async {
    bool isUserLogedIn = await UserAuth().isUserLoggedIn();

    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (cntxt) =>
              isUserLogedIn == false ? const LoginPage() : const BottomNav(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Image.asset(
        'assets/images/nyimpang.png',
        width: 300,
        height: 126
      ),
    );
  }
}
