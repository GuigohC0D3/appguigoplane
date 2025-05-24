import 'package:flutter/material.dart';
import 'home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final List<String> seats;
  final double total;

  const ConfirmationScreen({
    super.key,
    required this.seats,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd8eefe),
      appBar: AppBar(
        title: const Text('Compra Confirmada'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 100, color: Color(0xFF3da9fc)),
              const SizedBox(height: 24),
              const Text(
                'Compra realizada com sucesso!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Assentos: ${seats.join(', ')}\nTotal: R\$ ${total.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3da9fc),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text(
                  'Voltar para a Home',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
