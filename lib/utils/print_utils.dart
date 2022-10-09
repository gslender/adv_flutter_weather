import 'package:flutter/foundation.dart';

/// Define print function
typedef WeatherPrint = void Function(String message,
    {int wrapWidth, String tag});

const kDebug = false;

WeatherPrint weatherPrint = _debugPrintThrottled;

// Uniform method for printing
void _debugPrintThrottled(String message, {int? wrapWidth, String? tag}) {
  if (kDebug) {
    debugPrintThrottled("adv_flutter_weather:${tag ?? ''} $message",
        wrapWidth: wrapWidth);
  }
}
