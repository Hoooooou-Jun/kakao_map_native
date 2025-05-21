import UIKit
import Flutter
import KakaoMapsSDK

public class KakaoMapNativeView: NSObject, FlutterPlatformView, MapControllerDelegate {
  private let container: KMViewContainer
  private var controller: KMController?

  public init(
    frame: CGRect,
    viewId: Int64,
    args: Any?,
    messenger: FlutterBinaryMessenger
  ) {
    // Flutter 쪽에서 넘겨준 width/height
    let argDict = args as? [String: Any]
    let width = (argDict?["width"] as? Double).map { CGFloat($0) } ?? frame.width
    let height = (argDict?["height"] as? Double).map { CGFloat($0) } ?? frame.height
    let mapFrame = CGRect(x: 0, y: 0, width: width, height: height)

    container = KMViewContainer(frame: mapFrame)
    super.init()

    // KMController 생성 및 delegate 설정
    controller = KMController(viewContainer: container)
    controller?.delegate = self
    
    if let stateMsg = controller?.getStateDescMessage() {
      print("🗺️ KakaoMap Engine State: \(stateMsg)")
    }

    // 엔진 준비 (인증 + 초기화)
    controller?.prepareEngine()
  }

  public func view() -> UIView {
    return container
  }

  // MARK: - KMControllerDelegate
  
  public func authenticationSucceeded() {
    // 인증 성공 시 엔진 활성화 및 렌더링 시작
    controller?.activateEngine()
  }

  public func authenticationFailed(_ errorCode: Int, desc: String) {
    print("카카오맵 인증 실패 code:\(errorCode), desc:\(desc)")
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      self.controller?.prepareEngine()
    }
  }

  public func addViews() {
    let defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
    let mapInfo = MapviewInfo(
      viewName: "mapview",
      viewInfoName: "map",
      defaultPosition: defaultPosition,
      defaultLevel: 7
    )
    controller?.addView(mapInfo)
  }

  public func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    print("지도 뷰 추가 성공: \(viewName), \(viewInfoName)")
  }

  public func containerDidResized(_ size: CGSize) {
    if let mapView = controller?.getView("mapview") as? KakaoMap {
      mapView.viewRect = CGRect(origin: .zero, size: size)
    }
  }
}
