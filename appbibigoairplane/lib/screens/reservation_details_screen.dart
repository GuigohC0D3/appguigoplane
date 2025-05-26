import 'package:flutter/material.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const ReservationDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final vooIda = Map<String, dynamic>.from(data['voo'] ?? {});
    final vooVolta = Map<String, dynamic>.from(data['volta'] ?? {});
    final assentos = List<String>.from(data['assentos'] ?? []);
    final assentosVolta = List<String>.from(data['assentosVolta'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Reserva'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _vooCard('Ida', vooIda, assentos),
            const SizedBox(height: 20),
            if (vooVolta.isNotEmpty) _vooCard('Volta', vooVolta, assentosVolta),
          ],
        ),
      ),
    );
  }

  Widget _vooCard(String titulo, Map<String, dynamic> voo, List<String> assentos) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Voo: ${voo['flightNumber'] ?? '---'}'),
            Text('Origem: ${voo['from'] ?? '---'}'),
            Text('Destino: ${voo['to'] ?? '---'}'),
            Text('Data: ${voo['date'] ?? '---'}'),
            Text('Saída: ${voo['departureTime'] ?? '--:--'}'),
            Text('Chegada: ${voo['arrivalTime'] ?? '--:--'}'),
            Text('Terminal: ${voo['terminal'] ?? '--'}'),
            Text('Portão: ${voo['gate'] ?? '--'}'),
            const SizedBox(height: 6),
            Text('Assento(s): ${assentos.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
