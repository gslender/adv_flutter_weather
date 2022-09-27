import 'package:flutter/material.dart';
import 'package:adv_flutter_weather/bg/weather_bg.dart';
import 'package:adv_flutter_weather/utils/weather_type.dart';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({super.key});

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("listView"),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListItemWidget(
            weatherType: WeatherType.values[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: WeatherType.values.length,
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final WeatherType weatherType;

  const ListItemWidget({Key? key, required this.weatherType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ClipPath(
        child: Stack(
          children: [
            WeatherBg(
              weatherType: weatherType,
              width: MediaQuery.of(context).size.width,
              height: 100,
            ),
            Container(
              alignment: const Alignment(-0.8, 0),
              height: 100,
              child: const Text(
                "27°c",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: const Alignment(0.8, 0),
              height: 100,
              child: Text(
                WeatherUtil.getWeatherDesc(weatherType),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        clipper: const ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
      ),
    );
  }
}
