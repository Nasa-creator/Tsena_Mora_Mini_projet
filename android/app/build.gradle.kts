plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.product_versus_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.product_versus_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = "mon_alias"
            keyPassword = "Erz2820691"
            storeFile = file("keystore/mon_keystore.jks")
            storePassword = "Erz2820691"
        }
    }

    buildTypes {
        getByName("debug") {
            // Flutter gère déjà le debug, pas besoin de keystore custom
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false      // optionnel
            isShrinkResources = false    // optionnel
        }
    }
}

flutter {
    source = "../.."
}