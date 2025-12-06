import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const CALDApp());
}

class CALDApp extends StatelessWidget {
  const CALDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CALD - AI Learning Crypto (Demo)',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;

  final String htmlContent = '''
  <!doctype html>
  <html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
      body { margin:0; font-family: Arial, Helvetica, sans-serif; background: linear-gradient(135deg, #0f172a 0%, #05294a 40%, #006a6a 100%); color: #e6fff9; }
      .wrap { padding:18px; }
      h1 { font-size:20px; margin:0 0 8px 0; color:#bfffd9; }
      .card { background: rgba(255,255,255,0.04); border-radius:12px; padding:14px; margin-top:12px; }
      .price { font-size:34px; color:#9fffbf; font-weight:700; }
      .meta { color:#cfeee8; opacity:0.85; font-size:13px; }
      .footer { margin-top:16px; font-size:12px; color:#cfeee8; opacity:0.7; }
      .signal { font-weight:700; padding:8px 12px; border-radius:8px; display:inline-block; margin-top:8px;}
      .long { background: linear-gradient(90deg,#00ffd6,#00b894); color:#00221a;}
      .short { background: linear-gradient(90deg,#ff7eb6,#ff3f60); color:#33000b;}
      .neutral { background: rgba(255,255,255,0.06); color:#cfeee8; }
    </style>
  </head>
  <body>
    <div class="wrap">
      <h1>CALD — AI Learning Crypto (Demo)</h1>
      <div class="card">
        <div class="meta">Pair</div>
        <div class="price" id="price">Loading...</div>
        <div class="meta">Source: Binance public API (demo)</div>
        <div id="signal" class="signal neutral">Đang quan sát thị trường</div>
      </div>

      <div class="card">
        <div class="meta">Giải thích AI (mô phỏng)</div>
        <div id="explain">AI demo dựa trên EMA ngắn hạn; app chỉ mang tính minh họa.</div>
      </div>

      <div class="footer">Disclaimer: Demo only — không phải lời khuyên đầu tư.</div>
    </div>

    <script>
      async function fetchPrice() {
        try {
          const res = await fetch('https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT');
          const data = await res.json();
          const price = parseFloat(data.price);
          document.getElementById('price').innerText = price.toFixed(2) + ' USDT';

          // simple EMA-like demo: use last digit parity to show signal (pure demo)
          const lastDigit = Math.floor(price) % 10;
          const signalEl = document.getElementById('signal');
          const explainEl = document.getElementById('explain');
          if (lastDigit >= 7) {
            signalEl.className = 'signal long';
            signalEl.innerText = 'AI Signal: LONG (demo)';
            explainEl.innerText = 'Reason: short-term momentum positive (demo logic).';
          } else if (lastDigit <= 2) {
            signalEl.className = 'signal short';
            signalEl.innerText = 'AI Signal: SHORT (demo)';
            explainEl.innerText = 'Reason: short-term momentum negative (demo logic).';
          } else {
            signalEl.className = 'signal neutral';
            signalEl.innerText = 'AI Signal: NEUTRAL';
            explainEl.innerText = 'Reason: market unclear — remain outside (demo logic).';
          }
        } catch (e) {
          document.getElementById('price').innerText = 'Không lấy được giá';
        }
      }

      fetchPrice();
      setInterval(fetchPrice, 5000);
    </script>
  </body>
  </html>
  ''';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.dataFromString(htmlContent, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071228), Color(0xFF02394A), Color(0xFF0FB3A3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.show_chart, color: Colors.white70),
                    const SizedBox(width: 10),
                    const Text('CALD — AI Learning Crypto (Demo)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(
                      onPressed: () { _controller.reload(); },
                      icon: const Icon(Icons.refresh, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Container(
                    color: Colors.black,
                    child: WebViewWidget(controller: _controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
