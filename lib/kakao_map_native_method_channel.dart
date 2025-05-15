import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kakao_map_native_platform_interface.dart';

/// An implementation of [KakaoMapNativePlatform] that uses method channels.
class MethodChannelKakaoMapNative extends KakaoMapNativePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kakao_map_native');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
