import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../screens/payment_screen.dart';

class SeatSelectionWidget extends StatefulWidget {
  final double seatPrice;
  final Map<String, dynamic> flight;

  const SeatSelectionWidget({
    super.key,
    required this.seatPrice,
    required this.flight,
  });

  @override
  State<SeatSelectionWidget> createState() => _SeatSelectionWidgetState();
}

class _SeatSelectionWidgetState extends State<SeatSelectionWidget> {
  final List<String> selectedSeats = [];
  final List<String> occupiedSeats = ['2B', '3C', '4A'];

  final List<String> rows = ['1', '2', '3', '4', '5', '6'];
  final List<String> columns = ['A', 'B', 'C', 'D'];

  String seatPath(String type) => 'assets/svg/seat_$type.svg';

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
              onPressed: selectedSeats.isEmpty
                  ? null
                  : () async {
                final prefs = await SharedPreferences.getInstance();

                final data = {
                  'voo': widget.flight,
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
                      flight: widget.flight,
                      passenger: {},
                    ),
                  ),
                );
              },
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
    bool isOccupied = occupiedSeats.contains(id);
    bool isSelected = selectedSeats.contains(id);
    String asset;

    if (isOccupied) {
      asset = seatPath('occupied');
    } else if (isSelected) {
      asset = seatPath('selected');
    } else {
      asset = seatPath('available');
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
      child: SizedBox(
        width: 50,
        height: 50,
        child: SvgPicture.asset(asset),
      ),
    );
  }
}
