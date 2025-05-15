
import 'kakao_map_native_platform_interface.dart';

class KakaoMapNative {
  Future<String?> getPlatformVersion() {
    return KakaoMapNativePlatform.instance.getPlatformVersion();
  }
}
