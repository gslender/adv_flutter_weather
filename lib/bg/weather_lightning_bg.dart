import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '/bg/weather_bg.dart';
import '/utils/image_utils.dart';
import '/utils/print_utils.dart';
import '/utils/weather_type.dart';

class WeatherLightningBg extends StatefulWidget {
  final WeatherType weatherType;

  const WeatherLightningBg({Key? key, required this.weatherType})
      : super(key: key);

  @override
  _WeatherLightningBgState createState() => _WeatherLightningBgState();
}

class _WeatherLightningBgState extends State<WeatherLightningBg>
    with SingleTickerProviderStateMixin {
  final List<ui.Image> _images = [];
  late AnimationController _controller;
  final List<LightningParams> _lightningParams = [];
  WeatherDataState? _state;

  Future<void> fetchImages() async {
    weatherPrint("acquiring images");
    var image1 = await ImageUtils.getImage('images/lightning0.webp');
    var image2 = await ImageUtils.getImage('images/lightning1.webp');
    var image3 = await ImageUtils.getImage('images/lightning2.webp');
    var image4 = await ImageUtils.getImage('images/lightning3.webp');
    var image5 = await ImageUtils.getImage('images/lightning4.webp');
    _images.add(image1);
    _images.add(image2);
    _images.add(image3);
    _images.add(image4);
    _images.add(image5);
    weatherPrint(
        "obtained images successfully. ${_images.length} ${widget.weatherType}");
    _state = WeatherDataState.init;
    setState(() {});
  }

  @override
  void initState() {
    fetchImages();
    initAnim();
    super.initState();
  }

  void initAnim() {
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        Future.delayed(const Duration(milliseconds: 50)).then((value) {
          initLightningParams();
          _controller.forward();
        });
      }
    });

    // Construct the animation data for the first lightning bolt
    Animation _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.3,
        curve: Curves.ease,
      ),
    ));

    // Construct the animation data for the second lightning bolt
    Animation _animation1 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.2,
        0.5,
        curve: Curves.ease,
      ),
    ));

    // Construct the animation data for the third lightning bolt
    var _animation2 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.6,
        0.9,
        curve: Curves.ease,
      ),
    ));

    _animation.addListener(() {
      if (_lightningParams.isNotEmpty) {
        _lightningParams[0].alpha = _animation.value;
      }
      setState(() {});
    });

    _animation1.addListener(() {
      if (_lightningParams.isNotEmpty) {
        _lightningParams[1].alpha = _animation1.value;
      }
      setState(() {});
    });

    _animation2.addListener(() {
      if (_lightningParams.isNotEmpty) {
        _lightningParams[2].alpha = _animation2.value;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Build a ligtning storm widget
  Widget _buildWidget() {
    if (_lightningParams.isNotEmpty &&
        widget.weatherType == WeatherType.storm) {
      return CustomPaint(
        painter: LightningPainter(_lightningParams),
      );
    } else {
      return Container();
    }
  }

  void initLightningParams() {
    _state = WeatherDataState.loading;
    _lightningParams.clear();
    var size = SizeInherited.of(context)?.size;
    var width = size?.width ?? double.infinity;
    var height = size?.height ?? double.infinity;
    var widthRatio = width / 392.0;
    // Configure three lightning bolts
    for (var i = 0; i < 3; i++) {
      var param = LightningParams(
          _images[Random().nextInt(_images.length)], width, height, widthRatio);
      param.reset();
      _lightningParams.add(param);
    }
    _controller.forward();
    _state = WeatherDataState.finish;
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      initLightningParams();
    } else if (_state == WeatherDataState.finish) {
      return _buildWidget();
    }
    return Container();
  }
}

class LightningPainter extends CustomPainter {
  final _paint = Paint();
  final List<LightningParams> lightningParams;

  LightningPainter(this.lightningParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (lightningParams.isNotEmpty) {
      for (var param in lightningParams) {
        _drawLightning(param, canvas, size);
      }
    }
  }

  void _drawLightning(LightningParams params, Canvas canvas, Size size) {
    canvas.save();
    var identity = ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      params.alpha,
      0,
    ]);
    _paint.colorFilter = identity;
    canvas.scale(params.widthRatio * 1.2);
    canvas.drawImage(params.image, Offset(params.x, params.y), _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class LightningParams {
  late ui.Image image;
  late double x;
  late double y;
  late double alpha;
  int get imgWidth => image.width;
  int get imgHeight => image.height;
  final double width, height, widthRatio;

  LightningParams(this.image, this.width, this.height, this.widthRatio);

  void reset() {
    x = Random().nextDouble() * 0.5 * widthRatio - 1 / 3 * imgWidth;
    y = Random().nextDouble() * -0.05 * height;
    alpha = 0;
  }
}
