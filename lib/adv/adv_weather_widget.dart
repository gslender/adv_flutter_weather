import 'dart:async';

import 'package:adv_flutter_weather/adv_flutter_weather.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_client/enums/weather_main_condition.dart';
import 'package:open_weather_client/models/coordinates.dart';
import 'package:open_weather_client/models/details.dart';
import 'package:open_weather_client/models/system.dart';
import 'package:open_weather_client/models/temperature.dart';
import 'package:open_weather_client/models/weather_conditions.dart';
import 'package:open_weather_client/models/wind.dart';
import 'package:open_weather_client/open_weather.dart';

class AdvWeatherWidget extends StatefulWidget {
  const AdvWeatherWidget(
      {super.key,
      this.advWeatherData,
      this.openWeatherMapAPIKey,
      this.openWeatherMapUpdateDuration,
      this.openWeatherMapCityName = 'London',
      this.tempScale = TempScale.celsius,
      this.dynamicBgEnabled = true})
      : assert(
            (openWeatherMapAPIKey == null && advWeatherData != null) ||
                (openWeatherMapAPIKey != null && advWeatherData == null),
            'Only one of openWeatherMapAPIKey or weatherData must be provided');
  final AdvWeatherData? advWeatherData;
  final String? openWeatherMapAPIKey;
  final String openWeatherMapCityName;
  final Duration? openWeatherMapUpdateDuration;
  final TempScale tempScale;
  final bool dynamicBgEnabled;

  @override
  State<AdvWeatherWidget> createState() => _AdvWeatherWidgetState();
}

class _AdvWeatherWidgetState extends State<AdvWeatherWidget> {
  WeatherData? weatherData;
  Timer? openWeatherMapTimer;

  Future<WeatherData> _lookupOpenWeather() async {
    OpenWeather openWeather = OpenWeather(apiKey: widget.openWeatherMapAPIKey!);
    WeatherData wd = await openWeather.currentWeatherByCityName(
      cityName: widget.openWeatherMapCityName,
      weatherUnits: _convertTempScale(widget.tempScale),
    );
    return wd;
  }

  WeatherUnits _convertTempScale(TempScale scale) {
    if (scale == TempScale.celsius) return WeatherUnits.metric;
    if (scale == TempScale.fahrenheit) return WeatherUnits.imperial;

    return WeatherUnits.standard;
  }

