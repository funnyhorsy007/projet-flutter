import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherInfo = "";
  String _weatherIconCode = "";
  bool _isLoading = false;

  // Use your API key securely (consider using environment variables in a real app)
  final String apiKey = "54238d324ef93f160663a5c086cdf339";

  // Mapping weather conditions to icons
  static const Map<String, String> _weatherIcons = {
    '01d': '☀️', // clear sky day
    '01n': '🌙', // clear sky night
    '02d': '🌤️', // few clouds day
    '02n': '🌤️', // few clouds night
    '03d': '☁️', // scattered clouds day
    '03n': '☁️', // scattered clouds night
    '04d': '☁️', // broken clouds day
    '04n': '☁️', // broken clouds night
    '09d': '🌧️', // shower rain day
    '09n': '🌧️', // shower rain night
    '10d': '🌦️', // rain day
    '10n': '🌦️', // rain night
    '11d': '⛈️', // thunderstorm day
    '11n': '⛈️', // thunderstorm night
    '13d': '❄️', // snow day
    '13n': '❄️', // snow night
    '50d': '🌫️', // mist day
    '50n': '🌫️', // mist night
  };

  // Improved weather fetching method with error handling
  Future<void> _getWeather() async {
    final city = _cityController.text.trim();

    if (city.isEmpty) {
      _showErrorSnackBar("Veuillez entrer une ville.");
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
      _weatherInfo = "";
      _weatherIconCode = "";
    });

    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=fr";
      final response = await http.get(Uri.parse(url));

      // Remove loading state
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherInfo = _formatWeatherInfo(data);
          _weatherIconCode = data['weather'][0]['icon'];
        });
      } else if (response.statusCode == 404) {
        _showErrorSnackBar("Ville non trouvée. Vérifiez le nom de la ville.");
      } else {
        _showErrorSnackBar("Erreur de connexion. Réessayez plus tard.");
      }
    } catch (e) {
      // Handle network errors
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(
          "Erreur de réseau. Vérifiez votre connexion internet.");
    }
  }

  // Format weather information for better readability
  String _formatWeatherInfo(Map<String, dynamic> data) {
    final temp = data['main']['temp'].toStringAsFixed(1);
    final feelsLike = data['main']['feels_like'].toStringAsFixed(1);
    final humidity = data['main']['humidity'];
    final description = data['weather'][0]['description'];
    final cityName = data['name'];
    final windSpeed = data['wind']['speed'];

    return '''Météo à $cityName
Température: $temp°C
Ressenti: $feelsLike°C
Humidité: $humidity%
Conditions: $description
Vitesse du vent: ${windSpeed.toStringAsFixed(1)} m/s''';
  }

  // Show error messages using SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application Météo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Entrez une ville',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _cityController.clear(),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _getWeather(),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _getWeather,
              icon: Icon(Icons.search),
              label: Text('Obtenir la météo'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Loading indicator
            if (_isLoading) Center(child: CircularProgressIndicator()),
            // Weather information display
            if (_weatherInfo.isNotEmpty && !_isLoading)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Display weather icon
                      Text(
                        _weatherIcons[_weatherIconCode] ?? '❓',
                        style: TextStyle(fontSize: 64),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _weatherInfo,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Dispose controller to prevent memory leaks
  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
