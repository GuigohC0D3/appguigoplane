import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatelessWidget {
  final Map flight;
  final Map passenger;

  const SeatSelectionScreen({
    Key? key,
    required this.flight,
    required this.passenger,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar Assento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Voo: ${flight['flightNumber']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Passageiro: ${passenger['name']}",
              style: const TextStyle(fontSize: 16),
            ),
            Text("Documento: ${passenger['document']}"),
            Text("Nascimento: ${passenger['birthDate']}"),
            Text("Email: ${passenger['email']}"),
            const SizedBox(height: 24),
            const Text("Selecione seu assento abaixo (layout fictício)"),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(20, (index) {
                final seat =
                    String.fromCharCode(65 + (index ~/ 4)) +
                    ((index % 4) + 1).toString();
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                  child: Text(seat),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
