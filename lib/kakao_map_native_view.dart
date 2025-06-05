import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_native/kakao_map_native_interface.dart';

typedef MapType = String;     // "map" | "skyview"
typedef OverlayType = String; // "hill_shading" | "bicycle_road" | "hybrid"

class KakaoMapNativeView extends StatefulWidget {
  final double width;
  final double height;
  final double latitude;
  final double longitude;
  final int zoomLevel;
  final MapType mapType;
  final OverlayType? overlay;

  const KakaoMapNativeView({
    Key? key,
    required this.width,
    required this.height,
    this.latitude = 37.402001,
    this.longitude = 127.108678,
    this.zoomLevel = 7,
    this.mapType = "map",
    this.overlay,
  }) : super(key: key);

  @override
  KakaoMapNativeViewState createState() => KakaoMapNativeViewState();
}

class KakaoMapNativeViewState extends State<KakaoMapNativeView> {
  int? _viewId;

  @override
  Widget build(BuildContext context) {
    final initialArgs = <String, dynamic>{
      'width': widget.width,
      'height': widget.height,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
      'zoomLevel': widget.zoomLevel,
      'mapType': widget.mapType,
      if (widget.overlay != null) 'overlay': widget.overlay,
    };

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: UiKitView(
          viewType: 'kakao_map',
          creationParams: initialArgs,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: AndroidView(
          viewType: 'kakao_map',
          creationParams: initialArgs,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        ),
      );
    } else {
      return const Text('Unsupported platform');
    }
  }

  void _onPlatformViewCreated(int id) {
    _viewId = id;
    KakaoMapNativeInterface.instance.onViewCreated(viewId: id);
  }

  Future<void> moveCamera({
    required double latitude,
    required double longitude,
    double? level,
    double? rotation,
    double? tilt,
  }) async {
    if (_viewId == null) return;
    await KakaoMapNativeInterface.instance.moveCamera(
      viewId: _viewId!,
      latitude: latitude,
      longitude: longitude,
      level: level,
      rotation: rotation,
      tilt: tilt,
    );
  }

  Future<void> setMapType(String mapType) async {
    if (_viewId == null) return;
    await KakaoMapNativeInterface.instance.setMapType(
      viewId: _viewId!,
      mapType: mapType,
    );
  }

  Future<void> showOverlay(String overlayName) async {
    if (_viewId == null) return;
    await KakaoMapNativeInterface.instance.showOverlay(
      viewId: _viewId!,
      overlayName: overlayName,
    );
  }

  Future<void> hideOverlay(String overlayName) async {
    if (_viewId == null) return;
    await KakaoMapNativeInterface.instance.hideOverlay(
      viewId: _viewId!,
      overlayName: overlayName,
    );
  }

  int? get viewId => _viewId;
}
