import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'boarding_pass.dart';
import 'home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final List<String> seats;
  final double total;
  final String reservationCode;

  const ConfirmationScreen({
    super.key,
    required this.seats,
    required this.total,
    required this.reservationCode,
  });

  Future<void> _openBoardingPass(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('ultima_reserva');

    if (jsonString != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const BoardingPassScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva não encontrada.')),
      );
    }
  }

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
                'Código da Reserva: $reservationCode',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF094067),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Assentos: ${seats.join(', ')}\nTotal: R\$ ${total.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _openBoardingPass(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3da9fc),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text(
                  'Ver Cartão de Embarque',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                },
                child: const Text('Voltar para a Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
