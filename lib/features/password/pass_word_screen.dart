import 'dart:math';
import 'package:all_in_one_tool/features/password/password_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StrongPasswordScreen extends StatefulWidget {
  const StrongPasswordScreen({super.key});

  @override
  State<StrongPasswordScreen> createState() => _StrongPasswordScreenState();
}

class _StrongPasswordScreenState extends State<StrongPasswordScreen> {
  bool isCreatingPassword = true;
  List<String> passHistory = [];
  bool loading = false;
  PasswordSecurityReport? checkPass;

  final TextEditingController inputController = TextEditingController();
  String resultText = '';

  void createPasswordFromHint() {
    final hint = inputController.text.trim();
    if (hint.isEmpty) {
      setState(() => resultText = 'Vui lòng nhập chuỗi gợi ý');
      return;
    }

    String generatedPassword = _generateMeaningfulPassword(hint);
    setState(() {
      resultText = generatedPassword;
      passHistory.insert(0, generatedPassword);
    });
  }

  Future<void> evaluatePassword() async {
    final password = inputController.text.trim();
    if (password.isEmpty) {
      setState(() => resultText = 'Vui lòng nhập mật khẩu để kiểm tra');
      return;
    }
    setState(() {
      loading = true;
    });
    final report = await PasswordSecurityChecker.analyze(password);

    setState(() {
      checkPass = report;
      loading = false;
    });
  }

  String _generateMeaningfulPassword(String hint) {
    if (hint.isEmpty) return '';
    final random = Random();
    String password = hint;

    // --- Bước 0: Kiểm tra loại ký tự trong hint ---
    final hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*]'));

    // --- Bước 1: Xử lý hint toàn số hoặc toàn ký tự đặc biệt ---
    if (!hasLetters) {
      // Thêm ít nhất 2 chữ cái (1 thường + 1 hoa) nếu không có chữ nào
      const letters = 'abcdefghijklmnopqrstuvwxyz';
      const capitals = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      password += letters[random.nextInt(letters.length)]; // Thêm chữ thường
      password += capitals[random.nextInt(capitals.length)]; // Thêm chữ hoa
    }

    // --- Bước 2: Đảm bảo độ dài 6-8 ký tự ---
    while (password.length < 6) {
      const allChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
      password += allChars[random.nextInt(allChars.length)];
    }
    if (password.length > 8) {
      password = password.substring(0, 8);
    }

    // --- Bước 3: Leet Speak (nếu có chữ phù hợp) ---
    final leetMap = {'a': '4', 'e': '3', 'i': '1', 'o': '0', 's': '5'};
    final eligibleLeetChars = password.split('').where((c) => leetMap.containsKey(c)).toList();
    if (eligibleLeetChars.isNotEmpty) {
      final numReplacements = random.nextInt(2) + 1;
      for (var i = 0; i < min(numReplacements, eligibleLeetChars.length); i++) {
        final charToReplace = eligibleLeetChars[random.nextInt(eligibleLeetChars.length)];
        password = password.replaceFirst(charToReplace, leetMap[charToReplace]!,
            password.indexOf(charToReplace));
      }
    }

    // --- Bước 4: Đảm bảo có ít nhất 1 chữ hoa ---
    if (!password.contains(RegExp(r'[A-Z]'))) {
      final alphaChars = password.split('').where((c) => c.contains(RegExp(r'[a-z]'))).toList();
      if (alphaChars.isNotEmpty) {
        final charToUpper = alphaChars[random.nextInt(alphaChars.length)];
        final upperPos = password.indexOf(charToUpper);
        password = password.replaceRange(upperPos, upperPos + 1, charToUpper.toUpperCase());
      } else {
        // Nếu không có chữ thường (ví dụ: toàn số + ký tự đặc biệt), thêm chữ hoa ngẫu nhiên
        const capitals = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        final insertPos = random.nextInt(password.length + 1);
        password = password.substring(0, insertPos) +
            capitals[random.nextInt(capitals.length)] +
            password.substring(insertPos);
      }
    }

