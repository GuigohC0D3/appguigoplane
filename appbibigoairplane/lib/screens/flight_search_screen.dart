import 'package:flutter/material.dart';
import 'flight_results_screen.dart';

class FlightSearch extends StatefulWidget {
  const FlightSearch({Key? key}) : super(key: key);

  @override
  State<FlightSearch> createState() => _FlightSearchState();
}

class _FlightSearchState extends State<FlightSearch> {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  DateTime? selectedDate;
  int passengers = 1;
  String flightClass = 'Econômica';

  void _searchFlights() {
    if (originController.text.isEmpty ||
        destinationController.text.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => FlightResultsScreen(
              origin: originController.text,
              destination: destinationController.text,
              departureDate: selectedDate!,
              passengers: passengers,
              flightClass: flightClass,
            ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Passagens'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: originController,
              decoration: const InputDecoration(
                labelText: 'Origem',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'Destino',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data da ida'),
              subtitle: Text(
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Selecionar data',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Passageiros:'),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: passengers,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => passengers = value);
                    }
                  },
                  items:
                      List.generate(10, (index) => index + 1)
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text('$e')),
                          )
                          .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Classe:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: flightClass,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => flightClass = value);
                    }
                  },
                  items:
                      ['Econômica', 'Executiva', 'Primeira Classe']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _searchFlights,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3da9fc),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Buscar Voos',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
