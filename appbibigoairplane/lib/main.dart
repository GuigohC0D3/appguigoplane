import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Telas
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
import 'screens/payment_screen.dart';

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
        scaffoldBackgroundColor: const Color(0xFFd8eefe),
        primaryColor: const Color(0xFF3da9fc),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF3da9fc),
          secondary: const Color(0xFF90b4ce),
          error: const Color(0xFFef4565),
          background: const Color(0xFFd8eefe),
          onPrimary: Colors.white,
        ),
        fontFamily: 'Montserrat',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3da9fc),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF5f6c7b)),
          bodyMedium: TextStyle(color: Color(0xFF5f6c7b)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3da9fc),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        cardTheme: CardTheme(
          color: Color(0xFFFFFFFF),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFFFFFF),
          selectedItemColor: Color(0xFF3da9fc),
          unselectedItemColor: Color(0xFF5f6c7b),
        ),
      ),
      initialRoute: '/preloading',
      routes: {
        '/preloading': (context) => const PreloadingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/flight-search': (context) => const FlightSearch(),
        '/check-in': (context) => const CheckInScreen(),
        '/reservation-search': (context) => const ReservationSearchScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/flight-results':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => FlightResultsScreen(
                origin: args?['origin'] ?? '',
                destination: args?['destination'] ?? '',
                departureDate: args?['departureDate'] ?? DateTime.now(),
                returnDate: args?['returnDate'],
                passengers: args?['passengers'] ?? 1,
                flightClass: args?['flightClass'] ?? 'ECONOMY',
              ),
            );

          case '/seat-selection':
            return MaterialPageRoute(
              builder: (_) => const SeatSelectionWidget(seatPrice: 100),
            );

          case '/payment':
            final args = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (_) => PaymentScreen(
                flight: args['flight'],
                passenger: args['passenger'],
                selectedSeats: args['selectedSeats'],
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
