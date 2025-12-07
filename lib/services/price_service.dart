import 'dart:convert';
import 'package:http/http.dart' as http;

class PriceService {
  final String baseUrl = 'https://api.binance.com/api/v3/ticker/price';

  Future<double?> getPrice(String symbol) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?symbol=$symbol'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return double.tryParse(data['price']);
      } else {
        print('API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network error: $e');
      return null;
    }
  }
}
