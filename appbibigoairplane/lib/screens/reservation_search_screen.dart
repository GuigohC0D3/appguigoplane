import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reservation_details_screen.dart';

class ReservationSearchScreen extends StatefulWidget {
  const ReservationSearchScreen({super.key});

  @override
  State<ReservationSearchScreen> createState() => _ReservationSearchScreenState();
}

class _ReservationSearchScreenState extends State<ReservationSearchScreen> {
  final _controller = TextEditingController();
  Map<String, dynamic>? reservaData;
  bool notFound = false;

  Future<void> _buscarReserva() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('ultima_reserva');

    if (json != null) {
      final dados = jsonDecode(json);
      if (dados['codigoReserva'] == _controller.text.trim()) {
        setState(() {
          reservaData = dados;
          notFound = false;
        });
      } else {
        setState(() {
          reservaData = null;
          notFound = true;
        });
      }
    } else {
      setState(() {
        reservaData = null;
        notFound = true;
      });
    }
  }

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
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ex: BIB123456',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _buscarReserva,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Verificar', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            if (notFound)
              const Text('Reserva não encontrada.', style: TextStyle(color: Colors.red)),
            if (reservaData != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReservationDetailsScreen(data: reservaData!),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF094067),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Visualizar Detalhes', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
