import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String userName = "Visitante";
  bool isLoading = true;
  bool _visible = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    setState(() {
      userName = email != null ? email.split('@').first : "Visitante";
      isLoading = false;
      _visible = true;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() => _visible = false);
    await _loadUser();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Você realmente deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSlide(
                offset: _visible ? Offset.zero : const Offset(0, 0.1),
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildSearchSection(),
                    const SizedBox(height: 24),
                    _buildPromoCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF00A896),
              child: Icon(Icons.person, color: Colors.white),
            ),
            onSelected: (value) {
              if (value == 'logout') _showLogoutDialog();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'logout', child: Text('Sair')),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Olá, $userName!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSearchField(Icons.location_on_outlined, "Localização"),
          const SizedBox(height: 12),
          _buildSearchField(Icons.calendar_today, "Feb 21 - Feb 29"),
          const SizedBox(height: 12),
          _buildSearchField(Icons.people_outline, "2 Pessoas"),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A896),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Procure',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EBF2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(
                  'assets/img/amazonia.png',
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Text(
                    'AMAZÔNIA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(1, 1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C896),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '20% de Desconto!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'BIBIGO-AIRLINE',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nossa plataforma simplifica a reserva de voos, hotéis e passeios. '
                'Basta alguns cliques para garantir sua viagem dos sonhos. '
                'O melhor? Oferecemos opções para todos os orçamentos!',
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nossos guias locais compartilham dicas exclusivas e roteiros personalizados '
                'para tornar sua viagem inesquecível.',
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(IconData icon, String hint) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF00A896),
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }
}