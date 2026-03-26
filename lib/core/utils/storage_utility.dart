import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtility {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> write(dynamic key, dynamic value) async {
    await _secureStorage.write(key: key, value: value, aOptions: _getAndroidOptions());
  }

  Future<void> delete(dynamic key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  Future<dynamic> read(dynamic key) async {
    return await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
  }

  Future<bool> containsKeyInSecureStorage(dynamic key) async {
    return await _secureStorage.containsKey(key: key, aOptions: _getAndroidOptions());
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }
}