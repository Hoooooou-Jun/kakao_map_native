plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.joey.plugins.kakao_map_native_example"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.joey.plugins.kakao_map_native_example"
        minSdk = 23 // Require SDK Version to use Kakao Map SDK to users using plugin
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        val kakaoNativeKey: String = (project.findProperty("KAKAO_MAP_KEY") as? String)
            ?: System.getenv("KAKAO_MAP_KEY").orEmpty()

        manifestPlaceholders.apply {
            put("com.kakao.vectormap.KAKAO_MAP_KEY", kakaoNativeKey)
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}