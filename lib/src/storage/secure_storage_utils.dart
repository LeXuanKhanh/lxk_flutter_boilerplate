import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lxk_flutter_boilerplate/src/storage/i_local_storage.dart';

class SecureStorage extends ILocalStorage {
  final storage = const FlutterSecureStorage();

  SecureStorage._();

  static final SecureStorage _instance = SecureStorage._();
  factory SecureStorage() => _instance;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  final String _keyGitHubToken = '_keyGitHubToken';

  @override
  Future<String> getGitHubToken() async {
    return await storage.read(key: _keyGitHubToken) ?? '';
  }

  @override
  Future<void> setGitHubToken(String githubToken) async {
    await storage.write(key: _keyGitHubToken, value: githubToken);
  }

  Future<void> deleteAllSecureData() async {
    await storage.deleteAll(aOptions: _getAndroidOptions());
  }
}
