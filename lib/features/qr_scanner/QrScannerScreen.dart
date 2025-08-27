import 'package:all_in_one_tool/features/qr_scanner/scanner_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ScanMode {qr, barcode}

class QrScannerScreen extends StatefulWidget{
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreen();

}
class _QrScannerScreen extends State<QrScannerScreen>{
  ScanMode _mode = ScanMode.qr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quét mã"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: const Text("Quét QR Code"),
            leading: Radio<ScanMode>(
              value: ScanMode.qr,
              groupValue: _mode,
              onChanged: (value) {
                setState(() {
                  _mode = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text("Quét mã vạch sản phẩm"),
            leading: Radio<ScanMode>(
              value: ScanMode.barcode,
              groupValue: _mode,
              onChanged: (value) {
                setState(() {
                  _mode = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScannerPage(mode: _mode),
                ),
              );
            },
            child: const Text("Bắt đầu quét"),
          )
        ],
      ),
    );
  }

}