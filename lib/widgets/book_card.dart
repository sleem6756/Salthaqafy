import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/book.dart';
import '../utils/logger.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final String? mediaUrl;

  const BookCard({super.key, required this.book, this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: mediaUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        mediaUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.book,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : const Icon(Icons.book, size: 50, color: Colors.grey),
            ),

            const SizedBox(width: 16),

            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Title
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Publication Date
                  Text(
                    book.dateGmt != null
                        ? 'تاريخ النشر: ${book.dateGmt!.year}-${book.dateGmt!.month.toString().padLeft(2, '0')}-${book.dateGmt!.day.toString().padLeft(2, '0')}'
                        : 'تاريخ النشر: غير محدد',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Read Button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final Uri url = Uri.parse(book.pdfUrl);
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            // Show error message if URL can't be launched
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('لا يمكن فتح الملف'),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          AppLogger.e('Error launching book URL', e);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('حدث خطأ في فتح الكتاب'),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.open_in_browser, size: 18),
                      label: const Text('قراءة الكتاب'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}