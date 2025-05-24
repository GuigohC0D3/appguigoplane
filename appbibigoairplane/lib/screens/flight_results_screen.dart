import 'package:flutter/material.dart';

class FlightResultsScreen extends StatelessWidget {
  final String origin;
  final String destination;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;
  final String flightClass;

  const FlightResultsScreen({
    super.key,
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    required this.flightClass,
  });

  @override
  Widget build(BuildContext context) {
    final mockFlights = List.generate(
      5,
      (i) => {
        'airline': 'Companhia Aérea ${i + 1}',
        'price': (1200 + (i * 150)).toString(),
        'duration': '${6 + i}h ${15 + i * 5}min',
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados da Busca')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockFlights.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final flight = mockFlights[index];
          return Card(
            child: ListTile(
              title: Text(flight['airline'].toString()),
              subtitle: Text('Duração: ${flight['duration'].toString()}'),
              trailing: Text('R\$ ${flight['price'].toString()}'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Compra simulada: ${flight['airline'].toString()}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
