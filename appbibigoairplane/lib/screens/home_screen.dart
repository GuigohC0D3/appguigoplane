import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'flight_search_screen.dart';
import '../widgets/open_menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;
  String userName = 'Visitante';

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
        userName = user.email?.split('@')[0] ?? 'Usuário';
      });
    } else {
      setState(() {
        isLoggedIn = false;
        userName = 'Visitante';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd8eefe),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
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
                          isLoggedIn
                              ? 'Olá, $userName'
                              : 'Faça seu login ou cadastre-se',
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
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF094067),
                      child: Icon(Icons.hotel, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hotéis na Azul',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF094067),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Acumule pontos reservando seu hotel e ganhe 10% OFF com o Cartão Azul Itaú',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF3da9fc),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '10%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Como podemos te ajudar?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF094067),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildMenuButton(
                      Icons.flight,
                      'Comprar passagem',
                      onPressed: () {
                        Navigator.pushNamed(context, '/flight-search');
                      },
                    ),
                    _buildMenuButton(
                      Icons.check,
                      'Fazer check-in',
                      onPressed: () {
                        Navigator.pushNamed(context, '/check-in');
                      },
                    ),
                    _buildMenuButton(
                      Icons.search,
                      'Encontrar reserva',
                      onPressed: () {
                        Navigator.pushNamed(context, '/reservation-search');
                      },
                    ),
                    _buildMenuButton(Icons.person_add, 'Cadastre-se'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF094067),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => isLoggedIn
                    ? const ProfileScreen()
                    : const LoginScreen(),
              ),
            );
          } else if (index == 4) {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (_) => const OpenMenuWidget(),
            ).then((_) => _checkSession());
          }
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Comprar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num_outlined),
            label: 'Cartões',
          ),
          BottomNavigationBarItem(
            icon: Icon(isLoggedIn ? Icons.person : Icons.login),
            label: isLoggedIn ? 'Perfil' : 'Login',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    IconData icon,
    String label, {
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3da9fc),
        padding: const EdgeInsets.symmetric(vertical: 12),
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
}
