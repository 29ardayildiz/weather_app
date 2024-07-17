import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Initialize an empty map to hold weather data.
  Map<String, dynamic> weatherData = {};

  @override
  void initState() {
    super.initState();
    // Fetch weather data when the widget initializes.
    fetchWeatherData();
  }

  // Function to fetch weather data from the OpenWeatherMap API.
  Future<void> fetchWeatherData() async {
    final response = await http
        .get(Uri.parse('*********** OPENWEATHER APİ LİNK ***************'));

    if (response.statusCode == 200) {
      // If the API call is successful, update the weatherData map with the decoded JSON response.
      setState(() {
        weatherData = jsonDecode(response.body);
      });
    } else {
      // If the API call fails, throw an exception.
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(144, 202, 249, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 130, 211, 1),
        // Display the city name in the app bar, or an empty string if not available.
        title: Text('Weather: ${weatherData['name'] ?? ''}'),
      ),
      body: Center(
        child: weatherData.isEmpty
            ? CircularProgressIndicator()
            // Display weather details using ListView when weatherData is not empty.
            : ListView(
                padding: EdgeInsets.all(16),
                children: [
                  WeatherDetailCard(
                    icon: Icons.thermostat,
                    label: 'Temperature',
                    value: '${weatherData['main']['temp']} °C',
                  ),
                  WeatherDetailCard(
                    icon: Icons.cloud,
                    label: 'Description',
                    value: '${weatherData['weather'][0]['description']}',
                  ),
                  WeatherDetailCard(
                    icon: Icons.opacity,
                    label: 'Humidity',
                    value: '${weatherData['main']['humidity']}%',
                  ),
                  WeatherDetailCard(
                    icon: Icons.wb_sunny,
                    label: 'Sunrise',
                    value: _formatTimeFromUnix(weatherData['sys']['sunrise']),
                  ),
                  WeatherDetailCard(
                    icon: Icons.brightness_3,
                    label: 'Sunset',
                    value: _formatTimeFromUnix(weatherData['sys']['sunset']),
                  ),
                  WeatherDetailCard(
                    icon: Icons.location_on,
                    label: 'Location',
                    value:
                        '${weatherData['coord']['lat']}, ${weatherData['coord']['lon']}',
                  ),
                  WeatherDetailCard(
                    icon: Icons.visibility,
                    label: 'Visibility',
                    value: '${weatherData['visibility']} meters',
                  ),
                  WeatherDetailCard(
                    icon: Icons.air,
                    label: 'Pressure',
                    value: '${weatherData['main']['pressure']} hPa',
                  ),
                  WeatherDetailCard(
                    icon: Icons.cloud_circle,
                    label: 'Cloudiness',
                    value: '${weatherData['clouds']['all']}%',
                  ),
                  WeatherDetailCard(
                    icon: Icons.speed,
                    label: 'Wind Speed',
                    value: '${weatherData['wind']['speed']} m/s',
                  ),
                ],
              ),
      ),
    );
  }

  // Function to format Unix timestamp to time string (hh:mm).
  String _formatTimeFromUnix(int unixTimestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return '${date.hour}:${date.minute}';
  }
}

// Widget to display weather details in a card format.
class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherDetailCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the weather detail label in bold.
                Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                // Display the weather detail value.
                Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
