# Quran Reading Page

## Overview

The Quran Reading Page is a core feature of the Althaqafy app, providing users with an immersive and interactive experience for reading the Holy Quran. This page displays the Quran text in its traditional page-based format, allowing users to navigate through all 604 pages with smooth swipe gestures. The implementation focuses on authenticity, usability, and accessibility, incorporating Arabic typography, verse highlighting, audio integration, and various navigation tools.

## Features

### 1. Page-Based Navigation
- **Description**: Displays Quran text organized by traditional Mushaf pages (1-604).
- **Implementation**: Uses `PageView` widget with custom physics to prevent overscrolling beyond valid pages.
- **User Interaction**: Swipe left/right to navigate between pages.
- **Logic**: Each page contains verses from one or more surahs, loaded dynamically using the `quran` package's `pageData`.

### 2. Font Size Adjustment
- **Description**: Allows users to customize text size for better readability.
- **Range**: 15-60 pixels, with real-time preview.
- **Persistence**: Font size is saved to local database using `shared_preferences` and `sqflite`.
- **UI**: Slider widget in the bottom container with Arabic letter previews.

### 3. Verse Selection and Highlighting
- **Description**: Long-press on any verse to select and highlight it.
- **Visual Feedback**: Selected verse appears with yellow background and red text.
- **Action Buttons**: Floating action buttons appear with options for the selected verse.

### 4. Verse Actions
When a verse is selected, users can:
- **Play Audio**: Stream verse recitation using `audioplayers` package.
- **Show Tafseer**: Display interpretation (currently shows "not available" message).
- **Copy Verse**: Copy the verse text to clipboard using `flutter/services.dart`.

### 5. Basmala Display
- **Description**: Dedicated widget for displaying "Bismillah" with proper styling.
- **Implementation**: `BasmalaWidget` with gold color, Amiri font, and centered alignment.
- **Logic**: Dynamically removes Bismillah from verse 1 text to prevent duplication.
- **Layout**: Positioned between surah border and verse text with proper spacing.

### 6. Bookmarking System
- **Description**: Save favorite pages for quick access.
- **Implementation**: Uses `BookmarkProvider` with local database storage.
- **UI**: Toggle bookmark button in bottom container.
- **Navigation**: Dedicated bookmarks tab in main reading page.

### 7. Search Functionality
- **Description**: Search for specific verses or content.
- **Integration**: Button in bottom container navigates to search page.

### 8. Navigation Tools
- **Index**: Navigate to surah list organized by Juz.
- **Bookmarks**: Access saved pages.
- **Doaa Khatm**: Special prayers for Quran completion.

### 9. Header Information
- **Surah Details**: Name, revelation place (Makkah/Madinah), verse count.
- **Juz and Hizb**: Current Juz number and Hizb quarter.
- **Page Indicators**: Visual indicators for page layout.

### 10. Footer Controls
- **Search Bar**: Quick access to search functionality.
- **Bookmark Toggle**: Add/remove page bookmarks.
- **Navigation Buttons**: Links to index, bookmarks, and Khatm prayer.
- **Font Slider**: Real-time font size adjustment.

## Logic and Workflow

### Data Flow
1. **Page Loading**: When a page is accessed, `pageData` provides surah and verse ranges.
2. **Text Rendering**: Verses are displayed using `RichText` with custom spans for each word.
3. **Bismillah Handling**: For surahs 2-113, Bismillah is displayed via `BasmalaWidget` and removed from verse 1 text.
4. **Font Adaptation**: Dynamic font sizing based on word length for optimal display.
5. **Audio Integration**: Verse audio URLs generated using `quran.getAudioURLByVerse()`.

### User Workflow
1. **Access**: From home page → Quran → Reading.
2. **Navigation**: Choose between Surah list or Bookmarks tabs.
3. **Reading**: Swipe through pages or tap surah names to jump to specific locations.
4. **Interaction**: Long-press verses for additional actions.
5. **Customization**: Adjust font size using bottom slider.
6. **Bookmarking**: Save important pages for later reference.

### State Management
- **Font Size**: `QuranFontSizeProvider` using Provider pattern.
- **Bookmarks**: `BookmarkProvider` with database persistence.
- **Page State**: Local state management within `SurahPage`.

