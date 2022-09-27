import 'package:flutter/widgets.dart';

/// There are currently 15 types of weather
enum WeatherType {
  heavyRainy,
  heavySnow,
  middleSnow,
  storm,
  lightRainy,
  lightSnow,
  sunnyNight,
  sunny,
  cloudy,
  cloudyNight,
  middleRainy,
  overcast,
  hazy,
  foggy,
  dusty,
}

/// Data load status
enum WeatherDataState {
  init,
  loading,
  finish,
}

/// Weather-related tools category
class WeatherUtil {
  static bool isSnowRain(WeatherType weatherType) {
    return isRainy(weatherType) || isSnow(weatherType);
  }

  /// To determine whether it is raining, small to medium to
  /// large, including storms, all are types of rain
  static bool isRainy(WeatherType weatherType) {
    return weatherType == WeatherType.lightRainy ||
        weatherType == WeatherType.middleRainy ||
        weatherType == WeatherType.heavyRainy ||
        weatherType == WeatherType.storm;
  }

  /// Determining whether it is snowing or not
  static bool isSnow(WeatherType weatherType) {
    return weatherType == WeatherType.lightSnow ||
        weatherType == WeatherType.middleSnow ||
        weatherType == WeatherType.heavySnow;
  }

  // Get the color value of the background according to the weather type
  static List<Color> getColor(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return [const Color(0xFF0071C1), const Color(0xFF6DA6E4)];
      case WeatherType.sunnyNight:
        return [const Color(0xFF061E74), const Color(0xFF275E9A)];
      case WeatherType.cloudy:
        return [const Color(0xFF5C82C1), const Color(0xFF95B1DB)];
      case WeatherType.cloudyNight:
        return [const Color(0xFF2C3A60), const Color(0xFF4B6685)];
      case WeatherType.overcast:
        return [const Color(0xFF8FA3C0), const Color(0xFF8C9FB1)];
      case WeatherType.lightRainy:
        return [const Color(0xFF6989BA), const Color(0xFF9DB0CE)];
      case WeatherType.middleRainy:
        return [const Color(0xFF3A4B65), const Color(0xFF275E9A)];
      case WeatherType.heavyRainy:
        return [const Color(0xFF3B434E), const Color(0xFF565D66)];
      case WeatherType.storm:
        return [const Color(0xFF3A4B55), const Color(0xFF3A4B55)];
      case WeatherType.hazy:
        return [const Color(0xFF4B4B4B), const Color(0xFF989898)];
      case WeatherType.foggy:
        return [const Color(0xFF737F88), const Color(0xFFA6B3C2)];
      case WeatherType.lightSnow:
        return [const Color(0xFF6989BA), const Color(0xFF9DB0CE)];
      case WeatherType.middleSnow:
        return [const Color(0xFF3A4B65), const Color(0xFF95A4BF)];
      case WeatherType.heavySnow:
        return [const Color(0xFF3A4B65), const Color(0xFFA7ADBF)];
      case WeatherType.dusty:
        return [const Color(0xFFBF9447), const Color(0xFFEDBA66)];
      default:
        return [const Color(0xFF0071D1), const Color(0xFF6DA6E4)];
    }
  }

  /// Get descriptive information about the weather
  /// according to the weather type
  static String getWeatherDesc(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
      case WeatherType.sunnyNight:
        return "Sunny";
      case WeatherType.cloudy:
      case WeatherType.cloudyNight:
        return "Cloudy";
      case WeatherType.overcast:
        return "Overcast";
      case WeatherType.lightRainy:
        return "Light rain";
      case WeatherType.middleRainy:
        return "Medium rain";
      case WeatherType.heavyRainy:
        return "Heavy rain";
      case WeatherType.storm:
        return "Thunderstorm";
      case WeatherType.hazy:
        return "Haze";
      case WeatherType.foggy:
        return "Fog";
      case WeatherType.lightSnow:
        return "Light snow";
      case WeatherType.middleSnow:
        return "Medium snow";
      case WeatherType.heavySnow:
        return "Heavy snow";
      case WeatherType.dusty:
        return "Dusty";
      default:
        return "Clear";
    }
  }
}
