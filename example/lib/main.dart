import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext ctx) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Kakao Map Native Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // KakaoMapNativeView 위젯 (초기: skyview + bicycle_road)
            const Text('지도'),
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
            const SizedBox(height: 12),

            // 기능별 테스트 버튼
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // 1. 카메라 이동 (위도/경도만)
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.moveCamera(
                      latitude: 37.555,
                      longitude: 126.969,
                    );
                  },
                  child: const Text("카메라 이동 (기본)"),
                ),

                // 2. 카메라 이동 (level + rotation + tilt 포함)
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.moveCamera(
                      latitude: 37.560,
                      longitude: 126.975,
                      level: 18.0,
                      rotation: 1.0,
                      tilt: 0.5,
                    );
                  },
                  child: const Text("카메라 이동 (레벨/회전/틸트)"),
                ),

                // 3. 맵 타입 → 일반지도
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.setMapType("map");
                  },
                  child: const Text("맵 타입: 일반지도"),
                ),

                // 4. 맵 타입 → 스카이뷰
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.setMapType("skyview");
                  },
                  child: const Text("맵 타입: 스카이뷰"),
                ),

                // 5. 오버레이 켜기: 자전거도로
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.showOverlay("bicycle_road");
                  },
                  child: const Text("오버레이 켜기: 자전거도로"),
                ),

                // 6. 오버레이 끄기: 자전거도로
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.hideOverlay("bicycle_road");
                  },
                  child: const Text("오버레이 끄기: 자전거도로"),
                ),

                // 7. 오버레이 켜기: 지형도
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.showOverlay("hill_shading");
                  },
                  child: const Text("오버레이 켜기: 지형도"),
                ),

                // 8. 오버레이 끄기: 지형도
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.hideOverlay("hill_shading");
                  },
                  child: const Text("오버레이 끄기: 지형도"),
                ),

                // 9. 오버레이 켜기: 스카이뷰 도로라인 (hybrid)
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.showOverlay("hybrid");
                  },
                  child: const Text("오버레이 켜기: 스카이뷰 도로라인"),
                ),

                // 10. 오버레이 끄기: 스카이뷰 도로라인 (hybrid)
                ElevatedButton(
                  onPressed: () async {
                    await _mapKey1.currentState?.hideOverlay("hybrid");
                  },
                  child: const Text("오버레이 끄기: 스카이뷰 도로라인"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
