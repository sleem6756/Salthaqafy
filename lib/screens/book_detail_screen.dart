import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/book.dart';
import '../utils/logger.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final String? mediaUrl;

  const BookDetailScreen({
    super.key,
    required this.book,
    this.mediaUrl,
  });

  Future<void> _launchBookUrl() async {
    try {
      // First try with launchUrlString for better Android compatibility
      if (await canLaunchUrlString(book.pdfUrl)) {
        await launchUrlString(
          book.pdfUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to launchUrl
        final Uri url = Uri.parse(book.pdfUrl);
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          // Final fallback
          if (!await launchUrl(
            url,
            mode: LaunchMode.platformDefault,
          )) {
            throw Exception('Could not launch ${book.pdfUrl}');
          }
        }
      }
    } catch (e) {
      AppLogger.e('Error launching URL', e);
      // Show user-friendly error message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('حدث خطأ في فتح الكتاب')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الكتاب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image with Hero Animation
            Center(
              child: Hero(
                tag: 'book-image-${book.id}',
                child: Container(
                  width: 200,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: mediaUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            mediaUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.book,
                                size: 80,
                                color: Colors.grey,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.book,
                          size: 80,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Book Title with Hero Animation
            Hero(
              tag: 'book-title-${book.id}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  book.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'وصف الكتاب:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'هذا ملف PDF يمكن قراءته مباشرة من خلال الرابط أدناه',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchBookUrl,
        icon: const Icon(Icons.open_in_browser),
        label: const Text('قراءة الكتاب'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}