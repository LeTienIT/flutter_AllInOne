import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'QrScannerScreen.dart';


class ScannerPage extends StatefulWidget {
  final ScanMode mode;
  const ScannerPage({super.key, required this.mode});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String? _result;
  late final MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: widget.mode == ScanMode.qr
          ? [BarcodeFormat.qrCode]
          : [BarcodeFormat.ean13, BarcodeFormat.upcA, BarcodeFormat.upcE],
    );
  }

  void _searchOnline(String value) async {
    final Uri url = Uri.parse(
      "https://www.google.com/search?q=${Uri.encodeComponent(value)}",
    );

    final bool launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint("Không mở được URL: $url");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == ScanMode.qr
            ? "Quét QR Code"
            : "Quét mã vạch sản phẩm"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                if (_result == null) {
                  setState(() {
                    _result = barcode.rawValue ?? "Không đọc được dữ liệu";
                  });
                  controller.stop(); // dừng scan sau khi đọc
                }
              }
            },
          ),
          if (_result != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black54,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Kết quả: $_result",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text("Tìm kiếm trên mạng"),
                      onPressed: () {
                        if (_result != null) {
                          _searchOnline(_result!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
