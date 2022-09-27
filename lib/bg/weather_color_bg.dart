import 'package:flutter/material.dart';
import '/utils/weather_type.dart';

/// Color background layer
class WeatherColorBg extends StatelessWidget {
  final WeatherType weatherType;

  final double? height;

  const WeatherColorBg({Key? key, required this.weatherType, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: WeatherUtil.getColor(weatherType),
        stops: const [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
    );
  }
}
