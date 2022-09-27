import 'dart:ui';
// import 'dart:ui' as ui;

import 'package:flutter/services.dart';

/// Image related tools
class ImageUtils {
  /// Drawing requires the use of ui.Image object, converted by this method
  static Future<Image> getImage(String asset) async {
    ByteData data =
        await rootBundle.load("packages/adv_flutter_weather/$asset");
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
