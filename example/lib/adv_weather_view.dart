import 'package:adv_flutter_weather/adv/adv_weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:adv_flutter_weather/bg/weather_bg.dart';
import 'package:adv_flutter_weather/utils/print_utils.dart';
import 'package:adv_flutter_weather/utils/weather_type.dart';

class AdvWeatherViewWidget extends StatelessWidget {
  const AdvWeatherViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("AdvWeather"),
      ),
      body: Center(
        child: SizedBox(
          width: width / 2,
          height: width / 4,
          child: AdvWeatherWidget(
            advWeatherData: WeatherData,
          ),
        ),
      ),
    );
  }
}
