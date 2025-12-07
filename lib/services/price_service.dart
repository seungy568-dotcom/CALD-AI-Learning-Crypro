import 'dart:convert';
import 'package:http/http.dart' as http;

class PriceService {
  Future<double?> fetchPrice(String symbol) async {
    final url =
        "https://api.binance.com/api/v3/ticker/price?symbol=$symbol";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data["price"]);
    }

    return null;
  }
}
