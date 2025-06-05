import UIKit
import Flutter
import KakaoMapsSDK

public class KakaoMapNativeView: NSObject, FlutterPlatformView, MapControllerDelegate {
  private let container: KMViewContainer
  private var controller: KMController?

  private var kakaoMapView: KakaoMap?
  
  private var latitude: Double
  private var longitude: Double
  private var zoomLevel: Int
  private var mapType: String
  private var overlay: String?

  public init(
    frame: CGRect,
    viewId: Int64,
    args: Any?,
    messenger: FlutterBinaryMessenger
  ) {
    // Arguments from Flutter
    let argDict = args as? [String: Any]
    
    // Initialize map size
    let width  = (argDict?["width"]  as? Double).map { CGFloat($0) } ?? frame.width
    let height = (argDict?["height"] as? Double).map { CGFloat($0) } ?? frame.height
    let mapFrame = CGRect(x: 0, y: 0, width: width, height: height)

    // Required elements for map creation
    self.latitude  = argDict?["latitude"]  as? Double ?? 37.402001
    self.longitude = argDict?["longitude"] as? Double ?? 127.108678
    self.zoomLevel = argDict?["zoomLevel"] as? Int    ?? 7
    self.mapType   = argDict?["mapType"]   as? String ?? "map"
    self.overlay   = argDict?["overlay"]   as? String

    container = KMViewContainer(frame: mapFrame)
    
    super.init()

    controller = KMController(viewContainer: container)
    controller?.delegate = self
    
    if let stateMsg = controller?.getStateDescMessage() {
      print("🗺️ KakaoMap Engine State: \(stateMsg)")
    }

    controller?.prepareEngine()
  }

  // MARK: - FlutterPlatformView
  public func view() -> UIView {
    return container
  }
  
  // MARK: - MethodCall Handler
  public func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "moveCamera":
        // Latitude and Longitude have to be required.
        guard
          let args = call.arguments as? [String: Any],
          let newLat = args["latitude"] as? Double,
          let newLon = args["longitude"] as? Double
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments for moveCamera", details: nil))
          return
        }
        guard let map = kakaoMapView else {
          result(FlutterError(code: "NOT_READY", message: "Map not ready", details: nil))
          return
        }
      
      let height: Double = {
          if let h = args["height"] as? Double {
            return h
          } else {
            return map.cameraHeight
          }
        }()

        // If the value is entered as the argument, use it, if not, use the existing value.
        let rotation: Double = {
          if let r = args["rotation"] as? Double {
            return r
          } else {
            return 0
          }
        }()

        let tilt: Double = {
          if let t = args["tilt"] as? Double {
            return t
          } else {
            return 0
          }
        }()
      
        // Moving Camera
        map.moveCamera(
          CameraUpdate.make(
            cameraPosition: CameraPosition(
              target: MapPoint(longitude: newLon, latitude: newLat),
              height: height,
              rotation: rotation,
              tilt: tilt
            )
          )
        )
      
      case "setMapType":
        guard
          let args = call.arguments as? [String: Any],
          let newType = args["mapType"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments for setMapType", details: nil))
          return
        }
        if let map = kakaoMapView {
          map.changeViewInfo(appName: "openmap", viewInfoName: newType)
          result(nil)
        } else {
          result(FlutterError(code: "NOT_READY", message: "Map is not ready yet", details: nil))
        }

      case "showOverlay":
        guard
          let args = call.arguments as? [String: Any],
          let overlayName = args["overlay"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments for showOverlay", details: nil))
          return
        }
        if let map = kakaoMapView {
          map.showOverlay(overlayName)
          result(nil)
        } else {
          result(FlutterError(code: "NOT_READY", message: "Map is not ready yet", details: nil))
        }

      case "hideOverlay":
        guard
          let args = call.arguments as? [String: Any],
          let overlayName = args["overlay"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments for hideOverlay", details: nil))
          return
        }
        if let map = kakaoMapView {
          map.hideOverlay(overlayName)
          result(nil)
        } else {
          result(FlutterError(code: "NOT_READY", message: "Map is not ready yet", details: nil))
        }

      default:
        result(FlutterMethodNotImplemented)
    }
  }
  
  // MARK: - KMControllerDelegate
  public func authenticationSucceeded() {
    controller?.activateEngine()
  }

  public func authenticationFailed(_ errorCode: Int, desc: String) {
    print("Kakao Map authentication failure code:\(errorCode), desc:\(desc)")
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      self.controller?.prepareEngine()
    }
  }

  public func addViews() {
    let defaultPosition = MapPoint(longitude: longitude, latitude: latitude)
    let mapInfo = MapviewInfo(
      viewName: "mapview",
      viewInfoName: mapType,
      defaultPosition: defaultPosition,
      defaultLevel: zoomLevel
    )
    controller?.addView(mapInfo)
  }

  public func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    print("Added map view successfully: \(viewName), \(viewInfoName)")
    if let map = controller?.getView("mapview") as? KakaoMap {
      kakaoMapView = map

      if let overlayName = overlay {
        map.showOverlay(overlayName)
      }
    }
  }

  public func containerDidResized(_ size: CGSize) {
    if let mapView = controller?.getView("mapview") as? KakaoMap {
      mapView.viewRect = CGRect(origin: .zero, size: size)
    }
  }
  
  // Allows you to temporarily use properties when you need to take them from outside.
  public var kakaoMapInstance: KakaoMap? {
    return kakaoMapView
  }
}
