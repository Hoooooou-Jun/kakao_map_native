import Flutter
import UIKit
import KakaoMapsSDK

public class KakaoMapNativePlugin: NSObject, FlutterPlugin {
  static var mapStates: [Int64: (view: KakaoMapNativeView, channel: FlutterMethodChannel)] = [:]

  public static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(
      KakaoMapNativeFactory(messenger: registrar.messenger()),
      withId: "kakao_map"
    )
  }
}
