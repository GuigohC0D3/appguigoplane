import 'package:flutter/material.dart';

class FlightDetailScreen extends StatelessWidget {
  final Map flight;
  const FlightDetailScreen({super.key, required this.flight});

  void _confirmarCompra(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compra confirmada com sucesso!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final price = flight['price']['total'];
    final duration = flight['itineraries'][0]['duration'];
    final airline = flight['validatingAirlineCodes']?[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Voo'),
        backgroundColor: const Color(0xFF00A896),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Companhia: $airline', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Duração: $duration', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              'Preço: R\$ $price',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A896),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _confirmarCompra(context),
                label: const Text(
                  'Confirmar Compra',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
