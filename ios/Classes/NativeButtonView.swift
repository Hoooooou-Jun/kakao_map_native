import Flutter
import UIKit

public class NativeButtonView: NSObject, FlutterPlatformView {
  private let button: UIButton
    

  public init(
    frame: CGRect,
    viewId: Int64,
    args: Any?,
    messenger: FlutterBinaryMessenger
  ) {
    // 1) 버튼 생성·설정
    let btn = UIButton(type: .system)
    btn.setTitle("iOS Native Button", for: .normal)
    btn.frame = frame

    // 2) 프로퍼티에 보관
    self.button = btn

    // 3) super 초기화
    super.init()

    // 4) init 이후에 self 안전 참조
    button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
  }

  public func view() -> UIView {
    return button
  }

  @objc private func onTap() {
    print("🖐️ iOS Native Button tapped!")
    // 필요하면 MethodChannel을 통해 Flutter 쪽으로 이벤트 보내기
  }
}
