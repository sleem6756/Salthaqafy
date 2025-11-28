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
- **Share Audio**: Share the audio URL using `share_plus`.
- **Download Audio**: Download MP3 file using `dio` and save to device storage.

### 5. Bookmarking System
- **Description**: Save favorite pages for quick access.
- **Implementation**: Uses `BookmarkProvider` with local database storage.
- **UI**: Toggle bookmark button in bottom container.
- **Navigation**: Dedicated bookmarks tab in main reading page.

### 6. Search Functionality
- **Description**: Search for specific verses or content.
- **Integration**: Button in bottom container navigates to search page.

### 7. Navigation Tools
- **Index**: Navigate to surah list organized by Juz.
- **Bookmarks**: Access saved pages.
- **Doaa Khatm**: Special prayers for Quran completion.

### 8. Header Information
- **Surah Details**: Name, revelation place (Makkah/Madinah), verse count.
- **Juz and Hizb**: Current Juz number and Hizb quarter.
- **Page Indicators**: Visual indicators for page layout.

### 9. Footer Controls
- **Search Bar**: Quick access to search functionality.
- **Bookmark Toggle**: Add/remove page bookmarks.
- **Navigation Buttons**: Links to index, bookmarks, and Khatm prayer.
- **Font Slider**: Real-time font size adjustment.

## Logic and Workflow

### Data Flow
1. **Page Loading**: When a page is accessed, `pageData` provides surah and verse ranges.
2. **Text Rendering**: Verses are displayed using `RichText` with custom spans for each word.
3. **Font Adaptation**: Dynamic font sizing based on word length for optimal display.
4. **Audio Integration**: Verse audio URLs generated using `quran.getAudioURLByVerse()`.

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
- **`dio: ^5.7.0`**: HTTP client for audio downloads.
- **`share_plus: ^11.0.0`**: Sharing functionality.

### Storage and Persistence
- **`shared_preferences: ^2.0.8`**: Simple key-value storage.
- **`sqflite: ^2.3.3+2`**: SQLite database for bookmarks and settings.
- **`path_provider: ^2.1.4`**: File system paths for downloads.

### Utilities
- **`connectivity_plus: ^6.0.5`**: Internet connectivity checks.
- **`permission_handler: ^12.0.0+1`**: Storage permissions for downloads.
- **`timezone: ^0.10.0`**: Time-related utilities.

## Technical Implementation

### Key Classes
- **`SurahPage`**: Main reading interface with page navigation.
- **`QuranContainerUP`**: Header displaying surah and location info.
- **`QuranContainerDown`**: Footer with controls and navigation.
- **`VerseButtons`**: Action buttons for selected verses.
- **`FontSlider`**: Font size adjustment widget.

### Data Structures
- **Page Data**: Uses `pageData` array mapping pages to surah/verse ranges.
- **Verse Highlighting**: Map structure tracking highlighted verses.
- **Font Sizing**: Dynamic calculation based on text width and screen size.

### Performance Considerations
- **Lazy Loading**: Pages load content only when accessed.
- **Debounced Saving**: Font size changes saved with 100ms debounce.
- **Memory Management**: Proper disposal of audio players and listeners.

## Usage

### Basic Reading
1. Open the app and navigate to Quran → Reading.
2. Browse surahs or select from bookmarks.
3. Swipe to navigate pages.
4. Tap anywhere to toggle header/footer visibility.

### Advanced Features
1. **Font Adjustment**: Use slider in bottom panel.
2. **Verse Interaction**: Long-press verse → select actions.
3. **Bookmarking**: Tap bookmark icon to save page.
4. **Audio**: Play, share, or download verse audio.
5. **Navigation**: Use index, bookmarks, or search for quick access.

### Accessibility
- **Arabic Support**: RTL layout and Arabic fonts (Uthmanic, Amiri, Cairo).
- **Touch-Friendly**: Large touch targets for all interactive elements.
- **Visual Feedback**: Clear highlighting and animations.
- **Offline Capability**: Core reading works without internet.

## Future Enhancements

- **Tafseer Integration**: Implement actual verse interpretations.
- **Translation Support**: Add side-by-side translations.
- **Themes**: Dark/light mode support.
- **Bookmarks Management**: Organize bookmarks with notes.
- **Reading Progress**: Track reading completion.
- **Audio Settings**: Playback speed and quality controls.