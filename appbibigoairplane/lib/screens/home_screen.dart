// SUBSTITUA TODO O SEU CÓDIGO DA HomeScreen PELO CONTEÚDO ABAIXO

// ... imports ...
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'boarding_pass.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'flight_search_screen.dart';
import 'reservation_search_screen.dart';
import '../widgets/open_menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;
  String userName = 'Visitante';
  bool hasReserva = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    final updatedUser = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoggedIn = updatedUser != null;
      userName = updatedUser?.displayName?.isNotEmpty == true
          ? updatedUser!.displayName!
          : updatedUser?.email?.split('@')[0] ?? 'Usuário';
      hasReserva = prefs.containsKey('ultima_reserva');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd8eefe),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _checkSession,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              GestureDetector(
                onTap: () {
                  if (!isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF094067),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isLoggedIn ? 'Olá, $userName' : 'Faça seu login ou cadastre-se',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _infoBanner(),
              const SizedBox(height: 24),
              const Text(
                'O que você deseja fazer?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF094067),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildMenuButton(Icons.flight_takeoff, 'Passagens', () {
                    Navigator.pushNamed(context, '/flight-search');
                  }),
                  _buildMenuButton(Icons.search, 'Reserva', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReservationSearchScreen()),
                    );
                  }),
                  _buildMenuButton(Icons.check, 'Check-in', () {
                    Navigator.pushNamed(context, '/check-in');
                  }),
                  _buildMenuButton(Icons.airplane_ticket, 'Cartão', () {
                    if (hasReserva) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BoardingPassScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Você ainda não possui um cartão de embarque.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  }),
                  _buildMenuButton(Icons.account_circle, 'Perfil', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => isLoggedIn ? const ProfileScreen() : const LoginScreen(),
                      ),
                    ).then((_) => _checkSession());
                  }),
                  _buildMenuButton(Icons.menu, 'Mais', () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => const OpenMenuWidget(),
                    ).then((_) => _checkSession());
                  }),
                ],
              ),
              const SizedBox(height: 20),
              if (hasReserva) _lastReservationCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3da9fc),
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _infoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF094067),
            child: Icon(Icons.card_travel, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Passagens Bibigo',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF094067)),
                ),
                SizedBox(height: 4),
                Text(
                  'Ganhe 10% OFF em sua primeira compra com o Cartão Bibigo!',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF3da9fc),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '10%',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lastReservationCard() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.airplane_ticket, color: Color(0xFF094067)),
        title: const Text('Sua última reserva está ativa!'),
        subtitle: const Text('Toque para ver o cartão de embarque.'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BoardingPassScreen()),
          );
        },
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
