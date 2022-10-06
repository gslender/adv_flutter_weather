import 'package:adv_flutter_weather/adv/adv_weather_data.dart';
import 'package:adv_flutter_weather/adv/adv_weather_widget.dart';
import 'package:flutter/material.dart';

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 2,
                height: width / 4,
                child: const AdvWeatherWidget(
                  openWeatherMapAPIKey: 'ab4109838be6ad200559584649b243c8',
                  openWeatherMapUpdateDuration: Duration(seconds: 300),
                  openWeatherMapCityName: 'Sydney',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: width / 2,
                height: width / 4,
                child: AdvWeatherWidget(
                  dynamicBgEnabled: true,
                  advWeatherData: AdvWeatherData(
                    cityName: 'Sunshine Beach',
                    currentTemperature: 22,
                    weatherID: 803,
                    weatherShortDescription: 'Clouds',
                    weatherLongDescription: 'scattered clouds: 25-50%',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
