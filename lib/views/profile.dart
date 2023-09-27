import 'package:flutter/material.dart';
import 'package:nyimpang_cooperative/models/auth.dart';
import 'package:nyimpang_cooperative/repo/repository.dart';
import 'package:nyimpang_cooperative/utils/size_config.dart';
import 'package:nyimpang_cooperative/views/auth_screens/login_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Material(
      color: Repository.bgColor(context),
      elevation: 0,
      child: ElevatedButton(
          onPressed: () async {
            await UserAuth.clearUserAuth();
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            }
          },
          child: const Text('Logout')),
    );
  }
}
