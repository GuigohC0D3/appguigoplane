import 'package:flutter/material.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<String> selectedSeats;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.selectedSeats,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = 'card';

  final cardController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  void _confirmPayment() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          seats: widget.selectedSeats,
          total: widget.totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd8eefe),
      appBar: AppBar(
        title: const Text('Pagamento'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [paymentMethod == 'card', paymentMethod == 'boleto'],
              onPressed: (index) {
                setState(() {
                  paymentMethod = index == 0 ? 'card' : 'boleto';
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: const Color(0xFF3da9fc),
              color: const Color(0xFF094067),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Cartão'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Boleto'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (paymentMethod == 'card') ...[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome no Cartão'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cardController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Número do Cartão'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CVV'),
              ),
            ] else ...[
              const Text(
                'Um boleto será gerado ao confirmar o pagamento.',
                style: TextStyle(fontSize: 16),
              ),
            ],
            const Spacer(),
            Text(
              'Total: R\$ ${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _confirmPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Finalizar Pagamento',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
