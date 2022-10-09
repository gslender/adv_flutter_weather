import 'package:adv_flutter_weather/adv/adv_weather_data.dart';
import 'package:adv_flutter_weather/adv/adv_weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvWeatherViewWidget extends StatelessWidget {
  const AdvWeatherViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double smallBox = width / 4 - 5;
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
                child: AdvWeatherWidget(
                  openWeatherMapAPIKey: 'c4bbb94f9fcfede0eb5219111804b040',
                  openWeatherMapUpdateDuration: const Duration(seconds: 300),
                  openWeatherMapCityName: 'Noosa',
                  loadingWidget:
                      const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      const Center(child: Text('something went wrong')),
                  textStyle: GoogleFonts.acme(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: smallBox,
                    height: smallBox,
                    child: const AdvWeatherWidget(
                      openWeatherMapAPIKey: 'c4bbb94f9fcfede0eb5219111804b040',
                      openWeatherMapUpdateDuration: Duration(seconds: 300),
                      openWeatherMapCityName: 'New York',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: smallBox,
                    height: smallBox,
                    child: AdvWeatherWidget(
                      dynamicBgEnabled: true,
                      advWeatherData: AdvWeatherData(
                        cityName: 'VeryFake Named Island',
                        currentTemperature: 22,
                        feelsLike: 22.2,
                        weatherID: 203,
                        weatherShortDescription: 'Thunderstorm',
                        weatherLongDescription: 'scattered clouds: 25-50%',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
