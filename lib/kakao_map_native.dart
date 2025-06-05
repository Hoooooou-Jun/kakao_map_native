import 'package:flutter/widgets.dart';
import 'package:kakao_map_native/kakao_map_native_view.dart';

typedef MapType = String;     // "map" | "skyview"
typedef OverlayType = String; // "hill_shading" | "bicycle_road" | "hybrid"

class KakaoMapNative {
  static Widget buildView({
    required double width,
    required double height,
    double latitude = 37.402001,
    double longitude = 127.108678,
    int zoomLevel = 7,
    MapType mapType = "map",
    OverlayType? overlay,
    Key? key,
  }) {
    return KakaoMapNativeView(
      key: key,
      width: width,
      height: height,
      latitude: latitude,
      longitude: longitude,
      zoomLevel: zoomLevel,
      mapType: mapType,
      overlay: overlay,
    );
  }
}
