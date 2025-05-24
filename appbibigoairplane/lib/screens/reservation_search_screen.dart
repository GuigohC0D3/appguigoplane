import 'package:flutter/material.dart';

class ReservationSearchScreen extends StatelessWidget {
  const ReservationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Reserva'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Digite o código da reserva para verificar detalhes:'),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ex: BIB123456',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reserva não encontrada.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Verificar', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
