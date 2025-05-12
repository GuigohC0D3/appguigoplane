import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import '../services/amadeus_service.dart';
import '../utils/cidades_iata.dart';
import 'flight_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String userName = "Visitante";
  bool isLoading = true;
  bool _visible = false;
  int _selectedIndex = 0;

  final _searchController = TextEditingController();
  final AmadeusService _amadeusService = AmadeusService();

  List<dynamic> _airports = [];
  bool _isSearching = false;

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

  Future<void> _searchAirports(String input) async {
    final keyword = cidadeParaIATACode[input.toLowerCase().trim()] ?? input;

    setState(() {
      _isSearching = true;
      _airports = [];
    });

    try {
      final results = await _amadeusService.searchAirports(keyword);
      setState(() {
        _airports = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar: $e')));
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
        child:
            isLoading
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
                            _buildAirportSearchSection(),
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
            itemBuilder:
                (context) => const [
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Procure',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirportSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.flight),
              hintText: "Buscar aeroporto...",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) => _searchAirports(value),
          ),
          const SizedBox(height: 16),
          if (_isSearching)
            const Center(child: CircularProgressIndicator())
          else
            _buildResultsList(),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    if (_airports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text("Nenhum aeroporto encontrado."),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _airports.length,
      itemBuilder: (context, index) {
        final item = _airports[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.flight_takeoff),
            title: Text(item['name'] ?? 'Sem nome'),
            subtitle: Text(item['iataCode'] ?? 'Sem código'),
          ),
        );
      },
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
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FlightSearchScreen()),
          );
        }
        
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
