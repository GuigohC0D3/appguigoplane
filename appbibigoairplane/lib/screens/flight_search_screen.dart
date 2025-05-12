import 'package:flutter/material.dart';
import '../services/amadeus_service.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();

  final _amadeusService = AmadeusService();
  List<dynamic> _flights = [];
  bool _loading = false;

  Future<void> _searchFlights() async {
    setState(() {
      _loading = true;
      _flights = [];
    });

    try {
      final results = await _amadeusService.searchFlights(
        origin: _originController.text.trim().toUpperCase(),
        destination: _destinationController.text.trim().toUpperCase(),
        departureDate: _dateController.text.trim(),
      );
      setState(() => _flights = results);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Voos"),
        backgroundColor: const Color(0xFF00A896),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _originController,
              decoration: const InputDecoration(labelText: "Origem (ex: GRU)"),
            ),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(labelText: "Destino (ex: GIG)"),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: "Data (YYYY-MM-DD)"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchFlights,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A896),
              ),
              child: const Text("Buscar Voos"),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : Expanded(
                  child: ListView.builder(
                    itemCount: _flights.length,
                    itemBuilder: (context, index) {
                      final flight = _flights[index];
                      final price = flight['price']['total'];
                      final airline = flight['validatingAirlineCodes']?[0];
                      final duration = flight['itineraries'][0]['duration'];
                      return Card(
                        child: ListTile(
                          title: Text("R\$ $price - $airline"),
                          subtitle: Text("Duração: $duration"),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
