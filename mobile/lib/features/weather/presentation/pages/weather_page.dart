import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/utils/helpers.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  bool _isLoading = false;
  Map<String, dynamic>? _weatherData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _weatherData = {
          'location': 'Kigali, Rwanda',
          'temperature': 24,
          'condition': 'Partly Cloudy',
          'humidity': 65,
          'windSpeed': 12,
          'precipitation': 20,
          'forecast': [
            {
              'day': 'Today',
              'high': 25,
              'low': 18,
              'condition': 'Partly Cloudy',
              'icon': Icons.wb_cloudy,
            },
            {
              'day': 'Tomorrow',
              'high': 26,
              'low': 19,
              'condition': 'Sunny',
              'icon': Icons.wb_sunny,
            },
            {
              'day': 'Saturday',
              'high': 23,
              'low': 17,
              'condition': 'Rainy',
              'icon': Icons.umbrella,
            },
            {
              'day': 'Sunday',
              'high': 24,
              'low': 18,
              'condition': 'Cloudy',
              'icon': Icons.cloud,
            },
          ],
          'alerts': [
            {
              'type': 'Rain Alert',
              'message': 'Heavy rain expected in the next 3 hours',
              'severity': 'warning',
            },
          ],
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              // TODO: Change location
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? AppErrorWidget(
                  message: _error!,
                  onRetry: _loadWeather,
                )
              : _weatherData == null
                  ? const Center(child: Text('No weather data'))
                  : RefreshIndicator(
                      onRefresh: _loadWeather,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCurrentWeather(),
                            const SizedBox(height: 24),
                            if (_weatherData!['alerts'] != null &&
                                (_weatherData!['alerts'] as List).isNotEmpty)
                              ...[
                                _buildAlerts(),
                                const SizedBox(height: 24),
                              ],
                            _buildWeatherDetails(),
                            const SizedBox(height: 24),
                            _buildForecast(),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildCurrentWeather() {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade700,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              _weatherData!['location'],
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.wb_cloudy,
              size: 80,
              color: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(height: 16),
            Text(
              '${_weatherData!['temperature']}°C',
              style: const TextStyle(
                fontSize: 56,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _weatherData!['condition'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlerts() {
    final alerts = _weatherData!['alerts'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Alerts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...alerts.map((alert) => Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert['type'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alert['message'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherDetail(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${_weatherData!['humidity']}%',
                ),
                _WeatherDetail(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${_weatherData!['windSpeed']} km/h',
                ),
                _WeatherDetail(
                  icon: Icons.umbrella,
                  label: 'Rain',
                  value: '${_weatherData!['precipitation']}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecast() {
    final forecast = _weatherData!['forecast'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4-Day Forecast',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...forecast.map((day) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        day['day'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      day['icon'],
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Text(
                        day['condition'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Text(
                      '${day['high']}° / ${day['low']}°',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
