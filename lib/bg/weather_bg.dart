import 'package:flutter/material.dart';
import '/bg/weather_cloud_bg.dart';
import '/bg/weather_color_bg.dart';
import '/bg/weather_night_star_bg.dart';
import '/bg/weather_rain_snow_bg.dart';
import 'weather_lightning_bg.dart';
import '/utils/weather_type.dart';

/// The core WeatherBg class, a collection of background & lightning
/// & rain & snow & clear nights & meteor effects
/// 1. Supports dynamic size switching
/// 2. Supports gradient overload
class WeatherBg extends StatefulWidget {
  final WeatherType weatherType;
  final double width;
  final double height;
  final double colorOpacity;
  final double cloudOpacity;

  const WeatherBg({
    Key? key,
    required this.weatherType,
    required this.width,
    required this.height,
    this.colorOpacity = 1,
    this.cloudOpacity = 1,
  }) : super(key: key);

  @override
  State<WeatherBg> createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg>
    with SingleTickerProviderStateMixin {
  WeatherType? _oldWeatherType;
  bool needChange = false;
  var state = CrossFadeState.showSecond;

  @override
  void didUpdateWidget(WeatherBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherType != oldWidget.weatherType) {
      _oldWeatherType = oldWidget.weatherType;
      needChange = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    WeatherItemBg? oldBgWidget;
    if (_oldWeatherType != null) {
      oldBgWidget = WeatherItemBg(
        weatherType: _oldWeatherType!,
        width: widget.width,
        height: widget.height,
        cloudOpacity: widget.cloudOpacity,
        colorOpacity: widget.colorOpacity,
      );
    }
    var currentBgWidget = WeatherItemBg(
      weatherType: widget.weatherType,
      width: widget.width,
      height: widget.height,
      colorOpacity: widget.colorOpacity,
      cloudOpacity: widget.cloudOpacity,
    );
    oldBgWidget ??= currentBgWidget;
    var firstWidget = currentBgWidget;
    var secondWidget = currentBgWidget;
    if (needChange) {
      if (state == CrossFadeState.showSecond) {
        state = CrossFadeState.showFirst;
        firstWidget = currentBgWidget;
        secondWidget = oldBgWidget;
      } else {
        state = CrossFadeState.showSecond;
        secondWidget = currentBgWidget;
        firstWidget = oldBgWidget;
      }
    }
    needChange = false;
    return SizeInherited(
      size: Size(widget.width, widget.height),
      child: AnimatedCrossFade(
        firstChild: firstWidget,
        secondChild: secondWidget,
        duration: const Duration(milliseconds: 300),
        crossFadeState: state,
      ),
    );
  }
}

class WeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;
  final double width;
  final double height;
  final double cloudOpacity;
  final double colorOpacity;

  const WeatherItemBg({
    Key? key,
    required this.weatherType,
    required this.width,
    required this.height,
    required this.colorOpacity,
    required this.cloudOpacity,
  }) : super(key: key);

  /// Build a clear evening background effect
  Widget _buildNightStarBg() {
    if (weatherType == WeatherType.sunnyNight) {
      return WeatherNightStarBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  /// Build a lightning stom background effect
  Widget _buildLightningBg() {
    if (weatherType == WeatherType.storm) {
      return WeatherLightningBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  /// Build a rain and snow background effect
  Widget _buildRainSnowBg() {
    if (WeatherUtil.isSnowRain(weatherType)) {
      return WeatherRainSnowBg(
        weatherType: weatherType,
        viewWidth: width,
        viewHeight: height,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            Opacity(
              opacity: colorOpacity,
              child: WeatherColorBg(weatherType: weatherType),
            ),
            Opacity(
              opacity: cloudOpacity,
              child: WeatherCloudBg(weatherType: weatherType),
            ),
            _buildRainSnowBg(),
            _buildLightningBg(),
            _buildNightStarBg(),
          ],
        ),
      ),
    );
  }
}

class SizeInherited extends InheritedWidget {
  final Size size;

  const SizeInherited({
    Key? key,
    required Widget child,
    required this.size,
  }) : super(key: key, child: child);

  static SizeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeInherited>();
  }

  @override
  bool updateShouldNotify(SizeInherited oldWidget) {
    return oldWidget.size != size;
  }
}
