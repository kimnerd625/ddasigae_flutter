import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ddasigae_flutter/services/networking.dart';

class OpenWeatherService {
  final String? _apiKey = dotenv.env['openWeatherApiKey'];
  final String? _baseUrl = dotenv.env['openWeatherApiBaseUrl'];

  Future<dynamic> getWeather(double latitude, double longitude) async {
    if (_apiKey != null && _baseUrl != null) {
      NetworkHelper networkHelper = NetworkHelper(
          '$_baseUrl?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric');

      var weatherData = await networkHelper.getData();
      return weatherData;
    } else {
      print('API key or base URL is null or empty');
      return null;
    }
  }
}