    // --- Bước 5: Đảm bảo có số và ký tự đặc biệt ---
    if (!password.contains(RegExp(r'[0-9]'))) {
      final insertPos = random.nextInt(password.length + 1);
      password = password.substring(0, insertPos) +
          random.nextInt(10).toString() +
          password.substring(insertPos);
    }
    if (!password.contains(RegExp(r'[!@#$%^&*]'))) {
      const specialChars = '@#\$%&!';
      final insertPos = random.nextInt(password.length + 1);
      password = password.substring(0, insertPos) +
          specialChars[random.nextInt(specialChars.length)] +
          password.substring(insertPos);
    }

    return password;
  }

  Color _getStrengthColor(double score) {
    if (score >= 8) return Colors.green;
    if (score >= 5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mật khẩu mạnh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle nút
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isCreatingPassword = true;
                        inputController.clear();
                        resultText = '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isCreatingPassword ? Colors.blue : Colors.white,
                      foregroundColor: isCreatingPassword ? Colors.white : Colors.black,
                    ),
                    child: Text('Tạo mật khẩu'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isCreatingPassword = false;
                        inputController.clear();
                        resultText = '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !isCreatingPassword ? Colors.blue : Colors.white,
                      foregroundColor: !isCreatingPassword ? Colors.white : Colors.black,
                    ),
                    child: Text('Đánh giá mật khẩu'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            if (isCreatingPassword) ...[
              TextField(
                controller: inputController,
                decoration: InputDecoration(
                  labelText: 'Nhập chuỗi gợi ý',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: createPasswordFromHint,
                child: Text('Tạo mật khẩu'),
              ),
              SizedBox(height: 10),
              if (resultText.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SelectableText(
                          resultText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: Colors.blue),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: resultText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã copy vào clipboard!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),

              if (passHistory.isNotEmpty) ...[
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: passHistory.length,
                    itemBuilder: (context, index) {
                      final pass = passHistory[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: SelectableText(
                            pass,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.copy, color: Colors.blue),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: pass));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã copy: $pass')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]
            ]
            else ...[
              TextField(
                controller: inputController,
                decoration: InputDecoration(
                  labelText: 'Nhập mật khẩu cần đánh giá',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: loading ? null : () async {
                  await evaluatePassword();
                },
                child: loading ? CircularProgressIndicator() : Text('Đánh giá'),
              ),
              SizedBox(height: 10),
              if (checkPass != null && !loading)...[
                Card(
                  margin: const EdgeInsets.only(top: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Strength bar
                        Text(
                          'Độ mạnh mật khẩu',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: checkPass!.strength / 10,
                            minHeight: 12,
                            backgroundColor: Colors.grey[300],
                            color: _getStrengthColor(checkPass!.strength),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${checkPass!.strength.toStringAsFixed(1)}/10 - ${checkPass!.strengthLevel}',
                          style: TextStyle(
                            color: _getStrengthColor(checkPass!.strength),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Leaked check
                        Row(
                          children: [
                            Icon(
                              checkPass!.isLeaked ? Icons.warning : Icons.check_circle,
                              color: checkPass!.isLeaked ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                checkPass!.isLeaked
                                    ? 'Mật khẩu đã bị rò rỉ!'
                                    : 'Không phát hiện rò rỉ',
                                style: TextStyle(
                                  color:
                                  checkPass!.isLeaked ? Colors.red : Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Common password check
                        Row(
                          children: [
                            Icon(
                              checkPass!.isCommon ? Icons.lock_open : Icons.lock,
                              color: checkPass!.isCommon ? Colors.orange : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                checkPass!.isCommon
                                    ? 'Mật khẩu thuộc danh sách phổ biến'
                                    : 'Không nằm trong danh sách mật khẩu phổ biến',
                                style: TextStyle(
                                  color:
                                  checkPass!.isCommon ? Colors.orange : Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ]
            ],
          ],
        ),
      ),
    );
  }
}
