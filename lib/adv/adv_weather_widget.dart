import 'package:flutter/material.dart';
import 'package:open_weather_client/models/coordinates.dart';
import 'package:open_weather_client/models/details.dart';
import 'package:open_weather_client/models/temperature.dart';
import 'package:open_weather_client/models/wind.dart';
import 'package:open_weather_client/open_weather.dart';

class AdvWeatherData {
  get cityName => null;
  get lon => null;
  get lat => null;
}

class AdvWeatherWidget extends StatefulWidget {
  const AdvWeatherWidget(
      {super.key,
      this.advWeatherData,
      this.openWeatherMapAPIKey,
      this.openWeatherMapUpdateDuration,
      this.dynamicBgEnabled = true})
      : assert(
            (openWeatherMapAPIKey == null && advWeatherData != null) ||
                (openWeatherMapAPIKey != null && advWeatherData == null),
            'Only one of openWeatherMapAPIKey or weatherData must be provided');
  final AdvWeatherData? advWeatherData;
  final String? openWeatherMapAPIKey;
  final Duration? openWeatherMapUpdateDuration;
  final bool dynamicBgEnabled;

  @override
  State<AdvWeatherWidget> createState() => _AdvWeatherWidgetState();
}

class _AdvWeatherWidgetState extends State<AdvWeatherWidget> {
  WeatherData? weatherData;

  @override
  void initState() {
    super.initState();
    if (widget.advWeatherData != null) {
      weatherData = WeatherData(
        details: [
          Details(
              id: id,
              weatherShortDescription: weatherShortDescription,
              weatherLongDescription: weatherLongDescription,
              icon: icon)
        ],
        temperature: Temperature(
            currentTemperature: currentTemperature,
            feelsLike: feelsLike,
            tempMin: tempMin,
            tempMax: tempMax,
            pressure: pressure,
            humidity: humidity),
        wind: Wind(deg: 0, speed: 0),
        coordinates: Coordinates(
          lat: widget.advWeatherData!.lat,
          lon: widget.advWeatherData!.lon,
        ),
        name: widget.advWeatherData!.cityName,
        date: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
    );
  }
}
