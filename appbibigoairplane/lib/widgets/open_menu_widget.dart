import 'package:flutter/material.dart';

class OpenMenuWidget extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const OpenMenuWidget({Key? key, required this.onLanguageChanged})
    : super(key: key);

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Escolha o idioma'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageTile(context, 'Português', const Locale('pt')),
                _buildLanguageTile(context, 'English', const Locale('en')),
                _buildLanguageTile(context, 'Français', const Locale('fr')),
                _buildLanguageTile(context, 'Italiano', const Locale('it')),
              ],
            ),
          ),
    );
  }

  ListTile _buildLanguageTile(
    BuildContext context,
    String label,
    Locale locale,
  ) {
    return ListTile(
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        onLanguageChanged(locale);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Idioma'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageDialog(context),
        ),
        const Divider(),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Minha Viagem',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: const Text('Fazer check-in'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navegar ou chamar função
          },
        ),
        ListTile(
          title: const Text('Encontrar reserva'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navegar ou chamar função
          },
        ),
        ListTile(
          title: const Text('Antecipar voo'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navegar ou chamar função
          },
        ),
        const Divider(),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Informações para sua viagem',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: const Text('Alteração e Cancelamento'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navegar ou chamar função
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
