import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:game_notion/core/settings/env.dart';

class RestClient extends DioForNative {
  RestClient() {
    options.baseUrl = 'https://api.igdb.com/v4';
  }

  Options auth() {
    return Options(
      headers: {
        'Client-ID': Env.TWITCH_CLIENT_ID,
        'Authorization': 'Bearer ${Env.token}'
      },
    );
  }
}
