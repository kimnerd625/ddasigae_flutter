class OpenWeatherService {
  final String _apiKey = dotenv.env['openWeatherApiKey']!;
  final String _baseUrl = dotenv.env['openWeatherApiBaseUrl']!;
}
