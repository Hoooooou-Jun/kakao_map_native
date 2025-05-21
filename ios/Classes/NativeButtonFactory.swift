import Flutter
import UIKit

public class NativeButtonFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  public init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  // Flutter에서 UIView 요청 시 호출됩니다.
  public func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return NativeButtonView(
      frame: frame,
      viewId: viewId,
      args: args,
      messenger: messenger
    )
  }
}

