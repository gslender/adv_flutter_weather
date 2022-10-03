import 'package:flutter/material.dart';
import 'package:adv_flutter_weather/bg/weather_bg.dart';
import 'package:adv_flutter_weather/utils/print_utils.dart';
import 'package:adv_flutter_weather/utils/weather_type.dart';

class PageViewWidget extends StatelessWidget {
  const PageViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page"),
      ),
      body: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          weatherPrint("pageView: ${MediaQuery.of(context).size}");
          return Stack(
            children: [
              WeatherBg(
                weatherType: WeatherType.values[index],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Center(
                child: Text(
                  WeatherUtil.getWeatherDesc(WeatherType.values[index]),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        },
        itemCount: WeatherType.values.length,
      ),
    );
  }
}
