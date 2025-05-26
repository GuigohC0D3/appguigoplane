import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'confirmation_screen.dart';


class PaymentScreen extends StatefulWidget {
  final List<String> selectedSeats;
  final Map flight;
  final Map passenger;

  const PaymentScreen({
    Key? key,
    required this.selectedSeats,
    required this.flight,
    required this.passenger,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = 'card';
  bool _loading = false;

  final cardController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();
  final expiryController = TextEditingController();

  bool get isCardValid {
    final name = nameController.text.trim();
    final cardNumber = cardController.text.replaceAll(RegExp(r'\D'), '');
    final cvv = cvvController.text.trim();
    final expiry = expiryController.text.trim();

    final validExpiry = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiry);
    return name.isNotEmpty &&
        RegExp(r'^\d{16}$').hasMatch(cardNumber) &&
        RegExp(r'^\d{3}$').hasMatch(cvv) &&
        validExpiry;
  }

  String getRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  double get totalAmount {
    debugPrint('🔍 Flight Data: ${widget.flight}');
    final priceValue = widget.flight['pricePromo'];
    if (priceValue is double) {
      return priceValue * widget.selectedSeats.length;
    } else if (priceValue is int) {
      return priceValue.toDouble() * widget.selectedSeats.length;
    } else if (priceValue is String) {
      final parsed = double.tryParse(priceValue);
      return (parsed ?? 0.0) * widget.selectedSeats.length;
    }
    return 0.0;
  }

  Future<void> _confirmPayment() async {
    if (_loading) return;
    if (paymentMethod == 'card' && !isCardValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos do cartão corretamente.')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final reservationCode = getRandomString(8);

      final reservationData = {
        'voo': widget.flight,
        'passageiro': widget.passenger,
        'assentos': widget.selectedSeats,
        'pagamento': {
          'metodo': paymentMethod,
          'nomeCartao': nameController.text,
          'validade': expiryController.text,
          'valor': totalAmount,
        },
        'codigoReserva': reservationCode, //
        'dataReserva': DateTime.now().toIso8601String(),
      };

      // Salva localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ultima_reserva', jsonEncode(reservationData));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            seats: widget.selectedSeats,
            total: totalAmount,
            reservationCode: reservationCode,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar o pagamento: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cardController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Número do Cartão',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: expiryController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  LengthLimitingTextInputFormatter(5),
                  _ExpiryDateInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Validade (MM/AA)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  counterText: '',
                ),
              ),
            ] else ...[
              const Text(
                'Um boleto será gerado ao confirmar o pagamento.',
                style: TextStyle(fontSize: 16),
              ),
            ],
            const Spacer(),


            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R\$ ${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: _loading ? null : _confirmPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size.fromHeight(50),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
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

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), '');
    var newText = '';
    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) newText += ' ';
      newText += text[i];
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 2) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
