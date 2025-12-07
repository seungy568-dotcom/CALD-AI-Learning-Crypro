import 'package:flutter/material.dart';
import 'services/price_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PriceService priceService = PriceService();
  double? price;
  bool loading = false;

  Future<void> loadPrice() async {
    setState(() => loading = true);

    final result = await priceService.getPrice("TRXUSDT");

    setState(() {
      price = result;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "AI Crypto Demo",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    price == null
                        ? "Không lấy được giá"
                        : "TRX/USDT: $price",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loadPrice,
                    child: const Text("Refresh Price"),
                  )
                ],
              ),
      ),
    );
  }
}