  @override
  void dispose() {
    if (openWeatherMapTimer != null) openWeatherMapTimer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.advWeatherData != null) {
      final DateTime now = DateTime.now();
      DateTime dateTodaySunrise = DateTime(now.year, now.month, now.day, 6);
      DateTime dateTodaySunset = DateTime(now.year, now.month, now.day, 18);
      weatherData = WeatherData(
        details: [
          Details(
              id: widget.advWeatherData!.weatherID,
              weatherShortDescription:
                  widget.advWeatherData!.weatherShortDescription,
              weatherLongDescription:
                  widget.advWeatherData!.weatherLongDescription,
              icon: '')
        ],
        temperature: Temperature(
            currentTemperature: widget.advWeatherData!.currentTemperature,
            feelsLike: widget.advWeatherData!.feelsLike,
            tempMin: widget.advWeatherData!.tempMin,
            tempMax: widget.advWeatherData!.tempMax,
            pressure: widget.advWeatherData!.pressure,
            humidity: widget.advWeatherData!.humidity),
        wind: Wind(deg: 0, speed: 0),
        coordinates: Coordinates(
          lat: widget.advWeatherData!.lat,
          lon: widget.advWeatherData!.lon,
        ),
        name: widget.advWeatherData!.cityName,
        system: System(
            country: widget.advWeatherData!.countryCode,
            sunrise: dateTodaySunrise.millisecondsSinceEpoch,
            sunset: dateTodaySunset.millisecondsSinceEpoch),
        dateTime: now,
      );
    } else {
      if (widget.openWeatherMapAPIKey != null &&
          widget.openWeatherMapUpdateDuration != null) {
        _lookupOpenWeather().then((wd) {
          weatherData = wd;
          if (mounted) setState(() {});
          if (openWeatherMapTimer != null) openWeatherMapTimer!.cancel();
          openWeatherMapTimer =
              Timer.periodic(widget.openWeatherMapUpdateDuration!, (_) {
            _lookupOpenWeather().then((wd) {
              weatherData = wd;
              if (mounted) setState(() {});
            });
          });
        });
      }
    }
  }

  Widget _buildDynamicWeatherBg(final double width, final double height) {
    if (weatherData == null) return Container();
    WeatherType? weatherBgType;
    WeatherConditions conditions = WeatherConditions(
      weatherData!.details.first.weatherShortDescription,
      weatherData!.details.first.weatherLongDescription,
      weatherData!.details.first.id,
    );

    switch (conditions.getWeatherMainCondition()) {
      case WeatherMainCondition.clear:
        weatherBgType = WeatherType.sunny;
        break;

      case WeatherMainCondition.squalls:
      case WeatherMainCondition.clouds:
        weatherBgType = WeatherType.cloudy;
        if (conditions.id == 801) weatherBgType = WeatherType.sunnyCloudy;
        break;

      case WeatherMainCondition.smoke:
      case WeatherMainCondition.haze:
        weatherBgType = WeatherType.hazy;
        break;

      case WeatherMainCondition.dust:
      case WeatherMainCondition.sand:
      case WeatherMainCondition.ash:
        weatherBgType = WeatherType.dusty;
        break;

      case WeatherMainCondition.mist:
      case WeatherMainCondition.fog:
        weatherBgType = WeatherType.foggy;
        break;

      case WeatherMainCondition.thunderstorm:
      case WeatherMainCondition.tornado:
        weatherBgType = WeatherType.storm;
        break;

      case WeatherMainCondition.snow:
        switch (conditions.id) {
          case 600: //light snow
          case 620: //Light shower snow
          case 615: //Light rain and snow
          case 612: //Light shower sleet
            weatherBgType = WeatherType.lightSnow;
            break;
          case 602: //Heavy snow
          case 622: //Heavy shower snow
          case 616: //Rain and snow
          case 621: //Shower snow
            weatherBgType = WeatherType.heavySnow;
            break;
          case 601: //Snow
          case 611: //Sleet
          case 613: //Shower sleet
          default:
            weatherBgType = WeatherType.middleSnow;
        }
        break;

      case WeatherMainCondition.rain:
      case WeatherMainCondition.drizzle:
        switch (conditions.id) {
          case 300: //light intensity drizzle
          case 301: //drizzle
          case 310: //light intensity drizzle rain
          case 311: //drizzle rain
          case 313: //shower rain and drizzle
          case 321: //shower drizzle
          case 500: //light rain
          case 520: //light intensity shower rain
            weatherBgType = WeatherType.lightRainy;
            break;
          case 502: //heavy intensity rain
          case 503: //very heavy rain
          case 504: //extreme rain
          case 522: //heavy intensity shower rain
            weatherBgType = WeatherType.heavyRainy;
            break;
          case 302: //heavy intensity drizzle
          case 312: //intensity drizzle rain
          case 314: //heavy shower rain and drizzle
          case 501: //moderate rain
          case 511: //freezing rain
          case 521: //shower rain
          case 531: //ragged shower rain
          default:
            weatherBgType = WeatherType.middleRainy;
        }
        break;
      case WeatherMainCondition.unknown:
      default:
        debugPrint('incomplete WeatherMainCondition');
    }

    if (weatherBgType == null) return Container(color: Colors.grey);

    return WeatherBg(
      width: width,
      height: height,
      weatherType: weatherBgType,
    );
  }

  Widget _buildWeatherFg(final double width, final double height) {
    if (weatherData == null) return Container();
    debugPrint(
        '${weatherData!.datetime} ${weatherData!.temperature.currentTemperature}');
    return Container(
        child: Text(weatherData!.temperature.currentTemperature.toString()));
  }

  @override
  Widget build(_) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return Stack(
          children: [
            if (widget.dynamicBgEnabled) _buildDynamicWeatherBg(width, height),
            _buildWeatherFg(width, height),
          ],
        );
      },
    );
  }
}
