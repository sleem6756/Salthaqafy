import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import '../methods.dart';

class VerseButtons extends StatefulWidget {
  const VerseButtons({
    super.key,
    required this.currentSurahIndex,
    required this.highlightedVerse,
  });

  final int currentSurahIndex;
  final int highlightedVerse;

  @override
  State<VerseButtons> createState() => _VerseButtonsState();
}

class _VerseButtonsState extends State<VerseButtons> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.lightGreenAccent.withOpacity(0.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                showMessage('تشغيل الاية غير متاح حاليا');
              },
              icon: const Icon(Icons.play_arrow),
              color: Colors.grey,
              iconSize: 28,
              tooltip: 'تشغيل الاية (غير متاح)',
            ),
            IconButton(
              onPressed: () {
                showTafseer(
                  surahNumber: widget.currentSurahIndex,
                  verseNumber: widget.highlightedVerse,
                  context: context,
                );
              },
              icon: const Icon(Icons.tips_and_updates_rounded),
              color: Colors.green,
              iconSize: 28,
              tooltip: 'تفسير الاية',
            ),
            IconButton(
              onPressed: () {
                shareAudio(quran.getAudioURLByVerse(
                  widget.currentSurahIndex,
                  widget.highlightedVerse,
                ));
              },
              icon: const Icon(Icons.share),
              color: Colors.green,
              iconSize: 28,
              tooltip: 'مشاركة',
            ),
            IconButton(
              onPressed: () {
                downloadAudio(
                  quran.getAudioURLByVerse(
                    widget.currentSurahIndex,
                    widget.highlightedVerse,
                  ),
                  quran.getSurahNameArabic(widget.currentSurahIndex),
                  context,
                );
              },
              icon: const Icon(Icons.download_rounded),
              color: Colors.green,
              iconSize: 28,
              tooltip: 'تحميل',
            ),
          ],
        ),
      ),
    );
  }
}
