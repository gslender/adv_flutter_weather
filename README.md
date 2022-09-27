# adv_flutter_weather

A updated and revised version of flutter_weather_bg and flutter_weather_bg_null_safety

Original code from https://github.com/xiaweizi/flutter_weather_bg

[![Pub Version](https://img.shields.io/pub/v/adv_flutter_weather?style=plastic)](https://pub.flutter-io.cn/packages/adv_flutter_weather)

A rich and cool weather dynamic background plug-in, supporting 15 weather types.

## Features

- It supports 15 weather types: sunny, sunny evening, cloudy, cloudy evening, overcast, small to medium heavy rain, small to medium heavy snow, fog, haze, floating dust and storm
- Support dynamic scale size, adapt to multi scene display
- Supports over animation when switching weather types

## Supported platforms

- Flutter Android
- Flutter iOS
- Flutter web
- Flutter desktop

## Installation

Add  `adv_flutter_weather: ^1.0.0` to your `pubspec.yaml` dependencies. And import it:

```dar
import 'package:adv_flutter_weather/flutter_weather_bg.dart';
```

## How to use

To configure the weather type by creating `WeatherBg`, you need to pass in the width and height to complete the final display

```dart
WeatherBg(weatherType: _weatherType,width: _width,height: _height,)
```

## License

MIT
