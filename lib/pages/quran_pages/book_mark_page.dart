import 'package:althaqafy/constants.dart';
import 'package:althaqafy/pages/quran_pages/surah_page.dart';
import 'package:althaqafy/utils/app_images.dart';
import 'package:althaqafy/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_mark_provider.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'العلامات المحفوظة',
          style: AppStyles.styleDiodrumArabicMedium15(
            context,
          ).copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, provider, child) {
          // Check if bookmarks are empty
          if (provider.bookmarks.isEmpty) {
            return Center(
              child: Text(
                'لا يوجد صفحات محفوظة',
                style: AppStyles.styleDiodrumArabicMedium15(context),
              ),
            );
          }

          // Display bookmarks
          return ListView.builder(
            itemCount: provider.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = provider.bookmarks[index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SurahPage(
                        pageNumber: provider.bookmarks[index].pageNumber,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.only(top: 8, right: 10, left: 8),
                  child: ListTile(
                    leading: Image.asset(
                      Assets.imagesBookmark,
                      height: 50,
                      width: 50,
                    ),
                    title: Text(
                      'سورة ${bookmark.surahName}',
                      style: AppStyles.alwaysBlack18(context),
                    ),
                    subtitle: Text(
                      'صفحة ${bookmark.pageNumber}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await provider.removeBookmark(index);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
