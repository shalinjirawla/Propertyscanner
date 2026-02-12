plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.app.property_scan_pro"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.app.property_scan_pro"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        missingDimensionStrategy("ffmpeg-kit", "full-gpl")
    }
//    signingConfigs {
//        create("releaseConfig") {
//                storeFile = file(project.findProperty("storeFile") as String)
//                storePassword = project.findProperty("storePassword") as String
//                keyAlias = project.findProperty("keyAlias") as String
//                keyPassword = project.findProperty("keyPassword") as String
//        }
//    }
    buildTypes {
        release {
            //signingConfig = signingConfigs.getByName("releaseConfig")
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false

        }
    }
/*    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }*/


        // aaptOptions is now androidResources in Kotlin DSL
        androidResources {
            noCompress("tflite")
            noCompress("lite")
        }
        packagingOptions {
            jniLibs {
                pickFirsts.add("lib/**/libc++_shared.so")
            }
        }
        sourceSets {
            getByName("main") {
                assets.srcDirs("src/main/assets")
            }
        }

}

flutter {
    source = "../.."
}
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.multidex:multidex:2.0.1")
}