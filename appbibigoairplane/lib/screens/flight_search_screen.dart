import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightSearch extends StatefulWidget {
  const FlightSearch({super.key});

  @override
  State<FlightSearch> createState() => _FlightSearchState();
}

class _FlightSearchState extends State<FlightSearch> {
  final _formKey = GlobalKey<FormState>();

  final originController = TextEditingController();
  final destinationController = TextEditingController();
  DateTime? selectedDate;
  DateTime? returnDate;
  int passengers = 1;
  String flightClass = 'Econômica';

  void _searchFlights() {
    if (!_formKey.currentState!.validate() || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/flight-results',
      arguments: {
        'origin': originController.text.trim(),
        'destination': destinationController.text.trim(),
        'departureDate': selectedDate,
        'returnDate': returnDate,
        'passengers': passengers,
        'flightClass': flightClass.toUpperCase().replaceAll(' ', '_'),
      },
    );
  }

  Future<void> _selectDate({required bool isReturn}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isReturn) {
          returnDate = picked;
        } else {
          selectedDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Selecionar data';
    return DateFormat('dd/MM/yyyy').format(date);
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: originController,
                decoration: const InputDecoration(
                  labelText: 'Origem',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destino',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data da ida'),
                subtitle: Text(_formatDate(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(isReturn: false),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data da volta'),
                subtitle: Text(_formatDate(returnDate)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () => _selectDate(isReturn: true),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Passageiros:'),
                  const SizedBox(width: 12),
                  DropdownButton<int>(
                    value: passengers,
                    onChanged: (value) {
                      if (value != null) setState(() => passengers = value);
                    },
                    items: List.generate(10, (index) => index + 1)
                        .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
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
                      if (value != null) setState(() => flightClass = value);
                    },
                    items: ['Econômica', 'Executiva', 'Primeira Classe']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
      ),
    );
  }
}
