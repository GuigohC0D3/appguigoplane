import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardingPassScreen extends StatefulWidget {
  const BoardingPassScreen({super.key});

  @override
  State<BoardingPassScreen> createState() => _BoardingPassScreenState();
}

class _BoardingPassScreenState extends State<BoardingPassScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _loadReservation();
  }

  Future<void> _loadReservation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('ultima_reserva');

    if (jsonString != null) {
      setState(() {
        data = jsonDecode(jsonString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFf2f2f2),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final voo = Map<String, dynamic>.from(data!['voo'] ?? {});
    final assentos = List<String>.from(data!['assentos'] ?? []);
    final qrData = {...voo, 'assentos': assentos};
    final codigoReserva = data!['codigoReserva'] ?? '--------';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartão de Embarque'),
        backgroundColor: const Color(0xFF094067),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF0077C8),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cliente Bibigo',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reserva: $codigoReserva',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _locationInfo(
                      voo['from'] ?? '---',
                      'Origem',
                      voo['departureTime'] ?? '--:--',
                      voo['date'] ?? '--/--',
                    ),
                    Column(
                      children: [
                        const Icon(Icons.flight_takeoff, size: 24),
                        const SizedBox(height: 4),
                        Text('Voo\n${voo['flightNumber'] ?? '0000'}', textAlign: TextAlign.center),
                      ],
                    ),
                    _locationInfo(
                      voo['to'] ?? '---',
                      'Destino',
                      voo['arrivalTime'] ?? '--:--',
                      voo['date'] ?? '--/--',
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        runSpacing: 8,
                        children: [
                          _infoBlock('Início Embarque', voo['boardingStart'] ?? '--:--'),
                          _infoBlock('Fim Embarque', voo['boardingEnd'] ?? '--:--'),
                          _infoBlock('Terminal', voo['terminal'] ?? '--'),
                          _infoBlock('Portão', voo['gate'] ?? '--'),
                        ],
                      ),
                    ),
                    QrImageView(
                      data: qrData.toString(),
                      version: QrVersions.auto,
                      size: 100.0,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoBlock('Assento', assentos.isNotEmpty ? assentos.join(', ') : '--'),
                    _infoBlock('Seção', 'X'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationInfo(String code, String label, String time, String date) {
    return Column(
      children: [
        Text(code, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(date, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _infoBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
