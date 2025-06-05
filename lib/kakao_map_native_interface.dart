import 'package:kakao_map_native/kakao_map_native_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class KakaoMapNativeInterface extends PlatformInterface {
  KakaoMapNativeInterface() : super(token: _token);
  static final Object _token = Object();

  static KakaoMapNativeInterface _instance = MethodChannelKakaoMapNative();

  static KakaoMapNativeInterface get instance => _instance;

  static set instance(KakaoMapNativeInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> onViewCreated({required int viewId});

  Future<void> moveCamera({
    required int viewId,
    required double latitude,
    required double longitude,
    double? level,
    double? rotation,
    double? tilt,
  });

  Future<void> setMapType({
    required int viewId,
    required String mapType,
  });

  Future<void> showOverlay({
    required int viewId,
    required String overlayName,
  });

  Future<void> hideOverlay({
    required int viewId,
    required String overlayName,
  });
}
