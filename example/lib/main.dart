import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:adv_flutter_weather/bg/weather_bg.dart';
import 'package:adv_flutter_weather/utils/print_utils.dart';
import 'package:adv_flutter_weather/utils/weather_type.dart';
import '/anim_view.dart';
import '/grid_view.dart';
import '/list_view.dart';
import '/page_view.dart';

void main() {
  runApp(const MyApp());
}

const routePage = "page";
const routeList = "list";
const routeGrid = "grid";
const routeAnim = "anim";

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        routePage: (BuildContext context) {
          return const PageViewWidget();
        },
        routeList: (BuildContext context) {
          return const ListViewWidget();
        },
        routeGrid: (BuildContext context) {
          return const GridViewWidget();
        },
        routeAnim: (BuildContext context) {
          return const AnimViewWidget();
        }
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildItem(BuildContext context, String routeName, String desc,
      WeatherType weatherType) {
    double width = MediaQuery.of(context).size.width;
    double marginLeft = 10.0;
    double marginTop = 8.0;
    double itemWidth = (width - marginLeft * 4) / 2;
    double itemHeight = itemWidth * 1.5;
    var radius = 10.0;
    return SizedBox(
      width: itemWidth,
      height: itemHeight,
      child: Card(
        elevation: 7,
        margin:
            EdgeInsets.symmetric(horizontal: marginLeft, vertical: marginTop),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
          child: Stack(
            children: [
              WeatherBg(
                weatherType: WeatherType.storm,
                width: itemWidth,
                height: itemHeight,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: InkWell(
                  child: Center(
                    child: Text(
                      desc,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  onTap: () {
                    weatherPrint("name: $routeName");
                    Navigator.of(context).pushNamed(routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          children: [
            _buildItem(context, routePage, "Page", WeatherType.heavyRainy),
            _buildItem(context, routeGrid, "Grid", WeatherType.sunnyNight),
            _buildItem(context, routeList, "List", WeatherType.lightSnow),
            _buildItem(context, routeAnim, "Anim", WeatherType.sunny),
          ],
        ),
      ),
    );
  }
}
