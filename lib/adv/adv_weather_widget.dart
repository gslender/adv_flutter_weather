import 'dart:async';
import 'dart:math';

import 'package:adv_flutter_weather/adv_flutter_weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:open_weather_client/enums/weather_main_condition.dart';
import 'package:open_weather_client/models/coordinates.dart';
import 'package:open_weather_client/models/details.dart';
import 'package:open_weather_client/models/system.dart';
import 'package:open_weather_client/models/temperature.dart';
import 'package:open_weather_client/models/weather_conditions.dart';
import 'package:open_weather_client/models/wind.dart';
import 'package:open_weather_client/open_weather.dart';

class AdvWeatherWidget extends StatefulWidget {
  const AdvWeatherWidget({
    super.key,
    this.advWeatherData,
    this.openWeatherMapAPIKey,
    this.openWeatherMapUpdateDuration,
    this.openWeatherMapCityName = 'London',
    this.tempScale = TempScale.celsius,
    this.dynamicBgEnabled = true,
    this.loadingWidget,
    this.errorWidget,
    this.textStyle,
  }) : assert(
            (openWeatherMapAPIKey == null && advWeatherData != null) ||
                (openWeatherMapAPIKey != null && advWeatherData == null),
            'Only one of openWeatherMapAPIKey or weatherData must be provided');
  final AdvWeatherData? advWeatherData;
  final String? openWeatherMapAPIKey;
  final String openWeatherMapCityName;
  final Duration? openWeatherMapUpdateDuration;
  final TempScale tempScale;
  final bool dynamicBgEnabled;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final TextStyle? textStyle;

  @override
  State<AdvWeatherWidget> createState() => _AdvWeatherWidgetState();
}

class _AdvWeatherWidgetState extends State<AdvWeatherWidget> {
  WeatherData? weatherData;
  Timer? openWeatherMapTimer;
  bool isLoading = false;
  bool isError = false;
  double scale = 1;

  Future<WeatherData?> _lookupOpenWeather() async {
    try {
      OpenWeather openWeather =
          OpenWeather(apiKey: widget.openWeatherMapAPIKey!);
      WeatherData wd = await openWeather.currentWeatherByCityName(
        cityName: widget.openWeatherMapCityName,
        weatherUnits: _convertTempScale(),
      );
      return wd;
    } catch (_) {}
    isError = true;
    return null;
  }

  WeatherUnits _convertTempScale() {
    if (widget.tempScale == TempScale.celsius) return WeatherUnits.metric;
    if (widget.tempScale == TempScale.fahrenheit) return WeatherUnits.imperial;
    return WeatherUnits.standard;
  }

  String _tempSuffix() {
    if (widget.tempScale == TempScale.celsius) return '°C';
    if (widget.tempScale == TempScale.fahrenheit) return '°F';
    return '°K';
  }

  @override
  void dispose() {
    if (openWeatherMapTimer != null) openWeatherMapTimer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    if (widget.advWeatherData != null) {
      isError = true;
      try {
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
        isError = false;
      } catch (_) {}
      isLoading = false;
    } else {
      if (widget.openWeatherMapAPIKey != null &&
          widget.openWeatherMapUpdateDuration != null) {
        _lookupOpenWeather().then((wd) {
          isLoading = false;
          weatherData = wd;
          if (mounted) setState(() {});
          if (openWeatherMapTimer != null) openWeatherMapTimer!.cancel();
          openWeatherMapTimer =
              Timer.periodic(widget.openWeatherMapUpdateDuration!, (_) {
            _lookupOpenWeather().then((wd) {
              isLoading = false;
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

  double _rnd(double value, [int places = 1]) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  String _tempToString(double t) => '${_rnd(t)}${_tempSuffix()}';

  String _dateTimeToString(DateTime dt) =>
      DateFormat('EEE d MMM   h:mm a').format(dt);

  bool _textFits(TextSpan text, TextAlign textAlign, double maxWidth) {
    final textPainter = TextPainter(
      text: text,
      textAlign: textAlign,
      // textScaleFactor: scale,
      maxLines: 1,
      // locale: widget.locale,
      // strutStyle: widget.strutStyle,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    return textPainter.width < maxWidth;
  }

  Widget _textBlock(
    String str, {
    Color color = Colors.white,
    int fontSize = 12,
    TextAlign? textAlign,
    bool bold = false,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final double width = constraints.maxWidth;
      TextStyle styleCopy = (widget.textStyle ?? const TextStyle()).copyWith(
        fontSize: scale * fontSize,
        color: color,
        fontWeight: bold ? FontWeight.bold : null,
        shadows: [
          Shadow(
              blurRadius: scale,
              offset: Offset(scale / 2, scale / 2),
              color:
                  color.computeLuminance() > .4 ? Colors.black : Colors.white)
        ],
      );

      final span = TextSpan(
        style: styleCopy,
        text: str,
      );
      final bool textFits =
          _textFits(span, textAlign ?? TextAlign.start, width);

      Widget textWidget = Text(
        str,
        style: styleCopy,
        maxLines: 1,
        textAlign: textAlign,
      );

      if (!textFits) {
        textWidget = FittedBox(fit: BoxFit.fitWidth, child: textWidget);
      }
      return textWidget;
    });
  }

  Widget _buildWeatherFg(final double width, final double height) {
    double ratio = width / height;
    scale = height / 150;
    bool split = ratio >= 2;

    if (weatherData == null) return Container();
    // debugPrint(
    //     '${weatherData!.datetime} ${weatherData!.temperature.currentTemperature}');

    if (split) {
      return Padding(
        padding: EdgeInsets.all(scale * 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _textBlock(
                          _tempToString(
                              weatherData!.temperature.currentTemperature),
                          fontSize: 40),
                      _textBlock(
                        'Feels like ${_tempToString(weatherData!.temperature.feelsLike)}',
                        fontSize: 16,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _textBlock(weatherData!.name, fontSize: 32),
                      _textBlock(
                        weatherData!.details.first.weatherShortDescription,
                        fontSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _textBlock(_dateTimeToString(weatherData!.datetime), fontSize: 18),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(scale * 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _textBlock(weatherData!.name,
              fontSize: 18, textAlign: TextAlign.right),
          _textBlock(weatherData!.details.first.weatherShortDescription,
              textAlign: TextAlign.right),
          const Spacer(),
          _textBlock(_tempToString(weatherData!.temperature.currentTemperature),
              fontSize: 24, bold: true),
          _textBlock(
              'Feels like ${_tempToString(weatherData!.temperature.feelsLike)}',
              fontSize: 10),
          const Spacer(),
          _textBlock(_dateTimeToString(weatherData!.datetime),
              textAlign: TextAlign.center),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(_) {
    if (isLoading) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }
    if (isError) {
      return widget.errorWidget ?? const Center(child: Text('unknown error'));
    }
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
