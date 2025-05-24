import 'package:flutter/material.dart';

class OpenMenuWidget extends StatelessWidget {
  const OpenMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      children: [
        const Text(
          'Mais opções',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Minha Viagem'),
        _buildMenuItem(context, 'Encontrar reserva'),
        _buildMenuItem(context, 'Antecipar voo'),
        const SizedBox(height: 16),
        _buildSectionTitle('Informações para sua viagem'),
        _buildMenuItem(context, 'Alteração e Cancelamento'),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF094067),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context); // Fecha o drawer
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title clicado')));
      },
    );
  }
}
