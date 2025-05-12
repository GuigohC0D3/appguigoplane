import 'dart:convert';
import 'package:http/http.dart' as http;

class AmadeusService {
  final String apiKey = 'awV9xP3RKT8hVJsLgRhAGywAyGQsaXlt';
  final String apiSecret = '5fog47G24777TGvB';

  String? accessToken;

  // Autenticação
  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse('https://test.api.amadeus.com/v1/security/oauth2/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': apiKey,
        'client_secret': apiSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['access_token'];
    } else {
      throw Exception('Erro ao autenticar na Amadeus API: ${response.body}');
    }
  }

  // Buscar aeroportos por palavra-chave
  Future<List<dynamic>> searchAirports(String keyword) async {
    if (accessToken == null) await authenticate();

    final response = await http.get(
      Uri.parse(
        'https://test.api.amadeus.com/v1/reference-data/locations?subType=AIRPORT&keyword=$keyword',
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Erro ao buscar aeroportos: ${response.body}');
    }
  }

  // Buscar voos com origem, destino e data
  Future<List<dynamic>> searchFlights({
    required String origin,
    required String destination,
    required String departureDate,
    int adults = 1,
  }) async {
    if (accessToken == null) await authenticate();

    final url = Uri.parse(
      'https://test.api.amadeus.com/v2/shopping/flight-offers'
      '?originLocationCode=$origin'
      '&destinationLocationCode=$destination'
      '&departureDate=$departureDate'
      '&adults=$adults'
      '&currencyCode=BRL'
      '&max=10',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Erro ao buscar voos: ${response.body}');
    }
  }
}
      