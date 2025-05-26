import 'package:flutter/material.dart';

class CancelBoardingScreen extends StatelessWidget {
  const CancelBoardingScreen({super.key});

  void _cancelBoardingPass(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cancelamento'),
        content: const Text('Tem certeza que deseja cancelar seu cartão de embarque?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      // Aqui você pode remover o cartão do Firestore ou SharedPreferences

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Cancelado'),
          content: const Text('Cartão de embarque cancelado. O valor será estornado.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelar Cartão de Embarque'),
        backgroundColor: const Color(0xFF094067),
      ),
      backgroundColor: const Color(0xFFd8eefe),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cartão de Embarque Ativo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF094067),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Passageiro: Guilherme Ancheschi Werneck Pereira'),
                  Text('Voo: AZ1234'),
                  Text('Origem: Teresina (THE)'),
                  Text('Destino: Recife (REC)'),
                  Text('Data: 26/05/2025'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text('Cancelar Cartão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _cancelBoardingPass(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
