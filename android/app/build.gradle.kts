plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.reddit_clone"
    compileSdk = 35 // Latest compile SDK version

    ndkVersion = "27.0.12077973" // Valid NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17" // ✅ FIXED: Set Kotlin target to match Java
    }

    defaultConfig {
        applicationId = "com.example.reddit_clone"
        minSdk = 23 // Required for Firebase
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true // Required for Firebase
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Change to your release config if available
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.4"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.android.support:multidex:1.0.3")
}

flutter {
    source = "../.."
}
