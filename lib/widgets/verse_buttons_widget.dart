import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;

import '../methods.dart';
import '../utils/app_style.dart';
import '../constants.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isSoundPlaying = false;
  late ConnectivityResult _connectivityStatus;
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();

    // Listen to player state changes
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (mounted) {
        setState(() {
          isSoundPlaying = state == PlayerState.playing;
        });

        if (state == PlayerState.playing) {
          showMessage('جاري تشغيل الاية...');
        }
      }
    });
  }

  @override
  void dispose() {
    // Stop audio player and release resources
    _audioPlayer.stop();
    _audioPlayer.dispose();

    // Cancel the listener subscription
    _playerStateSubscription.cancel();

    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResults = await Connectivity()
        .checkConnectivity();

    if (mounted) {
      setState(() {
        _connectivityStatus =
            connectivityResults.contains(ConnectivityResult.none)
            ? ConnectivityResult.none
            : connectivityResults.first;
      });
    }
  }

  void togglePlayPause(String audioUrl) async {
    if (isSoundPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(audioUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.kSecondaryColor.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Play/Pause Action
            _buildActionItem(
              icon: isSoundPlaying ? Icons.pause_rounded : Icons.play_arrow,
              label: 'تشغيل',
              onTap: () {
                _checkInternetConnection();
                if (_connectivityStatus == ConnectivityResult.none) {
                  showMessage('لا يتوفر اتصال بالانترنت');
                } else {
                  togglePlayPause(
                    quran.getAudioURLByVerse(
                      widget.currentSurahIndex,
                      widget.highlightedVerse,
                    ),
                  );
                }
              },
            ),
            const Divider(color: Colors.white24, height: 1),

            // Tafseer Action
            _buildActionItem(
              icon: Icons.tips_and_updates_rounded,
              label: 'تفسير',
              onTap: () {
                showTafseer(
                  surahNumber: widget.currentSurahIndex,
                  verseNumber: widget.highlightedVerse,
                  context: context,
                );
              },
            ),
            const Divider(color: Colors.white24, height: 1),

            // Copy Action
            _buildActionItem(
              icon: Icons.copy_rounded,
              label: 'نسخ',
              onTap: () {
                // Copy verse text to clipboard
                final verseText = quran.getVerse(
                  widget.currentSurahIndex,
                  widget.highlightedVerse,
                );
                Clipboard.setData(ClipboardData(text: verseText));
                showMessage('تم نسخ الآية');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppStyles.styleCairoMedium15white(
                context,
              ).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
