import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef NativeButtonCallback = void Function();

class KakaoMapView extends StatelessWidget {
  final double width;
  final double height;

  const KakaoMapView({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return const Text('Unsupported platform');
    }
    return SizedBox(
      width: width,
      height: height,
      child: AndroidView(
        viewType: 'kakao_map',
        creationParams: <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
