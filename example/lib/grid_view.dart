import 'package:flutter/material.dart';
import 'package:adv_flutter_weather/bg/weather_bg.dart';
import 'package:adv_flutter_weather/utils/print_utils.dart';
import 'package:adv_flutter_weather/utils/weather_type.dart';

/// 已宫格的形式展示多样的天气效果
/// 同时，支持切换列数
class GridViewWidget extends StatefulWidget {
  const GridViewWidget({super.key});

  @override
  _GridViewWidgetState createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  int _count = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("GridView"),
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) {
                return <PopupMenuEntry<int>>[
                  ...[
                    1,
                    2,
                    3,
                    4,
                    5,
                  ]
                      .map((e) => PopupMenuItem<int>(
                            value: e,
                            child: Text("$e"),
                          ))
                      .toList(),
                ];
              },
              onSelected: (count) {
                setState(() {
                  _count = count;
                });
              },
            )
          ],
        ),
        body: GridView.count(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          crossAxisCount: _count,
          childAspectRatio: 1 / 2,
          children: WeatherType.values
              .map((e) => GridItemWidget(
                    weatherType: e,
                    count: _count,
                  ))
              .toList(),
        ));
  }
}

class GridItemWidget extends StatelessWidget {
  final WeatherType weatherType;
  final int count;

  const GridItemWidget(
      {Key? key, required this.weatherType, required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    weatherPrint("grid item size: ${MediaQuery.of(context).size}");
    var radius = 20.0 - 2 * count;
    var margin = 10.0 - count;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(margin),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius))),
        child: Stack(
          children: [
            WeatherBg(
              weatherType: weatherType,
              width: MediaQuery.of(context).size.width / count,
              height: MediaQuery.of(context).size.width * 2,
            ),
            Center(
              child: Text(
                WeatherUtil.getWeatherDesc(weatherType),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30 / count,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
