import '../model/quran_models/reciters_model.dart';

class FavModel {
  final int surahIndex;
  final String reciterName;
  final String reciterUrl;
  final int zeroPaddingSurahNumber;
  final String url;
  late final RecitersModel reciter;

  FavModel({
    required this.surahIndex,
    required this.reciterName,
    required this.reciterUrl,
    required this.zeroPaddingSurahNumber,
    required this.url,
  }) {
    reciter = RecitersModel(
      url: reciterUrl,
      name: reciterName,
      zeroPaddingSurahNumber: zeroPaddingSurahNumber == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'surahIndex': surahIndex,
      'reciterName': reciterName,
      'reciterUrl': reciterUrl,
      'zeroPaddingSurahNumber': zeroPaddingSurahNumber,
      'url': url,
    };
  }

  factory FavModel.fromMap(Map<String, dynamic> map) {
    return FavModel(
      surahIndex: map['surahIndex'],
      reciterName: map['reciterName'],
      reciterUrl: map['reciterUrl'],
      zeroPaddingSurahNumber: map['zeroPaddingSurahNumber'],
      url: map['url'],
    );
  }
}