import 'package:flutter/material.dart';
import 'package:nyimpang_cooperative/utils/styles.dart';
import 'package:nyimpang_cooperative/view_models/view_models.dart';
import 'package:nyimpang_cooperative/views/splash_screen.dart';
import 'package:provider/provider.dart';

class NyimpangCoop extends StatelessWidget {
  const NyimpangCoop({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModel())
      ],
      child: MaterialApp(
        title: 'Nyimpang Cooperative',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'DMSans',
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(background: Styles.primaryColor, primary: Styles.primaryColor),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
