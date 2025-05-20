import 'package:flutter/material.dart';

Widget buildHeader({required BuildContext context, required String userName, required VoidCallback onLogout}) {
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
            if (value == 'logout') onLogout();
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

Widget buildSearchSection(VoidCallback onSearchPressed) {
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
            onPressed: onSearchPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A896),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
