import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class PasswordSecurityChecker {
  static const _pwnedApiUrl = 'https://api.pwnedpasswords.com/range/';
  static const _commonPasswordsUrl = 'https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt';

  // --- Tính độ mạnh ---
  static double _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;
    if (password.length >= 8) score += 2;
    if (password.length >= 12) score += 2;
    if (password.contains(RegExp(r'[A-Z]'))) score += 1;
    if (password.contains(RegExp(r'[a-z]'))) score += 1;
    if (password.contains(RegExp(r'[0-9]'))) score += 1;
    if (password.contains(RegExp(r'[!@#$%^&*()]'))) score += 1;

    final uniqueChars = Set.from(password.split('')).length;
    score += (uniqueChars / password.length * 2).round();

    return (score / 8 * 10).clamp(0, 10).toDouble();
  }

  // --- Kiểm tra rò rỉ (HIBP) ---
  static Future<bool> _isPasswordLeaked(String password) async {
    try {
      final hash = sha1.convert(utf8.encode(password)).toString().toUpperCase();
      final prefix = hash.substring(0, 5);
      final suffix = hash.substring(5);

      final response = await http.get(Uri.parse('$_pwnedApiUrl$prefix'));
      if (response.statusCode != 200) return false;

      return response.body
          .split('\n')
          .any((line) => line.startsWith(suffix));
    } catch (e) {
      print('Error checking leak: $e');
      return false;
    }
  }

  // --- Kiểm tra phổ biến (API GitHub raw) ---
  static Future<bool> _isCommonPassword(String password) async {
    try {
      final response = await http.get(Uri.parse(_commonPasswordsUrl));
      if (response.statusCode != 200) return false;

      final list = response.body.split('\n').map((e) => e.trim());
      return list.contains(password);
    } catch (e) {
      print('Error checking common password: $e');
      return false;
    }
  }

  // --- Phân tích toàn diện ---
  static Future<PasswordSecurityReport> analyze(String password) async {
    if (password.isEmpty) return PasswordSecurityReport.empty();

    final strength = _calculateStrength(password);

    final results = await Future.wait([
      _isPasswordLeaked(password),
      _isCommonPassword(password),
    ]);

    return PasswordSecurityReport(
      strength: strength,
      isLeaked: results[0] as bool,
      isCommon: results[1] as bool,
    );
  }
}

class PasswordSecurityReport {
  final double strength;
  final bool isLeaked;
  final bool isCommon;

  PasswordSecurityReport({
    required this.strength,
    required this.isLeaked,
    required this.isCommon,
  });

  factory PasswordSecurityReport.empty() => PasswordSecurityReport(
    strength: 0,
    isLeaked: false,
    isCommon: false,
  );

  String get strengthLevel {
    if (strength >= 8) return 'Mạnh';
    if (strength >= 5) return 'Trung bình';
    return 'Yếu';
  }

}
