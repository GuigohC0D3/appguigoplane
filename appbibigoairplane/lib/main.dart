import 'package:flutter/foundation.dart'; // para verificar se é Web
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart'; // gerado pelo flutterfire configure
import 'package:appbibigoairplane/screens/welcome_screen.dart';
import 'package:appbibigoairplane/screens/login_screen.dart';
import 'package:appbibigoairplane/screens/home_screen.dart';
import 'package:appbibigoairplane/screens/profile_screen.dart'; // se já existir

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const AeroApp());
}

class AeroApp extends StatelessWidget {
  const AeroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeroPassagens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(), // opcional
      },
    );
  }
}