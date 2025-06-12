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
                override fun onMapDestroy() {}

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

        if (initialLatitude != null && initialLongitude != null && initialZoomLevel != null) {
            map.moveCamera(
                CameraUpdateFactory.newCenterPosition(
                    LatLng.from(initialLatitude, initialLongitude),
                    initialZoomLevel
                )
            )
        }

        initialMapType?.let { typeStr ->
            when (typeStr) {
                "map" -> {
                    map.changeMapViewInfo(MapViewInfo.from("openmap", MapType.NORMAL))
                }
                "skyview" -> {
                    map.changeMapViewInfo(MapViewInfo.from("openmap", MapType.SKYVIEW))
                }
                else -> {}
            }
        }

        initialOverlay?.let { overlayStr ->
            when (overlayStr) {
                "hill_shading" -> map.showOverlay(MapOverlay.HILLSHADING)
                "bicycle_road" -> map.showOverlay(MapOverlay.BICYCLE_ROAD)
                "hybrid" -> map.showOverlay(MapOverlay.SKYVIEW_HYBRID)
                else -> {}
            }
        }
    }

    override fun getView(): View? {
        return mapView
    }

    override fun dispose() {
        mapView.finish()
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
                    CameraUpdateFactory.tiltTo(Math.toRadians(newTilt.toDouble()))
                )

                map.moveCamera(
                    CameraUpdateFactory.rotateTo(Math.toRadians(newRotation.toDouble()))
                )

                result.success(null)
            }
            "setMapType" -> {
                val newMapType = call.argument<String>("mapType") ?: ""
                if (map == null) {
                    result.error("NOT_READY", "Map is not initialized", null)
                    return
                }
                val mapInstance = kakaoMap
                when (newMapType) {
                    "map" -> {
                        map.changeMapType(MapType.NORMAL)
                    }
                    "skyview" -> {
                        map.changeMapType(MapType.SKYVIEW)
                    }
                    else -> {
                        result.error("INVALID_TYPE", "Unsupported mapType: $newMapType", null)
                        return
                    }
                }
                result.success(null)
            }
            "showOverlay" -> {
                val overlayName = call.argument<String>("overlay") ?: ""
                if (map == null) {
                    result.error("NOT_READY", "Map is not initialized", null)
                    return
                }
                when (overlayName) {
                    "hill_shading" -> {
                        map.showOverlay(MapOverlay.HILLSHADING)
                    }
                    "bicycle_road" -> {
                        map.showOverlay(MapOverlay.BICYCLE_ROAD)
                    }
                    "hybrid" -> {
                        map.showOverlay(MapOverlay.SKYVIEW_HYBRID)
                    }
                    "roadview_line" -> {
                        map.showOverlay(MapOverlay.ROADVIEW_LINE)
                    }
                }
            }
            "hideOverlay" -> {
                val overlayName = call.argument<String>("overlay") ?: ""
                if (map == null) {
                    result.error("NOT_READY", "Map is not initialized", null)
                    return
                }
                when (overlayName) {
                    "hill_shading" -> {
                        map.hideOverlay(MapOverlay.HILLSHADING)
                    }
                    "bicycle_road" -> {
                        map.hideOverlay(MapOverlay.BICYCLE_ROAD)
                    }
                    "hybrid" -> {
                        map.hideOverlay(MapOverlay.SKYVIEW_HYBRID)
                    }
                    "roadview_line" -> {
                        map.hideOverlay(MapOverlay.ROADVIEW_LINE)
                    }
                    else -> {
                        result.error("INVALID_OVERLAY", "Unsupported overlay: $overlayName", null)
                        return
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
