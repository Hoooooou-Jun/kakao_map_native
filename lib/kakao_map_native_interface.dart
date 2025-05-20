import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kakao_map_native_channel.dart';

abstract class NativeButtonPluginPlatform extends PlatformInterface {
  /// Constructs a NativeButtonPluginPlatform.
  NativeButtonPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeButtonPluginPlatform _instance = MethodChannelNativeButtonPlugin();

  /// The default instance of [NativeButtonPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeButtonPlugin].
  static NativeButtonPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeButtonPluginPlatform] when
  /// they register themselves.
  static set instance(NativeButtonPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
