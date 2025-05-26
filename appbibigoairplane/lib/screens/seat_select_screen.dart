import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../screens/payment_screen.dart';

class SeatSelectionWidget extends StatefulWidget {
  final double seatPrice;

  const SeatSelectionWidget({super.key, required this.seatPrice});

  @override
  State<SeatSelectionWidget> createState() => _SeatSelectionWidgetState();
}

class _SeatSelectionWidgetState extends State<SeatSelectionWidget> {
  final List<String> selectedSeats = [];
  final List<String> occupiedSeats = ['2B', '3C', '4A'];

  final List<String> rows = ['1', '2', '3', '4', '5', '6'];
  final List<String> columns = ['A', 'B', 'C', 'D'];

  Future<void> _saveLocallyAndProceed() async {
    final prefs = await SharedPreferences.getInstance();

    final voo = {
      'from': 'THE',
      'to': 'REC',
      'departureTime': '10:00',
      'arrivalTime': '12:45',
      'flightNumber': 'AZ1234',
      'boardingStart': '09:30',
      'boardingEnd': '09:55',
      'terminal': '1',
      'gate': 'N76F',
      'date': '22/12',
    };

    final data = {
      'voo': voo,
      'assentos': selectedSeats,
      'valor': selectedSeats.length * widget.seatPrice,
      'dataSelecao': DateTime.now().toIso8601String(),
    };

    await prefs.setString('ultima_reserva', jsonEncode(data));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          selectedSeats: selectedSeats,

          flight: voo,
          passenger: {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Assento'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var row in rows)
                  for (var col in columns)
                    _buildSeat('$row$col'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Selecionados: ${selectedSeats.join(', ')}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: selectedSeats.isEmpty ? null : _saveLocallyAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Confirmar Assentos', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSeat(String id) {
    final isOccupied = occupiedSeats.contains(id);
    final isSelected = selectedSeats.contains(id);

    Color bgColor;
    BorderSide border;

    if (isOccupied) {
      bgColor = Colors.red;
      border = BorderSide.none;
    } else if (isSelected) {
      bgColor = const Color(0xFF3da9fc);
      border = BorderSide.none;
    } else {
      bgColor = Colors.transparent;
      border = const BorderSide(color: Colors.grey);
    }

    return GestureDetector(
      onTap: () {
        if (isOccupied) return;

        setState(() {
          if (isSelected) {
            selectedSeats.remove(id);
          } else {
            selectedSeats.add(id);
          }
        });
      },
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(width: 2, color: border.color),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
