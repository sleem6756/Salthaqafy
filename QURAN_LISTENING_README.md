# Quran Listening Feature - Althaqafy App

## Overview

The Quran Listening feature is a comprehensive audio Quran implementation that allows users to listen to the Holy Quran with multiple reciters, advanced playback controls, and background audio support. The feature provides access to hundreds of reciters across different recitation styles and narrations.

## Features

### Core Features
- **Multiple Recitation Styles**: 14 main categories including Murattal, Mugawwad, Warsh, Sho3ba, and more
- **Extensive Reciter Library**: Over 100 reciters in some categories, totaling thousands of audio files
- **Advanced Audio Controls**: Play/pause, seek, speed control, next/previous surah navigation
- **Background Playback**: Audio continues playing when app is minimized or screen is off
- **Favorites System**: Mark individual surahs as favorites for quick access
- **Offline Support**: Download audio files for offline listening
- **Search Functionality**: Search through reciters and surahs
- **Media Notifications**: System notifications with playback controls

### Audio Features
- **Playlist Management**: Automatic playlist creation for each reciter (114 surahs)
- **Speed Control**: Adjustable playback speed (fast forward/rewind)
- **Position Tracking**: Resume playback from last position
- **Quality Options**: Multiple audio quality options per reciter
- **Buffering Support**: Smooth streaming with buffering indicators

### User Experience
- **RTL Support**: Right-to-left layout for Arabic content
- **Arabic Interface**: All UI elements in Arabic
- **Responsive Design**: Works on different screen sizes
- **Connectivity Checks**: Offline/online mode detection
- **Error Handling**: Graceful handling of network issues

## Workflow/User Journey

### Navigation Flow
1. **Access Listening Tab**: User taps "سماع" (Listening) tab in main navigation
2. **Category Selection**: Grid view of 14 reciter categories displayed
3. **Reciter Selection**: List of reciters within selected category (e.g., Murattal shows 100+ reciters)
4. **Surah Selection**: 114 surahs displayed for chosen reciter
5. **Audio Playback**: Tap any surah to start playback with expanded controls

### Playback Workflow
1. **Initial Load**: App builds playlist for selected reciter
2. **Audio Streaming**: Downloads/streams audio from Quranicaudio.com
3. **Control Expansion**: Tap surah item to expand controls (slider, buttons)
4. **Background Play**: Audio continues when app is backgrounded
5. **Navigation**: Skip to next/previous surah automatically or manually

### Favorites Workflow
1. **Mark Favorite**: Heart icon on each surah item
2. **Access Favorites**: Dedicated "المفضلة" (Favorites) category
3. **Persistent Storage**: Favorites saved to local SQLite database

## Technical Implementation

### Architecture Overview
The Quran Listening feature uses a hierarchical structure:
- **Main Listening Page**: Entry point with category grid
- **Reciter Pages**: Category-specific reciter lists
- **Surah List Page**: 114 surahs with audio controls
- **Audio Handler**: Background audio service management

### Key Classes and Components

#### Page Classes
- `ListeningPage`: Main grid layout of reciter categories
- `MurattalPage`, `MakkaPage`, etc.: Category-specific reciter lists
- `ListSurahsListeningPage`: Surah list with audio controls

#### Widget Classes
- `SurahListeningItem`: Complex widget for each surah with controls
- `RecitursItem`: Simple reciter list item
- `ListeningButtons`: Category selection buttons

#### Model Classes
- `RecitersModel`: Contains reciter metadata (URL, name, padding settings)
- `AudioModel`: Audio file information for playlist
- `FavModel`: Favorite surah data structure

### Logic Flow

#### Playlist Creation
```dart
// For each reciter, build playlist of 114 surahs
List<AudioModel> playlist = [];
for (int i = 1; i <= 114; i++) {
  String audioUrl = reciter.zeroPaddingSurahNumber
      ? '${reciter.url}${i.toString().padLeft(3, '0')}.mp3'
      : '${reciter.url}$i.mp3';
  playlist.add(AudioModel(
    audioURL: audioUrl,
    title: quran.getSurahNameArabic(i),
    album: reciter.name,
  ));
}
```

#### Audio Playback
- **Initialization**: AudioService.init() creates global AudioPlayerHandler
- **Playlist Setup**: setAudioSourceWithPlaylist() configures audio source
- **Playback Control**: togglePlayPause() handles play/pause with state management
- **Background Service**: AudioPlayerHandler extends BaseAudioHandler

#### State Management
- **BLoC Pattern**: FavSurahItemCubit manages favorite operations
- **Stream Builders**: Real-time UI updates for playback state
- **Connectivity Monitoring**: Checks internet before audio operations

## Packages Implemented and Usage

### Core Audio Packages
- **audio_service**: Background audio playback service
  - Usage: Manages audio lifecycle, notifications, background play
  - Implementation: AudioPlayerHandler extends BaseAudioHandler

- **just_audio**: Modern audio player with playlist support
  - Usage: Core audio playback, seeking, speed control
  - Implementation: Integrated with AudioService for background support

- **audio_session**: Audio session management
  - Usage: Handles audio focus, ducking, and session configuration
  - Implementation: Ensures proper audio behavior across platforms

### State Management
- **flutter_bloc**: BLoC pattern integration
  - Usage: Manages favorite states, UI updates
  - Implementation: FavSurahItemCubit for favorite operations

### Database & Storage
- **sqflite**: SQLite database operations
  - Usage: Persistent storage of favorites, bookmarks
  - Implementation: DatabaseHelper class with CRUD operations

