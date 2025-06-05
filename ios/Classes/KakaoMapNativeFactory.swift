import Flutter
import UIKit
import KakaoMapsSDK

public class KakaoMapNativeFactory: NSObject, FlutterPlatformViewFactory {
  let messenger: FlutterBinaryMessenger
  public init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }
  
  public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
  
  public func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    let params = args as? [String: Any]
    let mapView = KakaoMapNativeView(
      frame: frame,
      viewId: viewId,
      args: params,
      messenger: messenger
    )
    
    let channelName = "kakao_map_view_\(viewId)"
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      mapView.handleMethodCall(call, result: result)
    }
    
    KakaoMapNativePlugin.mapStates[viewId] = (view: mapView, channel: channel)

    return mapView
  }
}
