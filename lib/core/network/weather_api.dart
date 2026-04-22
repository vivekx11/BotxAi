import 'package:dio/dio.dart';
import 'dio_client.dart';

class WeatherApi {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; // Replace with actual key
  
  final DioClient _dioClient = DioClient();
  
  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    try {
      final response = await _dioClient.get(
        '$_baseUrl/weather',
        queryParameters: {
          'q': city,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }
  
  Future<Map<String, dynamic>> getForecast(String city) async {
    try {
      final response = await _dioClient.get(
        '$_baseUrl/forecast',
        queryParameters: {
          'q': city,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch forecast data: $e');
    }
  }
  
  Future<Map<String, dynamic>> getWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final response = await _dioClient.get(
        '$_baseUrl/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'units': 'metric',
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }
  
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
  
  String getWeatherDescription(Map<String, dynamic> weatherData) {
    try {
      final temp = weatherData['main']['temp'].round();
      final description = weatherData['weather'][0]['description'];
      final city = weatherData['name'];
      return 'It\'s $temp°C in $city with $description.';
    } catch (e) {
      return 'Weather information unavailable';
    }
  }
}