- **shared_preferences**: Key-value storage
  - Usage: Caching reciter data, user preferences
  - Implementation: Fast access to frequently used data

### Networking & Connectivity
- **connectivity_plus**: Network connectivity monitoring
  - Usage: Checks internet availability before streaming
  - Implementation: Prevents offline streaming attempts

- **dio**: HTTP client for API requests
  - Usage: Potential future API integrations
  - Implementation: Configured for external data fetching

### UI & Utilities
- **flutter_svg**: SVG image rendering
  - Usage: Icons for play, pause, favorite, share, download
  - Implementation: Vector graphics for crisp display

- **quran**: Quran text data package
  - Usage: Surah names, metadata, Arabic text
  - Implementation: getSurahNameArabic(), verse counting

- **path_provider**: File system access
  - Usage: Download directory for offline audio storage
  - Implementation: Platform-specific path resolution

- **share_plus**: Content sharing
  - Usage: Share audio file URLs or downloaded files
  - Implementation: Native sharing dialogs

### Development & Testing
- **flutter_lints**: Code quality enforcement
  - Usage: Maintains code standards across the feature
  - Implementation: Automated linting rules

## Database Integration

### Tables Used
- **favorites**: Stores favorite surah-reciter combinations
  ```sql
  CREATE TABLE favorites (
    id INTEGER PRIMARY KEY,
    surahIndex INTEGER,
    reciterName TEXT,
    url TEXT
  )
  ```

- **settings**: User preferences and configurations
- **theme**: App theme settings
- **fontSize**: Quran reading font size (shared with reading feature)

### Favorite Operations
- **Add Favorite**: Insert into favorites table with surah index and reciter
- **Remove Favorite**: Delete based on surah index and reciter name
- **Check Favorite**: Query existence for UI state
- **Load Favorites**: Retrieve all favorites for dedicated page

## Audio System Architecture

### AudioPlayerHandler Class
Extends BaseAudioHandler to provide:
- **Playlist Management**: Queue management for 114 surahs
- **Playback Controls**: Play, pause, skip, seek, speed adjustment
- **Media Notifications**: System notification with controls
- **Position Tracking**: Current position and duration streams
- **Background Processing**: Continues playback when app is not active

### Audio URL Structure
- **Base URLs**: Hosted on download.quranicaudio.com
- **Naming Convention**: Some reciters use zero-padded numbers (001.mp3), others use plain numbers (1.mp3)
- **Quality Options**: Multiple bitrate options available
- **CDN Distribution**: Fast, reliable audio delivery

### Playback States
- **Loading**: Audio buffering/loading state
- **Playing**: Active playback with position updates
- **Paused**: Playback paused, position maintained
- **Stopped**: Playback stopped, position reset
- **Error**: Network or file errors handled gracefully

## UI Components

### SurahListeningItem Widget
Complex expandable widget featuring:
- **Collapsed State**: Surah name, favorite button, action buttons
- **Expanded State**: Audio controls, progress slider, time display
- **Real-time Updates**: StreamBuilder for playback state changes
- **Connectivity Checks**: Offline mode detection

### Control Elements
- **Play/Pause Button**: Circular button with loading indicator
- **Progress Slider**: Seekable timeline with current/total time
- **Speed Controls**: Fast forward/rewind buttons
- **Navigation**: Previous/Next surah buttons
- **Secondary Actions**: Download, share, favorite toggle

### Responsive Design
- **Adaptive Layout**: Works on phones and tablets
- **RTL Support**: Proper Arabic text direction
- **Theme Integration**: Light/dark mode compatibility
- **Accessibility**: Screen reader support for audio controls

## Error Handling and Edge Cases

### Network Issues
- **Offline Detection**: Prevents streaming attempts without internet
- **Retry Logic**: Automatic retry for failed downloads
- **Graceful Degradation**: Offline mode with downloaded content

### Audio Playback Errors
- **File Not Found**: Fallback to alternative sources
- **Corrupt Files**: Skip to next surah automatically
- **Codec Issues**: Platform-specific audio format handling

### Database Errors
- **Migration Handling**: Schema updates without data loss
- **Corruption Recovery**: Database recreation on critical errors
- **Concurrent Access**: Thread-safe database operations

## Performance Optimizations

### Memory Management
- **Stream Disposal**: Proper cleanup of audio streams
- **Widget Recycling**: Efficient list rendering for 114 items
- **Image Caching**: SVG icons cached for performance

### Network Optimization
- **Streaming Buffering**: Smooth playback with minimal buffering
- **Download Management**: Background download queuing
- **Cache Strategy**: Intelligent caching of frequently used audio

### Battery Optimization
- **Background Processing**: Efficient audio processing
- **Wake Locks**: Prevents device sleep during playback
- **Resource Cleanup**: Automatic resource release when not playing

## Future Enhancements

### Potential Features
- **Offline Mode**: Complete offline Quran library
- **Playlist Creation**: Custom user playlists
- **Audio Quality Selection**: Multiple bitrate options
- **Sleep Timer**: Automatic playback stop after set time
- **Bookmark Sync**: Cloud synchronization of bookmarks
- **Social Features**: Share listening progress

### Technical Improvements
- **Audio Caching**: Advanced caching strategies
- **Background Downloads**: Queue management for bulk downloads
- **Analytics**: Usage tracking and performance metrics
- **Accessibility**: Enhanced screen reader support

This comprehensive Quran Listening feature provides a robust, user-friendly audio Quran experience with extensive customization options and reliable performance.