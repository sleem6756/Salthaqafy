# 📚 Salthaqafy - كتب الدكتور سالم الثقفي

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue?logo=dart)
![License](https://img.shields.io/badge/License-Private-red)
![Version](https://img.shields.io/badge/Version-2.0.0-green)

A comprehensive Flutter application for accessing and browsing Islamic jurisprudence books by Dr. Salem Al-Thaqafi.

[Website](https://salthaqafy.com) • [Contact](mailto:althaqafys@gmail.com) 

</div>

---

## 📖 Overview

**Salthaqafy** is a mobile application designed to provide easy access to the extensive collection of Islamic jurisprudence (Fiqh) books and scholarly works by **Prof. Dr. Salem Al-Thaqafi**. The app features a user-friendly interface with Arabic language support, fast book searching, and direct access to PDF publications.

### 📊 Key Statistics

- **Total Books**: 8+ books available
- **Languages**: Arabic (RTL Support) & English
- **Platforms**: Android, iOS
- **Min Android SDK**: 21+
- **Min iOS Version**: 11.0+

---

## ✨ Features

### 🏠 Home Screen

- **Book Gallery**: Browse all available books with cover images
- **Pagination**: Efficient loading of books in batches
- **Certificate Display**: Showcases Dr. Salem Al-Thaqafi's credentials
- **Search Integration**: Quick access to search functionality
- **Refresh Button**: Manual refresh to reload the latest books

### 🔍 Search Screen

- **Real-time Search**: Debounced search for responsive performance
- **Arabic Support**: Search works seamlessly in Arabic
- **Clear Function**: Quick clear button to reset search

### 📕 Book Details Screen

- **Book Information**: Title, publication details
- **Cover Image**: High-quality book cover preview with Hero animation
- **Direct PDF Link**: One-tap access to open PDF files
- **Multiple Launch Methods**: Fallback mechanisms for reliable PDF opening

### ℹ️ About Screen

- **Biography**: Comprehensive biography of Dr. Salem Al-Thaqafi
- **Academic Background**: Educational history and achievements
- **Publications**: List of major scholarly works
- **Professional Timeline**: Career milestones and accomplishments

### 📞 Contact Screen

- **Email Contact**: Direct email messaging form
- **WhatsApp Integration**: Quick messaging via WhatsApp
- **Website Link**: Direct access to official website (salthaqafy.com)
- **Donation Portal**: Link to charitable donation platform (kafel.org.sa)
- **Privacy Policy**: Terms and conditions access

### 🎨 Splash Screen

- **Animated Loading**: Professional animated intro
- **Logo Animation**: Elastic entrance animation
- **Progress Indicator**: Visual loading feedback
- **Smooth Transition**: Seamless navigation to main app

---

## 🛠️ Technical Architecture

### State Management

- **Provider Pattern** (provider ^6.1.1): Clean and efficient state management
- **ChangeNotifier**: Reactive UI updates

### API Integration

- **Dio** (^5.9.0): Robust HTTP client with timeout handling
- **WooCommerce API**: Integration with WordPress/WooCommerce backend
- **Pagination**: Server-side pagination for optimal performance

### UI/UX

- **Material Design**: Professional Material Design 3 implementation
- **Shimmer Loading**: Skeleton loading screens for better UX
- **Hero Animations**: Smooth transitions between screens
- **RTL Support**: Full right-to-left support for Arabic

### External Services

- **URL Launcher** (^6.3.2): External link handling
- **Flutter HTML** (^3.0.0): HTML content rendering

### Localization

- **flutter_localizations**: Multi-language support
- **Arabic RTL**: Full right-to-left implementation
- **Dual Language**: Arabic and English interfaces

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  dio: ^5.9.0 # HTTP Client
  provider: ^6.1.1 # State Management
  shimmer: ^3.0.0 # Loading Animations
  flutter_html: ^3.0.0 # HTML Rendering
  url_launcher: ^6.3.2 # External Links
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0 # Linting
  logger: ^2.4.0 # Logging
```

---

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── book.dart               # Book data model
│   └── category.dart           # Category data model
├── providers/
│   └── book_provider.dart      # State management for books
├── screens/
│   ├── splash_screen.dart      # Splash/Loading screen
│   ├── main_screen.dart        # Bottom navigation controller
│   ├── home_screen.dart        # Books listing
│   ├── search_screen.dart      # Book search
│   ├── book_detail_screen.dart # Book details & PDF viewer
│   ├── about_screen.dart       # About Dr. Salem
│   └── contact_screen.dart     # Contact information
├── services/
│   └── api_service.dart        # API communication
├── widgets/
│   ├── book_card.dart          # Book list item widget
│   └── shimmer_loading.dart    # Loading animation widget
└── utils/
    ├── endpoints.dart          # API endpoints
    └── logger.dart             # Logging utility
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- Dart SDK 3.9.2+
- Android SDK 21+ or iOS 11.0+

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/sleem6756/salthaqafy.git
cd salthaqafy
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

### Building for Release

**Android:**

```bash
flutter build apk --release
# or for AAB (Google Play)
flutter build appbundle --release
```

**iOS:**

```bash
flutter build ios --release
```

**Web:**

```bash
flutter build web --release
```

---

## 📱 App Features Breakdown

| Feature                 | Description                            | Status    |
| ----------------------- | -------------------------------------- | --------- |
| 📚 Book Catalog         | Browse 50+ Islamic jurisprudence books | ✅ Active |
| 🔍 Advanced Search      | Real-time search with Arabic support   | ✅ Active |
| 📖 PDF Access           | Direct links to book PDFs              | ✅ Active |
| 👤 Author Profile       | Detailed biography of Dr. Salem        | ✅ Active |
| 💬 Contact Form         | Email messaging capability             | ✅ Active |
| 📱 WhatsApp Integration | Direct messaging via WhatsApp          | ✅ Active |
| 🌐 Website Link         | Direct access to official website      | ✅ Active |
| 🎁 Donations            | Link to charitable giving              | ✅ Active |
| 🎨 Animations           | Smooth splash screen animations        | ✅ Active |
| 🌍 Localization         | Arabic RTL & English support           | ✅ Active |
| 📡 API Integration      | Real-time book data from WooCommerce   | ✅ Active |
| ⚡ Performance          | Pagination & efficient loading         | ✅ Active |

---

## 🔗 API Integration

The app connects to a WooCommerce-based API to fetch books dynamically:

**Base URL**: Configured in `lib/utils/endpoints.dart`

**Endpoints:**

- `/wp-json/wc/v3/products` - Fetch books
- `/wp-json/wp/v2/media/{id}` - Fetch media/images
- `/wp-json/wc/v3/products/categories` - Fetch categories

---

## 📲 Download

The app is available on:

- 🤖 Google Play Store: [Salthaqafy](https://play.google.com/store/apps/details?id=com.salthaqafy)
- 🍎 Apple App Store: [Salthaqafy](https://apps.apple.com/app/salthaqafy)

---

## 🤝 Contributing

We appreciate your interest in contributing! For now, this is a private project. For questions or contributions, please contact:

**Email**: althaqafys@gmail.com  
**Website**: https://salthaqafy.com

---

## 📋 License

This project is private and proprietary. All rights reserved © 2024 Dr. Salem Al-Thaqafi.

---

## 👨‍💼 About Dr. Salem Al-Thaqafi

Prof. Dr. Salem Al-Thaqafi is a renowned Islamic scholar specializing in Hanbalite jurisprudence (Fiqh) and Islamic law. He has authored numerous scholarly works and publications that serve as important references in Islamic education.

**Key Contributions:**

- Mafateeh Al-Fiqh Al-Hanbali (Keys to Hanbalite Jurisprudence)
- Mustalahat Al-Fiqh Al-Hanbali (Terminologies of Hanbalite Jurisprudence)
- Research papers on Islamic jurisprudence and ethics

---

## 🐛 Bug Reports & Support

For bug reports or technical support, please contact:

📧 **Email**: althaqafys@gmail.com  
💬 **WhatsApp**: [Contact via WhatsApp](https://wa.me/)  
🌐 **Website**: https://salthaqafy.com  
🤝 **Privacy Policy**: https://salthaqafy.com/privacy-policy-2/

---

## 📊 Version History

| Version | Date | Changes                                                                    |
| ------- | ---- | -------------------------------------------------------------------------- |
| 2.0.0   | 2025 | Major update with new UI/UX, improved search, and performance optimization |
| 1.0.0   | 2020 | Initial release                                                            |

---

## 🎯 Roadmap

- [ ] Offline book caching
- [ ] Bookmarking system
- [ ] User annotations and notes
- [ ] Social sharing features
- [ ] Multiple language support expansion
- [ ] Dark mode support
- [ ] Audio versions of books

---

## 🙏 Acknowledgments

- **Dr. Salem Al-Thaqafi** for providing the scholarly content
- **Flutter Community** for the excellent framework
- **Contributors** who help improve the app

---

<div align="center">

**Made with ❤️ for Islamic knowledge sharing**

[Website](https://salthaqafy.com) • [Contact](mailto:althaqafys@gmail.com)

</div>
