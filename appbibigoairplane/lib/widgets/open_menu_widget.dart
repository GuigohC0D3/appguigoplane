import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

class OpenMenuWidget extends StatelessWidget {
  const OpenMenuWidget({super.key});

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
        const SizedBox(height: 16),
        _buildSectionTitle('Conta'),
        _buildMenuItem(context, 'Logout', isLogout: true),
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

  Widget _buildMenuItem(BuildContext context, String title, {bool isLogout = false}) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);

        if (isLogout) {
          _confirmLogout();
          return;
        }

        switch (title) {
          case 'Alteração e Cancelamento':
            navigatorKey.currentState?.pushNamed('/cancel-boarding');
            break;
          case 'Encontrar reserva':
            navigatorKey.currentState?.pushNamed('/reservation-search');
            break;
          case 'Antecipar voo':
          // rota fictícia, adicione se existir
            navigatorKey.currentState?.pushNamed('/check-in');
            break;
          default:
            if (navigatorKey.currentContext != null) {
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                SnackBar(content: Text('$title clicado')),
              );
            }
        }
      },
    );
  }

  void _confirmLogout() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text('Deseja sair da conta?'),
        content: const Text('Você será desconectado do aplicativo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
