import 'package:flutter/material.dart';
import 'package:kakao_map_native/kakao_map_native.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Kakao Map Native')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          KakaoMapView(
            width: 300, height: 200,
          ),
        ],
      ),
    ),
  );
}
