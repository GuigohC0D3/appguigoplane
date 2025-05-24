import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/preloading_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/flight_search_screen.dart';
import 'screens/flight_results_screen.dart';
import 'screens/check_in_screen.dart';
import 'screens/seat_select_screen.dart';
import 'screens/reservation_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AeroApp());
}

class AeroApp extends StatelessWidget {
  const AeroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BibigoAirplane',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/preloading',
      routes: {
        '/preloading': (context) => const PreloadingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/flight-search': (context) => const FlightSearch(),
        '/flight-results': (context) => FlightResultsScreen(
              origin: '',
              destination: '',
              departureDate: DateTime.now(),
              passengers: 1,
              flightClass: 'ECONOMY',
            ),
        '/check-in': (context) => const CheckInScreen(),
        '/seat-selection': (context) => const SeatSelectionScreen(),
        '/reservation-search': (context) => const ReservationSearchScreen(),
      },
    );
  }
}
