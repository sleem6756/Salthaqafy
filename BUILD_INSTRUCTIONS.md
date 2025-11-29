# Althaqafy Quran App - Release Build Instructions

This document provides step-by-step instructions for building the Althaqafy Quran app for release on Google Play Store and Apple App Store.

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Android Release Build](#android-release-build)
3. [iOS Release Build](#ios-release-build)
4. [Pre-Release Checklist](#pre-release-checklist)
5. [Publishing](#publishing)

---

## Prerequisites

### General Requirements
- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: Included with Flutter
- **Git**: For version control

### Android Requirements
- **Android Studio**: Latest version with Android SDK
- **Java Development Kit (JDK)**: Version 11 or higher
- **Android SDK**: API Level 34 (Android 14)
- **Signing Key**: You'll need to create a keystore for release signing

### iOS Requirements (macOS only)
- **Xcode**: Latest version (15.0+)
- **iOS SDK**: iOS 17.0+
- **Apple Developer Account**: Required for App Store distribution
- **CocoaPods**: `gem install cocoapods`

---

## Android Release Build

### Step 1: Clean Previous Builds
```bash
flutter clean
flutter pub get
```

### Step 2: Create Signing Key (First Time Only)

**IMPORTANT**: Keep your keystore file safe! You cannot update your app without it.

```bash
keytool -genkey -v -keystore D:\ITI\Data\Freelance\Jops\projects\althaqafy\android\app\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You'll be prompted to:
- Enter a password (remember this!)
- Enter your name, organization, city, state, country
- Confirm the information

### Step 3: Configure Signing

Create a file `android/key.properties` with the following content:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

**IMPORTANT**: Add `android/key.properties` to your `.gitignore` file!

Then update `android/app/build.gradle` to include signing configuration:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // ... rest of release config
        }
    }
}
```

### Step 4: Build APK (For Testing)

```bash
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

**Size**: Approximately 40-60 MB (with obfuscation and shrinking enabled)

### Step 5: Build App Bundle (For Play Store)

**RECOMMENDED**: App bundles are the recommended format for Play Store.

```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

**Size**: Approximately 30-50 MB (smaller than APK due to dynamic delivery)

### Step 6: Test the Release Build

Install the APK on a physical device:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

**Test Checklist**:
- [ ] App launches without crashes
- [ ] Audio playback works in background
- [ ] Lock screen controls appear
- [ ] Notifications work properly
- [ ] Location permission for Qibla works
- [ ] Downloads work and are accessible offline
- [ ] No console errors or warnings

---

## iOS Release Build

### Step 1: Clean and Get Dependencies

```bash
flutter clean
flutter pub get
cd ios
pod install
pod update
cd ..
```

### Step 2: Configure Xcode Project

1. Open `ios/Runner.xcworkspace` in Xcode (NOT `.xcodeproj`)
2. Select the **Runner** project in the left sidebar
3. Go to **Signing & Capabilities** tab

#### Configure Signing:
- **Team**: Select your Apple Developer Team
- **Bundle Identifier**: `com.mmarouf.salembooks` (or your chosen identifier)
- **Signing Certificate**: Distribution certificate
- **Provisioning Profile**: App Store provisioning profile

#### Verify Capabilities:
- [ ] Background Modes: Audio enabled
- [ ] Push Notifications: Enabled (if needed)

### Step 3: Build for Release (Simulator Test)

```bash
flutter build ios --release
```

This builds the iOS app but doesn't create an IPA.

### Step 4: Build IPA for App Store

```bash
flutter build ipa --release
```

**Output**: `build/ios/ipa/althaqafy.ipa`

**Note**: This requires valid signing certificates and provisioning profiles.

### Step 5: Alternative - Build via Xcode

If the `flutter build ipa` command fails:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Any iOS Device (arm64)** as the build target
3. Go to **Product > Archive**
4. Once archiving completes, the Organizer window opens
5. Click **Distribute App**
6. Choose **App Store Connect** and follow the wizard

### Step 6: Test the Release Build

**TestFlight Testing**:
1. Upload the IPA to App Store Connect
2. Submit for Beta Review
3. Add internal/external testers
4. Install and test on real devices

**Test Checklist**:
- [ ] App launches without crashes
- [ ] Audio playback works in background
- [ ] Lock screen controls appear
- [ ] Location permission dialog appears correctly
- [ ] Downloads work and are accessible offline
- [ ] All permissions are properly requested

---

## Pre-Release Checklist

### General
- [ ] App version updated in `pubspec.yaml` (e.g., `2.1.0+3`)
- [ ] Privacy policy hosted on a public URL
- [ ] All features tested on physical devices
- [ ] No debug code or console.log statements
- [ ] App icons set for all resolutions
- [ ] Splash screen configured

### Android-Specific
- [ ] `minSdkVersion` = 24
- [ ] `targetSdkVersion` = 34
- [ ] `compileSdkVersion` = 34
- [ ] ProGuard rules tested
- [ ] App signed with release key
- [ ] Tested on Android 7.0 and Android 14 devices
- [ ] All permissions justified in Play Console

### iOS-Specific
- [ ] Minimum deployment target = iOS 13.0
- [ ] All privacy descriptions added to Info.plist
- [ ] Background audio mode enabled
- [ ] App Transport Security configured
- [ ] Tested on iOS 13 and iOS 17 devices
- [ ] Valid certificates and provisioning profiles

### Store Listings
- [ ] App name: "Althaqafy - القرآن الكريم"
- [ ] Short description (80 characters)
- [ ] Full description (4000 characters max)
- [ ] Screenshots (Android: 5-8, iOS: 5-10)
- [ ] Feature graphic (Android only)
- [ ] Privacy policy URL
- [ ] Contact email
- [ ] Category: Books & Reference / Education
- [ ] Content rating: Everyone

---

## Publishing

### Google Play Store

1. **Create Google Play Developer Account** ($25 one-time fee)
2. **Go to Play Console**: https://play.google.com/console
3. **Create New App**:
   - App name: Althaqafy
   - Default language: Arabic
   - App/Game: App
   - Free/Paid: Free
4. **Complete Store Listing**:
   - Upload screenshots
   - Add descriptions
   - Set content rating
   - Add privacy policy URL
5. **Upload App Bundle**:
   - Go to Production > Releases
   - Create new release
   - Upload `app-release.aab`
6. **Submit for Review**

**Review Time**: 1-7 days

### Apple App Store

1. **Create Apple Developer Account** ($99/year)
2. **Go to App Store Connect**: https://appstoreconnect.apple.com
3. **Create New App**:
   - Platform: iOS
   - Name: Althaqafy
   - Primary Language: Arabic
   - Bundle ID: com.mmarouf.salembooks
4. **Complete App Information**:
   - Upload screenshots
   - Add descriptions
   - Set category: Books or Education
   - Add privacy policy URL
5. **Upload IPA**:
   - Use Xcode Organizer or Application Loader
   - Select the uploaded build in App Store Connect
6. **Submit for Review**

**Review Time**: 1-3 days

---

## Common Build Issues

### Android

**Issue**: ProGuard errors during release build

**Solution**: Check `proguard-rules.pro` and ensure all Flutter plugins are excluded

**Issue**: App crashes on startup in release mode

**Solution**: Test with `--profile` mode first: `flutter run --profile`

**Issue**: Signing key not found

**Solution**: Verify `key.properties` path and keystore location

### iOS

**Issue**: Provisioning profile mismatch

**Solution**: In Xcode, go to Signing & Capabilities, enable "Automatically manage signing"

**Issue**: CocoaPods dependencies fail

**Solution**:
```bash
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod install
```

**Issue**: Archive build fails

**Solution**: Clean build folder in Xcode: Product > Clean Build Folder (Cmd+Shift+K)

---

## Version Management

When releasing updates:

1. Update version in `pubspec.yaml`:
   - Format: `MAJOR.MINOR.PATCH+BUILD`
   - Example: `2.1.0+3` (version 2.1.0, build 3)

2. Android uses:
   - `versionName`: 2.1.0
   - `versionCode`: 3

3. iOS uses:
   - `CFBundleShortVersionString`: 2.1.0
   - `CFBundleVersion`: 3

---

## Support

If you encounter issues:
- Check Flutter documentation: https://docs.flutter.dev
- Google Play Console Help: https://support.google.com/googleplay/android-developer
- App Store Connect Help: https://developer.apple.com/help/app-store-connect

---

**Last Updated**: November 29, 2025
