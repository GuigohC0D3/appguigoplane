import 'package:flutter/material.dart';
import '../widgets/seat_selection_widget.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({Key? key}) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<String> selectedSeats = [];

  void _onSelectedSeatsChanged(List<String> seats) {
    setState(() {
      selectedSeats = seats;
    });
  }

  void _proceedToPayment() {
    // Lógica para prosseguir para a tela de pagamento
    // Você pode passar os assentos selecionados para a próxima tela
    print('Assentos selecionados: $selectedSeats');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção de Assentos'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Column(
        children: [
          Expanded(
            child: SeatSelectionWidget(
              onSelectedSeatsChanged: _onSelectedSeatsChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedSeats.isNotEmpty ? _proceedToPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Prosseguir para Pagamento',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
