import 'package:flutter/material.dart';
import 'price_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? price;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPrice();
  }

  Future<void> loadPrice() async {
    try {
      final p = await PriceService().fetchPrice("TRXUSDT");
      setState(() {
        price = p;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demo Price")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Text(
                price == null ? "Không lấy được giá" : "Giá: $price",
                style: const TextStyle(fontSize: 24),
              ),
      ),
    );
  }
}
