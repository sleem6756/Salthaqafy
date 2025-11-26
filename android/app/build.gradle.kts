plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace = "com.mmarouf.salembooks"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        coreLibraryDesugaringEnabled true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.mmarouf.salembooks"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled true
    }

    // signingConfigs {
    //     release {
    //         storeFile file("my-key.jks")
    //         storePassword project.property("storePassword")
    //         keyAlias project.property("keyAlias")
    //         keyPassword project.property("keyPassword")
    //     }
    // }

    buildTypes {
        release {
            minifyEnabled false
            shrinkResources false
            // signingConfig signingConfigs.release
        }
    }
}

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.5'
}
