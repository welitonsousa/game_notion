import 'package:get_storage/get_storage.dart';

class TwitchCredentialsStore {
  static const _storageKey = 'twitch_credentials';
  static const clientIdKey = 'TWITCH_CLIENT_ID';
  static const clientSecretKey = 'TWITCH_CLIENT_SECRET';
  static const docsUrl = 'https://dev.twitch.tv/console/apps';

  static String? clientId() {
    return _readValue(clientIdKey);
  }

  static String? clientSecret() {
    return _readValue(clientSecretKey);
  }

  static bool hasSavedCredentials() {
    final clientIdValue = clientId()?.trim() ?? '';
    final clientSecretValue = clientSecret()?.trim() ?? '';
    return clientIdValue.isNotEmpty && clientSecretValue.isNotEmpty;
  }

  static Future<void> save({
    required String clientId,
    required String clientSecret,
  }) async {
    await GetStorage().write(_storageKey, {
      clientIdKey: clientId.trim(),
      clientSecretKey: clientSecret.trim(),
    });
  }

  static Future<void> clear() async {
    await GetStorage().remove(_storageKey);
  }

  static String? _readValue(String key) {
    final raw = GetStorage().read(_storageKey);
    if (raw is Map) {
      final value = raw[key] ?? raw[key.toLowerCase()];
      if (value != null) {
        return value.toString();
      }
    }
    return null;
  }
}