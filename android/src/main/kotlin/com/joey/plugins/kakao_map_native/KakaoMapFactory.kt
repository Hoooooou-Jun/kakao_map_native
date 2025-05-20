package com.joey.plugins.kakao_map_native

import android.content.Context
import android.util.Log
import android.view.View
import com.kakao.vectormap.MapView
import com.kakao.vectormap.MapLifeCycleCallback
import com.kakao.vectormap.KakaoMapReadyCallback
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class KakaoMapFactory(
    private val messenger: BinaryMessenger,
    private val context: Context
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val mapView = MapView(this.context)

        Log.d("KakaoMap", "Instant creation complete $mapView")

        mapView.start(object : MapLifeCycleCallback() {
            override fun onMapDestroy() {
                /* 해제 시 처리(optional) */
            }
            override fun onMapError(error: Exception?) {
                /* 에러 처리 */
                Log.d("KakaoMap", "$error")
            }
        }, object : KakaoMapReadyCallback() {
            override fun onMapReady(kakaoMap: com.kakao.vectormap.KakaoMap) {
                Log.d("KakaoMap", "Ready to use KakaoMap")
            }
        })

        return object: PlatformView {
            override fun getView(): View = mapView
            override fun dispose() {
//                mapView.onPause()
//                mapView.onDestroy()
            }
        }
    }
}
