import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kakao_map_native_method_channel.dart';

abstract class KakaoMapNativePlatform extends PlatformInterface {
  /// Constructs a KakaoMapNativePlatform.
  KakaoMapNativePlatform() : super(token: _token);

  static final Object _token = Object();

  static KakaoMapNativePlatform _instance = MethodChannelKakaoMapNative();

  /// The default instance of [KakaoMapNativePlatform] to use.
  ///
  /// Defaults to [MethodChannelKakaoMapNative].
  static KakaoMapNativePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KakaoMapNativePlatform] when
  /// they register themselves.
  static set instance(KakaoMapNativePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
