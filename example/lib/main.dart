
import 'package:flutter/material.dart';
import 'package:kakao_map_native/kakao_map_native.dart';
import 'package:kakao_map_native/kakao_map_native_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<KakaoMapNativeViewState> _mapKey1 = GlobalKey();
  final GlobalKey<KakaoMapNativeViewState> _mapKey2 = GlobalKey();

  @override
  Widget build(BuildContext ctx) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Kakao Map Native Example')),
      body: Column(
        children: [
          SizedBox(
            width: 300,
            height: 200,
            child: KakaoMapNativeView(
              key: _mapKey1,
              width: 300,
              height: 200,
              latitude: 37.5327,
              longitude: 126.7330,
              zoomLevel: 15,
              mapType: "skyview",
              overlay: "bicycle_road",
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            height: 200,
            child: KakaoMapNativeView(
              key: _mapKey2,
              width: 300,
              height: 200,
              latitude: 37.5665,
              longitude: 126.9780,
              zoomLevel: 12,
              mapType: "map",
              overlay: null,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _mapKey1.currentState?.moveCamera(
                latitude: 37.555,
                longitude: 126.969,
                // level: 20.0,
                // rotation: 1.0,
                // tilt: 0.5,
              );
            },
            child: const Text("첫 번째 맵 이동"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await _mapKey2.currentState?.moveCamera(
                latitude: 37.570,
                longitude: 126.982,
                // level: 30.0,
                // rotation: 0.5,
                // tilt: 0.3,
              );
            },
            child: const Text("두 번째 맵 이동"),
          ),
        ],
      ),
    ),
  );
}
