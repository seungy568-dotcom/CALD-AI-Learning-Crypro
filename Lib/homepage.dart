import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'price_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;

  String currentPrice = "...";

  @override
  void initState() {
    super.initState();
    _loadHtml();
    _fetchPriceLoop();
  }

  void _loadHtml() {
    final html = '''
    <html>
    <head>
      <style>
        body { background:#062645; color:white; font-family:Arial; padding:20px; }
        .price { font-size:32px; margin-top:10px; }
      </style>
    </head>
    <body>
      <div>Pair: TRXUSDT</div>
      <div class="price" id="price">Đang tải...</div>
      <script>
        function updatePrice(v) {
          document.getElementById("price").innerText = v;
        }
      </script>
    </body>
    </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html);
  }

  void _fetchPriceLoop() async {
    while (mounted) {
      final price = await PriceService().fetchPrice("TRXUSDT");

      if (price != null) {
        _controller.runJavaScript('updatePrice("${price.toStringAsFixed(4)}");');
      } else {
        _controller.runJavaScript('updatePrice("Không lấy được giá");');
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03182E),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "CALD — TRXUSDT DEMO",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
