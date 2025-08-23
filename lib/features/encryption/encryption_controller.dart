import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart' as crypto;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// CryptoModule hỗ trợ AES, RSA và Hash cơ bản
class CryptoModule {

  static const _key = "custom_mapping";

  /// AES Encrypt
  static String aesEncrypt(String plainText, String keyStr, String ivStr) {
    final key = encrypt.Key.fromUtf8(keyStr.padRight(32, '0').substring(0, 32)); // AES-256
    final iv = encrypt.IV.fromUtf8(ivStr.padRight(16, '0').substring(0, 16));

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return encrypted.base64;
  }

  /// AES Decrypt
  static String aesDecrypt(String encryptedText, String keyStr, String ivStr) {
    final key = encrypt.Key.fromUtf8(keyStr.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromUtf8(ivStr.padRight(16, '0').substring(0, 16));

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);

    return decrypted;
  }

  /// RSA Encrypt
  static String rsaEncrypt(String plainText, String publicKeyPem) {
    final parser = encrypt.RSAKeyParser();
    final RSAPublicKey publicKey = parser.parse(publicKeyPem) as RSAPublicKey;

    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
    final encrypted = encrypter.encrypt(plainText);

    return encrypted.base64;
  }

  /// RSA Decrypt
  static String rsaDecrypt(String encryptedText, String privateKeyPem) {
    final parser = encrypt.RSAKeyParser();
    final RSAPrivateKey privateKey = parser.parse(privateKeyPem) as RSAPrivateKey;

    final encrypter = encrypt.Encrypter(encrypt.RSA(privateKey: privateKey));
    final decrypted = encrypter.decrypt64(encryptedText);

    return decrypted;
  }

  /// SHA256 Hash
  static String sha256(String input) {
    final bytes = utf8.encode(input);
    final digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }

  static Future<String> encode(String input) async {
    final map = await _loadMapping();
    final buffer = StringBuffer();
    for (var char in input.split('')) {
      buffer.write(map[char] ?? char);
    }
    return buffer.toString();
  }

  /// Giải mã: nếu ký tự không có reverse mapping thì giữ nguyên
  static Future<String> decode(String input) async {
    final map = await _loadMapping();
    final reverseMap = {for (var e in map.entries) e.value: e.key};

    var result = input;
    reverseMap.forEach((v, k) {
      result = result.replaceAll(v, k);
    });
    return result;
  }

  /// Load mapping
  static Future<Map<String, String>> _loadMapping() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      return Map<String, String>.from(jsonDecode(saved));
    }
    return {};
  }
}

