# Althaqafy - Islamic App

## Overview
Althaqafy is a comprehensive Islamic mobile application developed by Dr. Salem Al-Thaqafi. The app provides Muslims with essential Islamic content including Quran reading and listening, daily azkar (remembrances), ruqiya (Islamic healing), and a collection of Islamic books.

## App Workflow

### Main Flow
1. **Splash Screen**: App initializes audio service, notifications, and loads azkar data from JSON
2. **Home Page**: Displays 4 main categories in a grid layout:
   - الأذكار (Azkar/Remembrances)
   - الرقية الشرعية (Islamic Healing/Ruqiya)
   - القرآن الكريم (Holy Quran) - opens bottom sheet for reading/listening options
   - كتب (Islamic Books)

### Feature Workflows

#### Quran Feature
- **Reading**: Tab-based interface with Surah and Bookmarks tabs
- **Listening**: Grid of reciters (Murattal, Mugawwad, various narrations like Warsh, Sho3ba, etc.)
- **Bookmarks**: Save and manage reading positions
- **Audio Playback**: Background audio service with playlist support, speed control

#### Azkar Feature
- Load azkar categories from JSON assets
- Search functionality across categories
- Favorite entire categories
- Individual zekr items with count tracking
- Copy to clipboard functionality
- Azkar reminders via notifications

#### Ruqiya Feature
- Load ruqiya texts from JSON assets
- Display text with additional info
- Copy to clipboard functionality

#### Books Feature
- Fetch books from API with pagination
- Search functionality
- Book details with cover images
- About and contact information

## Implemented Packages and Usage

### Core Flutter Packages
- **flutter**: SDK for building the UI
- **flutter_localizations**: Arabic localization support

### State Management
- **bloc**: Business Logic Component pattern for state management
- **flutter_bloc**: Flutter integration for BLoC
- **provider**: Alternative state management for some features

### Database & Storage
- **sqflite**: SQLite database for local data storage
- **sqflite_common_ffi**: Desktop support for SQLite
- **shared_preferences**: Key-value storage for caching azkar data
- **hive**: Local storage (not extensively used)

### Audio & Media
- **audio_service**: Background audio playback service
- **audio_session**: Audio session management
- **just_audio**: Modern audio player with playlist support
- **flutter_tts**: Text-to-speech functionality

### Networking & APIs
- **dio**: HTTP client for API requests

### UI & Design
- **flutter_svg**: SVG image support
- **flutter_html**: HTML content rendering
- **shimmer**: Loading animations
- **device_preview**: Device preview for development

### Notifications
- **flutter_local_notifications**: Local notification scheduling

### Utilities
- **path_provider**: File system paths
- **url_launcher**: Open URLs in browser
- **share_plus**: Share content
- **recase**: String case conversion
- **rxdart**: Reactive programming
- **quran**: Quran text data
- **al_quran**: Alternative Quran package

### Development
- **flutter_lints**: Code linting
- **logger**: Logging utility
- **flutter_launcher_icons**: App icon generation

## Core Logic Architecture

### State Management (BLoC Pattern)
The app uses BLoC (Business Logic Component) pattern extensively:

- **AzkarCubit**: Manages azkar data loading, caching, and search
- **FavZekrCubit**: Handles favorite azkar categories
- **FavSurahItemCubit**: Manages favorite Quran surahs
- **RuqiyaCubit**: Ruqiya data loading
- **ThemeCubit**: App theme management

### Database Layer
**DatabaseHelper** class manages SQLite database with tables:
- `favorites`: Quran listening favorites
- `bookmarks`: Reading positions
- `fontSize`: Quran font size settings
- `theme`: App theme preferences
- `favAzkarPage`: Favorite azkar categories
- `settings`: Notification preferences

### Audio System
**AudioPlayerHandler** extends BaseAudioHandler for background audio:
- Playlist management for Quran surahs
- Playback controls (play/pause, skip, speed control)
- Media notifications integration
- Position tracking and seeking

### Notification System
**NotificationService** handles:
- Azkar reminders (sleep, wake)

### Data Flow
1. **JSON Assets**: Azkar and Ruqiya loaded from assets/db/
2. **API Integration**: Books from external API
3. **Caching**: SharedPreferences for azkar, SQLite for persistent data

### UI Architecture
- **Material Design 3** with custom Arabic fonts
- **Responsive Layout**: Adaptive widgets for different screen sizes
- **Theme System**: Light, dark, and default themes
- **RTL Support**: Right-to-left layout for Arabic content

### Key Features Logic

#### Quran Reading
- Tab controller with SurahListWidget, BookmarksPage
- Font size adjustable via provider
- Search functionality in dedicated page

#### Quran Listening
- Grid layout of reciter options
- Each reciter page shows surah list with play buttons
- Audio handler manages playlist and background playback

#### Azkar System
- Category-based organization
- Search with filtering
- Favorite system using database
- Individual zekr counter (UI only, not persisted)
- Azkar notifications for sleep and wake times

This architecture ensures a robust, scalable Islamic application with comprehensive features for Muslim users.
## Prerequisites

Before running the Althaqafy app, ensure you have the following installed:

- **Flutter SDK**: Version 3.9.2 or higher. Download from [flutter.dev](https://flutter.dev/docs/get-started/install).
- **Dart SDK**: Included with Flutter.
- **Android Studio** or **VS Code** with Flutter extensions for development.
- **Android SDK** for Android builds (API level 21+).
- **Xcode** for iOS builds (macOS only).

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo/althaqafy.git
   cd althaqafy
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure app icons** (optional, if not already set):
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

## Building and Running

### For Android:
```bash
flutter build apk --release
# or for development
flutter run
```

### For iOS (macOS only):
```bash
flutter build ios --release
# or for development
flutter run
```

### For Web (if supported):
```bash
flutter build web
flutter run -d chrome
```

## Key Features

- **Quran Reading & Listening**: Complete Quran with multiple reciters, bookmarks, and audio playback.
- **Daily Azkar**: Comprehensive collection of Islamic remembrances with search and favorites.
- **Ruqiya (Islamic Healing)**: Texts for spiritual healing and protection.
- **Islamic Books**: Access to a library of Islamic literature by Dr. Salem Al-Thaqafi.
- **Prayer Times & Notifications**: Azkar reminders and prayer time alerts.
- **Qibla Compass**: Integrated compass for finding the direction of prayer.
- **Offline Support**: Most content available without internet connection.
- **Arabic RTL Support**: Full right-to-left layout for Arabic content.
- **Themes**: Light, dark, and system themes.

## Screenshots

(Add screenshots here if available)

## API Integration

The app integrates with external APIs for:
- Islamic books data
- Prayer times (if applicable)
- Other Islamic content

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-name`.
3. Commit your changes: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature-name`.
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Developed by Dr. Salem Al-Thaqafi.

For support or inquiries, contact: [email/contact info]

## Version History

- **v2.0.0**: Major update with enhanced features and UI improvements.
- **v1.x.x**: Initial releases with core Islamic features.