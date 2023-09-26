import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nyimpang_cooperative/app.dart';
import 'package:nyimpang_cooperative/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NyimpangCoop());
}
