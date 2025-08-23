import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom.dart';
import 'encryption_controller.dart'; // 👈 file bạn đã viết CryptoModule

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  String _selected = "AES";
  String _result = "";

  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _ivController = TextEditingController();
  final TextEditingController _publicKeyController = TextEditingController();
  final TextEditingController _privateKeyController = TextEditingController();

  final Map<String, Map<String, String>> _info = {
    "AES": {
      "id": "AES",
      "title": "AES",
      "encrypt": "Bạn nhập một đoạn chữ (hoặc dữ liệu) và nhập thêm một 'mật khẩu bí mật' + 'chuỗi mở khóa' (IV). Hệ thống sẽ trộn chúng lại để tạo ra đoạn chữ mới đã bị mã hóa.",
      "decrypt": "Để giải mã, bạn phải nhập lại đúng 'mật khẩu bí mật' và 'chuỗi mở khóa' giống như lúc mã hóa. Nếu sai thì sẽ không giải mã được.",
      "usage": "Thường dùng để giữ an toàn cho dữ liệu, ví dụ lưu trữ thông tin cá nhân hoặc gửi tin nhắn.",
    },
    "RSA": {
      "id": "RSA",
      "title": "RSA",
      "encrypt": "Bạn nhập một đoạn chữ, hệ thống sẽ dùng 'chìa khóa công khai' để khóa (mã hóa) đoạn chữ đó. Người khác có thể gửi cho bạn bản đã mã hóa.",
      "decrypt": "Bạn dùng 'chìa khóa bí mật' của riêng bạn để mở khóa (giải mã). Chỉ bạn mới có chìa khóa này.",
      "usage": "Thường dùng khi cần gửi dữ liệu an toàn cho một người cụ thể, hoặc để ký xác nhận dữ liệu.",
    },
    "Hash": {
      "id": "Hash",
      "title": "Hash (SHA-256)",
      "encrypt": "Bạn nhập một đoạn chữ, hệ thống sẽ tạo ra một chuỗi mã cố định (gọi là dấu vân tay kỹ thuật số). Chuỗi này không thể đổi ngược lại thành chữ ban đầu.",
      "decrypt": "Không thể giải mã được. Đây chỉ là một cách để tạo ra mã nhận dạng duy nhất cho dữ liệu.",
      "usage": "Thường dùng để kiểm tra xem dữ liệu có bị thay đổi hay không (ví dụ kiểm tra mật khẩu, kiểm tra file tải về).",
    },
    "CUSTOM": {
      "id": "CUSTOM",
      "title": "Tự định nghĩa",
      "encrypt": "Bạn tự định nghĩa ra 1 bảng mã hóa [Đơn giản chỉ là thay thế ký tự: VD: A -> !!!]",
      "decrypt": "Sẽ sử dụng chính bảng mã hóa do bạn định nghĩa",
      "usage": "Tùy ý chí của bạn.",
    },
  };

  void _encrypt() async {
    final text = _inputController.text;
    if (text.isEmpty) return;

    String res = "";
    try {
      if (_selected == "AES") {
        res = CryptoModule.aesEncrypt(
          text,
          _keyController.text,
          _ivController.text,
        );
      } else if (_selected == "RSA") {
        res = CryptoModule.rsaEncrypt(
          text,
          _publicKeyController.text,
        );
      } else if (_selected == "Hash") {
        res = CryptoModule.sha256(text);
      } else if(_selected == "CUSTOM"){
        res = "Đang xử lý ...";
        final rs = await CryptoModule.encode(text);
        res = rs;
      }
    } catch (e) {
      res = "Lỗi: $e";
    }

    setState(() {
      _result = res;
    });
  }

  void _decrypt() async {
    final text = _inputController.text;
    if (text.isEmpty) return;

    String res = "";
    try {
      if (_selected == "AES") {
        res = CryptoModule.aesDecrypt(
          text,
          _keyController.text,
          _ivController.text,
        );
      } else if (_selected == "RSA") {
        res = CryptoModule.rsaDecrypt(
          text,
          _privateKeyController.text,
        );
      }else if(_selected == "CUSTOM"){
        res = "Đang xử lý ...";
        final rs = await CryptoModule.decode(text);
        res = rs;
      }
      else {
        res = "Thuật toán này không có giải mã.";
      }
    } catch (e) {
      res = "Lỗi: $e";
    }

    setState(() {
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _info[_selected]!;

    return Scaffold(
      appBar: AppBar(title: const Text("Mã hóa và giải mã")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Chọn thuật toán
            const Text(
              "Chọn thuật toán:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildSelect(),

            const SizedBox(height: 20),
            // Ô nhập liệu
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nhập dữ liệu",
              ),
            ),
            const SizedBox(height: 10),

            if (_selected == "AES") ...[
              TextField(
                controller: _keyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Mật khẩu bí mật (key)",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ivController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Chuỗi mở khóa (IV)",
                ),
              ),
            ],
            if (_selected == "RSA") ...[
              TextField(
                controller: _publicKeyController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Public Key (dùng để mã hóa)",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _privateKeyController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Private Key (dùng để giải mã)",
                ),
              ),
            ],
            if(_selected == "CUSTOM")...[
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const CustomMappingDialog(),
                    );
                  },
                  child: const Text("Chỉnh sửa bảng thay thế"),
                ),
              )
            ],

            const SizedBox(height: 20),
            // Kết quả
            if (_result.isNotEmpty) ...[
              const Text("Kết quả:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(child: SelectableText(_result)),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _result));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Đã sao chép kết quả")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 10),
            Text(
              data["title"]!,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            Text("🔒 Mã hóa: ${data["encrypt"]}"),
            Text("🔑 Giải mã: ${data["decrypt"]}"),
            Text("📌 Ứng dụng: ${data["usage"]}"),
            const Divider(height: 30),
            // Nút hành động
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _encrypt,
                  child: const Text("Mã hóa"),
                ),
                ElevatedButton(
                  onPressed: _decrypt,
                  child: const Text("Giải mã"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelect(){
    return Wrap(
      children: [
        ..._info.entries.map((inf){
          return _buildOption(inf.value);
        })
      ],
    );
  }
  Widget _buildOption(Map<String, String> data) {
    final isSelected = _selected == data['id'];
    return GestureDetector(
      onTap: () => setState(() => _selected = data['id']!),
      child: Card(
        color: isSelected ? Colors.blue.shade100 : Colors.white,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(data['id']!, style: TextStyle(color: isSelected ? Colors.blue : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

}
