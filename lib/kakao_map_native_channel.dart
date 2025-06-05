import 'package:flutter/services.dart';
import 'package:kakao_map_native/kakao_map_native_interface.dart';


class MethodChannelKakaoMapNative extends KakaoMapNativeInterface {
  MethodChannelKakaoMapNative() : super();

  @override
  Future<void> onViewCreated({required int viewId}) async {}

  MethodChannel _channelFor(int viewId) {
    return MethodChannel('kakao_map_view_$viewId');
  }

  @override
  Future<void> moveCamera({
    required int viewId,
    required double latitude,
    required double longitude,
    double? level,
    double? rotation,
    double? tilt,
  }) async {
    final channel = _channelFor(viewId);
    final args = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      if (level != null) 'level': level,
      if (rotation != null) 'rotation': rotation,
      if (tilt != null) 'tilt': tilt,
    };
    await channel.invokeMethod<void>('moveCamera', args);
  }

  @override
  Future<void> setMapType({
    required int viewId,
    required String mapType,
  }) async {
    final channel = _channelFor(viewId);
    await channel.invokeMethod<void>(
      'setMapType',
      <String, dynamic>{ 'mapType': mapType },
    );
  }

  @override
  Future<void> showOverlay({
    required int viewId,
    required String overlayName,
  }) async {
    final channel = _channelFor(viewId);
    await channel.invokeMethod<void>(
      'showOverlay',
      <String, dynamic>{ 'overlay': overlayName },
    );
  }

  @override
  Future<void> hideOverlay({
    required int viewId,
    required String overlayName,
  }) async {
    final channel = _channelFor(viewId);
    await channel.invokeMethod<void>(
      'hideOverlay',
      <String, dynamic>{ 'overlay': overlayName },
    );
  }
}
