# Kakao Map Native Plugin

A plugin which you can use Kakao Map SDK as native functions(Android, iOS) on your Flutter project.

<br>

Just as the early version of this plugin, I'm updating this project ASAP.

<br>

If you have any question, please contact to ``jipkim2@gmail.com`` by email

<br>

# Getting Started


## 1. Initialize your Flutter project

Add this plugin to your Flutter project:

```yaml
dependencies:
  native_kakao_map_flutter_plugin:
    path: ../native_kakao_map_flutter_plugin
```

Then run:

```bash
flutter pub get
```

## 2. Android Setup

1. Add your Kakao Native key in `android/app/src/main/AndroidManifest.xml`:

   ```xml
   <application>
     <meta-data
       android:name="com.kakao.vectormap.KAKAO_MAP_KEY"
       android:value="YOUR_KAKAO_APP_KEY"/>
   </application>
   ```

  ** You have to get Kakao key before you pass this chapter.

## 3. iOS Setup

1. In your app’s `ios/Podfile`, add under the `Runner` target:

   ```ruby
   target 'Runner' do
     use_frameworks!
     flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

     pod 'KakaoMapsSDK', '2.12.5'
   end
   ```

2. Run:

   ```bash
   cd ios
   pod install
   ```

3. Add your Kakao Map app key to `ios/Runner/Info.plist`:

   ```xml
   <key>KAKAO_APP_KEY</key>
   <string>YOUR_KAKAO_APP_KEY</string>
   ```
## 4. Usage

Import and register the plugin in `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:native_kakao_map_flutter_plugin/native_kakao_map_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Kakao Map Native')),
        body: Center(
          child: SizedBox(
            width: 300,
            height: 200,
            child: KakaoMapView(
              width: 300,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
```

### Flutter API

| Widget         | Description                                                       |
| -------------- | ----------------------------------------------------------------- |
| `KakaoMapView` | Renders the native Kakao map view. Requires `width` and `height`. |

## 5. Example

See the `example/` directory for a full sample project demonstrating plugin usage on both Android and iOS.

## 6. License

BSD 3-Clause License

Copyright (c) 2025, Joey Kim
