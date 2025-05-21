import Flutter
import UIKit
import KakaoMapsSDK

public class KakaoMapNativeFactory: NSObject, FlutterPlatformViewFactory {
  let messenger: FlutterBinaryMessenger
  public init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }
  
  // dict 를 읽을 수 있도록 override
  public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
  
  
  public func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let params = args as? [String: Any]
    return KakaoMapNativeView(
      frame: frame,
      viewId: viewId,
      args: params,
      messenger: messenger
    )
  }
}
