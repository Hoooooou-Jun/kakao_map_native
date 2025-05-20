package com.joey.plugins.kakao_map_native

import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import com.kakao.vectormap.KakaoMapSdk


class KakaoMapNativePlugin: FlutterPlugin {
  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    val context = binding.applicationContext

    val appInfo = context.packageManager
      .getApplicationInfo(context.packageName, PackageManager.GET_META_DATA)
    val metadata = appInfo.metaData
    val appKey = metadata.getString("com.kakao.vectormap.KAKAO_MAP_KEY")
      ?: error("Doesn't initialize (com.kakao.vectormap.KAKAO_MAP_KEY) at AndroidManifest.")
    Log.d("KakaoMap", "Read AppKey → $appKey")

    /* Initialize Kakao Map SDK */
    KakaoMapSdk.init(context, appKey)
    Log.d("KakaoMap", "Success to init KakaoMapSdk")

    binding.platformViewRegistry
      .registerViewFactory(
        "kakao_map", KakaoMapFactory(binding.binaryMessenger, binding.applicationContext)
      )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}
}

