import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cancel_confirmation_screen.dart'; // Sua tela de confirmação

class BoardingPassScreen extends StatefulWidget {
  const BoardingPassScreen({super.key});

  @override
  State<BoardingPassScreen> createState() => _BoardingPassScreenState();
}

class _BoardingPassScreenState extends State<BoardingPassScreen> {
  Map<String, dynamic>? data;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _loadReservation();
  }

  Future<void> _loadReservation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('ultima_reserva');
      if (jsonString != null) {
        final decoded = jsonDecode(jsonString);
        if (decoded is Map<String, dynamic>) {
          setState(() {
            data = decoded;
          });
        } else {
          throw FormatException('Formato inválido');
        }
      } else {
        throw Exception('Reserva não encontrada');
      }
    } catch (e) {
      setState(() => isError = true);
    }
  }

  Future<void> _excluirCartao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ultima_reserva');

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const CancelConfirmationScreen(),
      ),
    );
  }

  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir o cartão de embarque?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Fecha o diálogo
              _excluirCartao();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return Scaffold(
        backgroundColor: const Color(0xFFf2f2f2),
        appBar: AppBar(
          backgroundColor: const Color(0xFF094067),
          title: const Text('Cartão de Embarque'),
        ),
        body: const Center(
          child: Text(
            'Erro ao carregar o cartão de embarque.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    if (data == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFf2f2f2),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final voo = Map<String, dynamic>.from(data!['voo'] ?? {});
    final assentos = List<String>.from(data!['assentos'] ?? []);
    final codigoReserva = data!['codigoReserva'] ?? '--------';
    final total = (data!['pagamento']?['valor'] as num?)?.toDouble() ?? 0.0;

    final qrData = jsonEncode({
      'voo': voo,
      'assentos': assentos,
      'reserva': codigoReserva,
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartão de Embarque'),
        backgroundColor: const Color(0xFF094067),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Voltar à Home',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Excluir cartão',
            onPressed: _confirmarExclusao,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFf2f2f2),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeçalho Azul
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0077C8),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cliente Bibigo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Reserva: $codigoReserva',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Origem e destino
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _locationInfo(voo['from'] ?? 'Teresina', 'Origem', voo['departureTime'] ?? '12:00', voo['date'] ?? '--/--'),
                    Column(
                      children: [
                        const Icon(Icons.flight_takeoff, size: 24),
                        const SizedBox(height: 4),
                        Text('Voo\n${voo['flightNumber'] ?? 'B4104'}', textAlign: TextAlign.center),
                      ],
                    ),
                    _locationInfo(voo['to'] ?? 'Recife', 'Destino', voo['arrivalTime'] ?? '14:39', voo['date'] ?? '--/--'),
                  ],
                ),

                const Divider(height: 32),

                // Info e QR
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        runSpacing: 10,
                        children: [
                          _infoBlock('Início Embarque', voo['boardingStart'] ?? '11:00'),
                          _infoBlock('Fim Embarque', voo['boardingEnd'] ?? '11:20'),
                          _infoBlock('Terminal', voo['terminal'] ?? '1'),
                          _infoBlock('Portão', voo['gate'] ?? 'N76F'),
                          _infoBlock('Total Pago', 'R\$ ${total.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 100.0,
                    ),
                  ],
                ),

                const Divider(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoBlock('Assento', assentos.isNotEmpty ? assentos.join(', ') : '1A'),
                    _infoBlock('Seção', 'X'),
                  ],
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationInfo(String code, String label, String time, String date) {
    return Column(
      children: [
        Text(code, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(date, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _infoBlock(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
