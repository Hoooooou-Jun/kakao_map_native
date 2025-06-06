package com.joey.plugins.kakao_map_native

import android.content.Context
import android.util.Log
import android.view.View
import com.kakao.vectormap.*
import com.kakao.vectormap.camera.CameraUpdate
import com.kakao.vectormap.camera.CameraUpdateFactory
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class KakaoMapNativeView(
    messenger: BinaryMessenger,
    private val context: Context,
    private val viewId: Int,
    initialParams: Map<String, Any>
): PlatformView, MethodChannel.MethodCallHandler {
    private val mapView: MapView = MapView(context)
    private var kakaoMap: KakaoMap? = null
    private val channel: MethodChannel

    private val initialLatitude: Double? = initialParams?.get("latitude") as? Double
    private val initialLongitude: Double? = initialParams?.get("longitude") as? Double
    private val initialZoomLevel: Int? = (initialParams?.get("zoomLevel") as? Number)?.toInt()
    private val initialMapType: String? = initialParams?.get("mapType") as? String
    private val initialOverlay: String? = initialParams?.get("overlay") as? String

    init {
        channel = MethodChannel(messenger, "kakao_map_view_$viewId")
        channel.setMethodCallHandler(this)

        mapView.start(
            object : MapLifeCycleCallback() {
                override fun onMapDestroy() {
                    // mapView가 destroy될 때 호출됨
                }

                override fun onMapError(error: Exception?) {
                    Log.e("KakaoMap", "MapError: $error")
                }
            },
            object : KakaoMapReadyCallback() {
                override fun onMapReady(kMap: KakaoMap) {
                    kakaoMap = kMap
                    Log.d("KakaoMap", "onMapReady - kakaoMap: $kMap")
                    applyInitialSettings()
                }
            }
        )
    }

    private fun applyInitialSettings() {
        val map = kakaoMap ?: return

        // 1) 초기 카메라 위치 이동 (latitude, longitude, zoomLevel)
        if (initialLatitude != null && initialLongitude != null && initialZoomLevel != null) {
            map.moveCamera(
                CameraUpdateFactory.newCenterPosition(
                    LatLng.from(initialLatitude, initialLongitude),
                    initialZoomLevel
                )
            )
        }

        // 2) 초기 mapType 세팅 (“map” 또는 “skyview”)
        initialMapType?.let { typeStr ->
            when (typeStr) {
                "map" -> {
                    map.changeMapViewInfo(MapViewInfo.from("openmap", MapType.NORMAL))
                }
                "skyview" -> {
                    map.changeMapViewInfo(MapViewInfo.from("openmap", MapType.SKYVIEW))
                }
                else -> {
                    // 필요하다면 커스텀 문자열 매핑
                }
            }
        }

        // 3) 초기 overlay 세팅 (“hill_shading”, “bicycle_road”, “hybrid” 등)
        initialOverlay?.let { overlayStr ->
            when (overlayStr) {
                "hill_shading" -> map.showOverlay(MapOverlay.HILLSHADING)
                "bicycle_road" -> map.showOverlay(MapOverlay.BICYCLE_ROAD)
                "hybrid" -> map.showOverlay(MapOverlay.SKYVIEW_HYBRID)
                else -> { /* 추가 매핑이 필요하면 이곳에 */ }
            }
        }
    }

    override fun getView(): View? {
        return mapView
    }

    override fun dispose() {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val map = kakaoMap
        when (call.method) {
            "onViewCreated" -> {
                result.notImplemented()
            }
            "moveCamera" -> {
                if (map == null) {
                    result.error("NOT_READY", "Map is not ready", null)
                    return
                }

                // Flutter에서 넘겨준 위도/경도 (필수)
                val newLat = call.argument<Double>("latitude") ?: 0.0
                val newLng = call.argument<Double>("longitude") ?: 0.0

                val currentZoom = map.getZoomLevel()

                val newLevel    = call.argument<Number>("level")?.toInt() ?: currentZoom
                val newRotation = call.argument<Number>("rotation")?.toFloat() ?: 0f
                val newTilt     = call.argument<Number>("tilt")?.toFloat() ?: 0f


                map.moveCamera(
                    CameraUpdateFactory.newCenterPosition(
                        LatLng.from(newLat, newLng),
                        newLevel
                    )
                )

                map.moveCamera(
                    CameraUpdateFactory.tiltTo(Math.toRadians(newRotation.toDouble()))
                )

                map.moveCamera(
                    CameraUpdateFactory.rotateTo(Math.toRadians(newRotation.toDouble()))
                )

                result.success(null)
            }
            "setMapType" -> {
                result.notImplemented()
            }
            "showOverlay" -> {
                result.notImplemented()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

}


//        val mapView = MapView(this.context)
//
//        Log.d("KakaoMap", "Instant creation complete $mapView")
//
//        mapView.start(object : MapLifeCycleCallback() {
//            override fun onMapDestroy() {
//                /* 해제 시 처리(optional) */
//            }
//            override fun onMapError(error: Exception?) {
//                /* 에러 처리 */
//                Log.d("KakaoMap", "$error")
//            }
//        }, object : KakaoMapReadyCallback() {
//            override fun onMapReady(kakaoMap: com.kakao.vectormap.KakaoMap) {
//                Log.d("KakaoMap", "Ready to use KakaoMap")
//            }
//        })
//
//        return object: PlatformView {
//            override fun getView(): View = mapView
//            override fun dispose() {
////                mapView.onPause()
////                mapView.onDestroy()
//            }
//        }