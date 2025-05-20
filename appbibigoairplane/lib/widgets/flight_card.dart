import 'package:flutter/material.dart';
import '../screens/flight_detail_screen.dart';

class FlightCard extends StatelessWidget {
  final Map flight;

  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final price = flight['price']['total'];
    final duration = flight['itineraries'][0]['duration'];
    final airline = flight['validatingAirlineCodes']?[0] ?? 'Desconhecida';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FlightDetailScreen(flight: flight)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Companhia: $airline',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('Duração: $duration', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                'Preço: R\$ $price',
                style: const TextStyle(fontSize: 16, color: Color(0xFF00A896)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
