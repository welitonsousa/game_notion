import 'package:game_notion/core/settings/twitch_credentials_store.dart';

class Env {

  static String token = '';
  static const OAUTH_CLIENT_ID = String.fromEnvironment(
    'OAUTH_CLIENT_ID',
  );

  static String get TWITCH_CLIENT_ID {
    final clientId = TwitchCredentialsStore.clientId()?.trim() ?? const String.fromEnvironment('TWITCH_CLIENT_ID');
    if (clientId != null && clientId.isNotEmpty) {
      return clientId;
    }
    throw StateError('TWITCH_CLIENT_ID is not set');
  }

  static String get TWITCH_CLIENT_SECRET {
    final clientSecret = TwitchCredentialsStore.clientSecret()?.trim() ?? const String.fromEnvironment('TWITCH_CLIENT_SECRET');
    if (clientSecret != null && clientSecret.isNotEmpty) {
      return clientSecret;
    }
    throw StateError('TWITCH_CLIENT_SECRET is not set');
  }
}
