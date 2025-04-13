import 'package:appbibigoairplane/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(AeroApp());
}

class AeroApp extends StatelessWidget {
  // Removido o `const` do construtor
  const AeroApp({Key? key}) : super(key: key);  // Adicionado o parâmetro key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeroPassagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
