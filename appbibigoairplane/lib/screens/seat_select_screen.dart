import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'payment_screen.dart';

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
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um assento')),
      );
      return;
    }

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
            const Text(
              'Assentos disponíveis:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, rowIndex) {
                  final row = rows[rowIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SeatBox(
                          id: '$row${columns[0]}',
                          isOccupied: occupiedSeats.contains('$row${columns[0]}'),
                          isSelected: selectedSeats.contains('$row${columns[0]}'),
                          onTap: () => _onSeatTap('$row${columns[0]}'),
                        ),
                        const SizedBox(width: 8),
                        SeatBox(
                          id: '$row${columns[1]}',
                          isOccupied: occupiedSeats.contains('$row${columns[1]}'),
                          isSelected: selectedSeats.contains('$row${columns[1]}'),
                          onTap: () => _onSeatTap('$row${columns[1]}'),
                        ),
                        const SizedBox(width: 32), // Corredor
                        SeatBox(
                          id: '$row${columns[2]}',
                          isOccupied: occupiedSeats.contains('$row${columns[2]}'),
                          isSelected: selectedSeats.contains('$row${columns[2]}'),
                          onTap: () => _onSeatTap('$row${columns[2]}'),
                        ),
                        const SizedBox(width: 8),
                        SeatBox(
                          id: '$row${columns[3]}',
                          isOccupied: occupiedSeats.contains('$row${columns[3]}'),
                          isSelected: selectedSeats.contains('$row${columns[3]}'),
                          onTap: () => _onSeatTap('$row${columns[3]}'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Selecionados: ${selectedSeats.join(', ')}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveLocallyAndProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Confirmar Assentos',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSeatTap(String id) {
    if (occupiedSeats.contains(id)) return;
    setState(() {
      if (selectedSeats.contains(id)) {
        selectedSeats.remove(id);
      } else {
        selectedSeats.add(id);
      }
    });
  }
}

class SeatBox extends StatelessWidget {
  final String id;
  final bool isOccupied;
  final bool isSelected;
  final VoidCallback onTap;

  const SeatBox({
    super.key,
    required this.id,
    required this.isOccupied,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    BorderSide border;

    if (isOccupied) {
      bgColor = Colors.red.shade400;
      border = BorderSide.none;
    } else if (isSelected) {
      bgColor = const Color(0xFF3da9fc);
      border = BorderSide.none;
    } else {
      bgColor = Colors.transparent;
      border = const BorderSide(color: Colors.grey);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(width: 2, color: border.color),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          id,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
