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

  List<Map<String, String>> _generateMockFlights() {
    return List.generate(5, (i) {
      final basePrice = 1200 + (i * 150);
      final totalPrice = basePrice * passengers;
      final originalPrice = (totalPrice * 1.15).toStringAsFixed(2);
      final pricePromo = totalPrice.toStringAsFixed(2);
      final departureHour = (8 + i).toString().padLeft(2, '0');
      final arrivalHour = (10 + i).toString().padLeft(2, '0');

      return {
        'airline': 'BibigoAirline',
        'flightNumber': 'B${4100 + i}',
        'departureTime': '$departureHour:00',
        'arrivalTime': '$arrivalHour:${35 + i}',
        'from': origin,
        'to': destination,
        'duration': '${6 + i}h ${15 + i * 5}min',
        'pricePromo': pricePromo,
        'priceOriginal': originalPrice,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final flights = _generateMockFlights();

    return Scaffold(
      backgroundColor: const Color(0xFFd8eefe),
      appBar: AppBar(
        title: const Text('Resultados da Busca'),
        backgroundColor: const Color(0xFF3da9fc),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "✈️ Oba, tem desconto no ar! A BIBIGOAIRPLANE já aplicou a promoção:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF094067),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight['departureTime'] ?? '--:--',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF094067),
                            ),
                          ),
                          Text(
                            flight['from'] ?? '---',
                            style: const TextStyle(color: Color(0xFF5f6c7b)),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Expanded(child: Divider(thickness: 1)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            flight['arrivalTime'] ?? '--:--',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF094067),
                            ),
                          ),
                          Text(
                            flight['to'] ?? '---',
                            style: const TextStyle(color: Color(0xFF5f6c7b)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Voo ${flight['flightNumber'] ?? ''} Direto",
                    style: const TextStyle(color: Color(0xFF5f6c7b)),
                  ),
                  Text(
                    "Duração: ${flight['duration'] ?? '--'}",
                    style: const TextStyle(color: Color(0xFF5f6c7b)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "De: R\$ ${flight['priceOriginal'] ?? '--'}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Por: R\$ ${flight['pricePromo'] ?? '--'}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3da9fc),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/seat-selection',
                            arguments: {
                              'flight': flight,
                              'passenger': {
                                'name': 'Usuário Teste',
                                'document': '123.456.789-00',
                                'birthDate': '1990-01-01',
                                'email': 'usuario@email.com',
                              },
                            },
                          );
                        },
                        child: const Text("Comprar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
