class Env {
  static const TWITCH_CLIENT_ID = String.fromEnvironment(
    'TWITCH_CLIENT_ID',
  );
  static const TWITCH_CLIENT_SECRET = String.fromEnvironment(
    'TWITCH_CLIENT_SECRET',
  );
  static String token = '';
  static const OAUTH_CLIENT_ID = String.fromEnvironment(
    'OAUTH_CLIENT_ID',
  );
}
