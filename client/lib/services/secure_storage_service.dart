import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> writeToken(String token) async {
    await _storage.write(key: 'jwttoken', value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: 'jwttoken');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwttoken');
  }
}
