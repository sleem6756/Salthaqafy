import 'package:althaqafy/constants.dart';
import 'package:althaqafy/pages/azkar_pages/azkar_main_page.dart';
import 'package:althaqafy/pages/books/books_page.dart';
import 'package:althaqafy/pages/books/contact_screen.dart';
import 'package:althaqafy/pages/quran_pages/listening_page/main_listening_page.dart';
import 'package:althaqafy/pages/quran_pages/quran_reading_main_page.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  /// Controller to handle page navigation
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom navigation bar
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// List of pages for each tab (5 tabs max)
    final List<Widget> bottomBarPages = [
      const BooksPage(), // كتب (Books) - Active/Default
      const QuranReadingMainPage(), // القرآن الكريم - قراءة (Reading)
      const ListeningPage(), // القرآن الكريم - سماع (Listening)
      const AzkarPage(), // الأذكار (Azkar) - Ruqiya moved here
      const ContactScreen(), // اتصل بنا (Contact)
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          bottomBarPages.length,
          (index) => bottomBarPages[index],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        /// Provide NotchBottomBarController
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 8,
        kBottomRadius: 28.0,
        notchColor: Colors.white,

        /// Restart app if you change removeMargins
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: true,
        durationInMilliSeconds: 300,

        itemLabelStyle: const TextStyle(
          fontSize: 10,
          color: Color(0xFF6a564f),
          fontFamily: "Cairo",
        ),

        elevation: 8,
        bottomBarItems: [
          /// Books Tab
          BottomBarItem(
            inActiveItem: const Icon(Icons.book, color: Color(0xFF6a564f)),
            activeItem: Icon(Icons.book, color: AppColors.kSecondaryColor),
            itemLabel: 'كتب',
          ),

          /// Quran Reading Tab
          BottomBarItem(
            inActiveItem: const Icon(Icons.menu_book, color: Color(0xFF6a564f)),
            activeItem: Icon(Icons.menu_book, color: AppColors.kSecondaryColor),
            itemLabel: 'قراءة',
          ),

          /// Quran Listening Tab
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.headphones,
              color: Color(0xFF6a564f),
            ),
            activeItem: Icon(
              Icons.headphones,
              color: AppColors.kSecondaryColor,
            ),
            itemLabel: 'سماع',
          ),

          /// Azkar Tab
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.auto_stories,
              color: Color(0xFF6a564f),
            ),
            activeItem: Icon(
              Icons.auto_stories,
              color: AppColors.kSecondaryColor,
            ),
            itemLabel: 'الأذكار',
          ),

          /// Contact Tab
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.contact_mail,
              color: Color(0xFF6a564f),
            ),
            activeItem: Icon(
              Icons.contact_mail,
              color: AppColors.kSecondaryColor,
            ),
            itemLabel: 'اتصل بنا',
          ),
        ],
        onTap: (index) {
          /// Perform action on tab change and update pages
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      ),
    );
  }
}
