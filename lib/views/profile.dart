import 'package:flutter/material.dart';
import 'package:nyimpang_cooperative/repo/repository.dart';
import 'package:nyimpang_cooperative/utils/size_config.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Material(
      color: Repository.bgColor(context),
      elevation: 0,
      child: const Text(
        'Index 2: Profile',
      ),
    );
  }
}
