import 'package:flutter/material.dart';
import 'package:adv_flutter_weather/bg/weather_bg.dart';
import 'package:adv_flutter_weather/utils/weather_type.dart';

/// 主要提供两个实例
/// 1. 切换天气类型时，会有过度动画
/// 2. 动态改变宽高，绘制的相关逻辑同步发生改变
class AnimViewWidget extends StatefulWidget {
  const AnimViewWidget({super.key});

  @override
  _AnimViewWidgetState createState() => _AnimViewWidgetState();
}

class _AnimViewWidgetState extends State<AnimViewWidget> {
  WeatherType _weatherType = WeatherType.sunny;
  double _width = 100;
  double _height = 200;

  @override
  Widget build(BuildContext context) {
    var radius = 5 + (_width - 100) / 200 * 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AnimView"),
        actions: [
          PopupMenuButton<WeatherType>(
            itemBuilder: (context) {
              return <PopupMenuEntry<WeatherType>>[
                ...WeatherType.values
                    .map((e) => PopupMenuItem<WeatherType>(
                          value: e,
                          child: Text(WeatherUtil.getWeatherDesc(e)),
                        ))
                    .toList(),
              ];
            },
            initialValue: _weatherType,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(WeatherUtil.getWeatherDesc(_weatherType)),
                const Icon(Icons.more_vert)
              ],
            ),
            onSelected: (count) {
              setState(() {
                _weatherType = count;
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 7,
            margin: const EdgeInsets.only(top: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius)),
            child: ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius))),
              child: WeatherBg(
                weatherType: _weatherType,
                width: _width,
                height: _height,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
            min: 100,
            max: 300,
            label: "$_width",
            divisions: 200,
            onChanged: (value) {
              setState(() {
                _width = value;
              });
            },
            value: _width,
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
            min: 200,
            max: 600,
            label: "$_height",
            divisions: 400,
            onChanged: (value) {
              setState(() {
                _height = value;
              });
            },
            value: _height,
          )
        ],
      ),
    );
  }
}
