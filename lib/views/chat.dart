import 'package:flutter/material.dart';
import 'package:nyimpang_cooperative/repo/repository.dart';
import 'package:nyimpang_cooperative/utils/size_config.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Material(
      color: Repository.bgColor(context),
      elevation: 0,
      child: const Text(
        'Index 1: Chat',
      ),
    );
  }
}
