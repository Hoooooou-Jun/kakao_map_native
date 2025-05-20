import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kakao_map_native_interface.dart';

/// An implementation of [NativeButtonPluginPlatform] that uses method channels.
class MethodChannelNativeButtonPlugin extends NativeButtonPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_button_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
