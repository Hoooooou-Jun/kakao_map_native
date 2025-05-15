import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_map_native/kakao_map_native.dart';
import 'package:kakao_map_native/kakao_map_native_platform_interface.dart';
import 'package:kakao_map_native/kakao_map_native_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKakaoMapNativePlatform
    with MockPlatformInterfaceMixin
    implements KakaoMapNativePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KakaoMapNativePlatform initialPlatform = KakaoMapNativePlatform.instance;

  test('$MethodChannelKakaoMapNative is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKakaoMapNative>());
  });

  test('getPlatformVersion', () async {
    KakaoMapNative kakaoMapNativePlugin = KakaoMapNative();
    MockKakaoMapNativePlatform fakePlatform = MockKakaoMapNativePlatform();
    KakaoMapNativePlatform.instance = fakePlatform;

    expect(await kakaoMapNativePlugin.getPlatformVersion(), '42');
  });
}
