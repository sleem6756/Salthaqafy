// REMOVED UNUSED: import 'dart:developer'; (only used in deleted downloadAudio)
import 'database_helper.dart';
import 'package:althaqafy/utils/app_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
// REMOVED UNUSED: import 'package:path_provider/path_provider.dart'; (only for download)
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'constants.dart';
// REMOVED UNUSED: import 'dart:io'; (only for Platform.isAndroid in download)

import 'pages/sevices/audio_handler.dart';

/// Define the MethodChannel that matches the one in your MainActivity.
// REMOVED UNUSED: Media scanner MethodChannel for download feature (orphaned code)

/// Custom function to trigger a media scan via the platform channel.
/// This notifies Android to update its media database so that the file shows in file managers.
// REMOVED UNUSED: scanFile() function (orphaned code)

Future<Map<String, dynamic>> loadJSONDataMap(String path) async {
  try {
    final String response = await rootBundle.loadString(path);
    final data = json.decode(response);
    return data as Map<String, dynamic>; // Return the loaded Map
  } catch (e) {
    debugPrint('Error loading JSON: $e');
    return {}; // Return an empty Map in case of error
  }
}

Future<List<dynamic>> loadJSONDataList(String path) async {
  try {
    final String response = await rootBundle.loadString(path);
    final data = json.decode(response);
    return data; // Return the loaded data
  } catch (e) {
    debugPrint('Error loading JSON: $e');
    return []; // Return an empty list in case of error
  }
}

void initializeAudioPlayer(
  AudioPlayer audioPlayer,
  Function(Duration) setTotalDuration,
  Function(Duration) setCurrentDuration,
  Function(bool) setIsPlaying,
) {
  // audioPlayer.onDurationChanged.listen((Duration duration) {
  //   setTotalDuration(duration);
  // });
  // audioPlayer.onPositionChanged.listen((Duration position) {
  //   setCurrentDuration(position);
  // });
  // audioPlayer.onPlayerComplete.listen((event) {
  //   setIsPlaying(false);
  //   setCurrentDuration(Duration.zero);
  // });
}

void showTafseer({
  required BuildContext context,
  required int surahNumber,
  required int verseNumber,
}) async {
  // Show loading spinner
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final dbHelper = DatabaseHelper();
    String? tafseerText = await dbHelper.getTafseer(surahNumber, verseNumber);

    if (tafseerText == null) {
      // Fetch from API (Tafseer Al-Muyassar - ID 1)
      final dio = Dio();
      final response = await dio.get(
        'http://api.quran-tafseer.com/tafseer/1/$surahNumber/$verseNumber',
      );

      if (response.statusCode == 200) {
        tafseerText = response.data['text'];
        // Save to DB
        if (tafseerText != null) {
          await dbHelper.insertTafseer(surahNumber, verseNumber, tafseerText);
        }
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop(); // Close loading dialog

      if (tafseerText != null) {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          context: context,
          isScrollControlled: true, // Allow full height if needed
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.kSecondaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'تفسير الآية $verseNumber',
                    style: AppStyles.styleDiodrumArabicbold20(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        tafseerText!,
                        style: AppStyles.styleCairoMedium15white(
                          context,
                        ).copyWith(fontSize: 18, height: 1.6),
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        showMessage('تعذر جلب التفسير. يرجى التحقق من الاتصال.');
      }
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      showMessage('حدث خطأ أثناء جلب التفسير: $e');
    }
  }
}

double currentSpeed = 1.0; // Track the current speed of playback

void adjustSpeed(AudioPlayer audioPlayer, double speed) async {
  currentSpeed = speed; // Update the speed state
  // await audioPlayer.setPlaybackRate(currentSpeed);
}

void backward(AudioPlayerHandler audioHandler) async {
  // Old: seek backward 10 seconds
  // Now: decrease playback speed
  await audioHandler.decreaseSpeed();
}

void forward(AudioPlayerHandler audioHandler) async {
  // Old: seek forward 10 seconds
  // Now: increase playback speed
  await audioHandler.increaseSpeed();
}

Future<void> shareAudio(String audioUrl) async {
  Share.share(audioUrl);
}

void showMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: const Color.fromRGBO(
      0,
      0,
      0,
      0.5,
    ), // لون أسود بنسبة شفافية 50%
  );
}

// REMOVED UNUSED: getCustomDownloadDirectory() function (~20 lines)
// REMOVED UNUSED: downloadAudio() function (~50 lines)
// REMOVED UNUSED: scanFile() function (~10 lines)
// Total: ~80 lines of orphaned download code removed

String removeTashkeel(String text) {
  // Regular expression to remove diacritics (Tashkeel)
  const tashkeelRegex = '[\u064B-\u065F\u06D6-\u06ED]';
  text = text.replaceAll(RegExp(tashkeelRegex), '');

  // Replace all forms of "ا" with the base form "ا"
  const alefVariantsRegex =
      '[\u0622\u0623\u0625\u0671]'; // Variants: ٱ, أ, إ, etc.
  text = text.replaceAll(RegExp(alefVariantsRegex), 'ا');

  return text;
}

String normalizeArabic(String text) {
  String withoutTashkeel = text.replaceAll(RegExp(r'[ًٌٍَُِّْۡ]'), '');
  String normalized = withoutTashkeel
      .replaceAll(RegExp(r'[أإٱآٰ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .trim(); // Trim spaces
  return normalized;
}

void showOfflineMessage() {
  showMessage('لا يتوفر اتصال بالانترنت.');
}