## Technical Implementation

### Key Classes
- **`SurahPage`**: Main reading interface with page navigation.
- **`BasmalaWidget`**: Dedicated widget for Bismillah display with proper styling.
- **`QuranContainerUP`**: Header displaying surah and location info.
- **`QuranContainerDown`**: Footer with controls and navigation.
- **`VerseButtons`**: Action buttons for selected verses (play, tafseer, copy).
- **`FontSlider`**: Font size adjustment widget.

### Data Structures
- **Page Data**: Uses `pageData` array mapping pages to surah/verse ranges.
- **Verse Highlighting**: Map structure tracking highlighted verses.
- **Font Sizing**: Dynamic calculation based on text width and screen size.

### Bismillah Logic
```dart
// Dynamic Bismillah removal to prevent duplication
if (verseIndex == 1 && surahNumber != 1 && surahNumber != 9) {
  String bismillah = quran.getVerse(1, 1);
  if (verseText.startsWith(bismillah)) {
    verseText = verseText.substring(bismillah.length).trim();
  }
}
```

### Performance Considerations
- **Lazy Loading**: Pages load content only when accessed.
- **Debounced Saving**: Font size changes saved with 100ms debounce.
- **Memory Management**: Proper disposal of audio players and listeners.

## Packages and Dependencies

### Core Quran Packages
- **`quran: ^1.0.7`**: Primary package for Quran data, verses, audio URLs, and utilities.
- **`al_quran: ^0.1.1+5`**: Additional Quran data and Bismillah text.

### UI and Interaction
- **`flutter_html: ^3.0.0`**: For potential HTML content rendering (not currently used in reading page).
- **`provider: ^6.0.1`**: State management for font size and bookmarks.

### Audio and Media
- **`audioplayers: ^6.1.0`**: Audio playback for verse recitation.
- **`just_audio: ^0.10.1`**: Alternative audio handling (used in listening features).
- **`connectivity_plus: ^6.0.5`**: Internet connectivity checks.

### Storage and Persistence
- **`shared_preferences: ^2.0.8`**: Simple key-value storage.
- **`sqflite: ^2.3.3+2`**: SQLite database for bookmarks and settings.
- **`path_provider: ^2.1.4`**: File system paths.

### System Integration
- **`flutter/services.dart`**: Clipboard functionality for copying verses.

## Usage

### Basic Reading
1. Open the app and navigate to Quran → Reading.
2. Browse surahs or select from bookmarks.
3. Swipe to navigate pages.
4. Tap anywhere to toggle header/footer visibility.

### Advanced Features
1. **Font Adjustment**: Use slider in bottom panel.
2. **Verse Interaction**: Long-press verse → select actions.
3. **Copy Verses**: Copy selected verses to clipboard.
4. **Audio**: Play verse recitation with internet connection.
5. **Bookmarking**: Save important pages for later reference.
6. **Navigation**: Use index, bookmarks, or search for quick access.

### Accessibility
- **Arabic Support**: RTL layout and Arabic fonts (Uthmanic, Amiri, Cairo).
- **Touch-Friendly**: Large touch targets for all interactive elements.
- **Visual Feedback**: Clear highlighting and animations.
- **Offline Capability**: Core reading works without internet (audio requires connection).

## Recent Updates

### Basmala Enhancement
- **New BasmalaWidget**: Dedicated component with proper gold styling and spacing.
- **Dynamic Text Handling**: Automatic removal of Bismillah from verse 1 to prevent duplication.
- **Improved Layout**: Better visual separation between surah borders and Bismillah.

### Simplified Verse Actions
- **Streamlined UI**: Reduced from 4 to 3 action buttons for cleaner interface.
- **Copy Functionality**: Direct clipboard integration for verse sharing.
- **Removed Dependencies**: Eliminated share/download features for simpler maintenance.

## Future Enhancements

- **Tafseer Integration**: Implement actual verse interpretations.
- **Translation Support**: Add side-by-side translations.
- **Themes**: Dark/light mode support.
- **Bookmarks Management**: Organize bookmarks with notes.
- **Reading Progress**: Track reading completion.
- **Audio Settings**: Playback speed and quality controls.