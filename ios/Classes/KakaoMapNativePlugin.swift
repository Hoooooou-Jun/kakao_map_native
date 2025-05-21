import Flutter
import UIKit
import KakaoMapsSDK

public class KakaoMapNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // MethodChannel 등록
    let channel = FlutterMethodChannel(
      name: "kakao_map_native",
      binaryMessenger: registrar.messenger()
    )
    let instance = KakaoMapNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // Platform View Factory 등록
    registrar.register(
      NativeButtonFactory(messenger: registrar.messenger()),
      withId: "native_button"
    )
      
    registrar.register(
        KakaoMapNativeFactory(messenger: registrar.messenger()),
        withId: "kakao_map"
    )
  }

  public func handle(
    _ call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
