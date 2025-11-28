import 'package:althaqafy/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import 'package:althaqafy/constants.dart';
import 'package:althaqafy/utils/app_style.dart';
import '../../../widgets/reciturs_item.dart';
import 'list_surahs_listening_page.dart';

class MurattalPage extends StatefulWidget {
  const MurattalPage({super.key});

  @override
  State<MurattalPage> createState() => _MurattalPageState();
}

class _MurattalPageState extends State<MurattalPage> {
  final List<RecitersModel> reciters = const [
    // ج) مجموعة "محمود"
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/mahmood_khaleel_al-husaree_iza3a/',
      name: 'محمود خليل الحصري - إذاعة  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/',
      name: 'محمود خليل الحصري ',
      zeroPaddingSurahNumber: false,
    ),
    // د) مجموعة "مشاري"

    RecitersModel(
      url:
          'https://download.quranicaudio.com/qdc/mishari_al_afasy/streaming/mp3/',
      name: 'مشاري العفاسي ',
      zeroPaddingSurahNumber: false,
    ),

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/nasser_bin_ali_alqatami/',
      name: 'ناصر القطامي',
      zeroPaddingSurahNumber: true,
    ),
    // 1. يبدأ برقم
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ibrahim_al_akhdar/',
      name: 'إبراهيم الأخضر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/abdul_baset/murattal/',
      name: 'عبد الباسط عبد الصمد',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/maher_256/',
      name: 'ماهر المعيقلي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/maher_almu3aiqly/year1440/',
      name: 'ماهر المعيقلي 1440  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/idrees_akbar/',
      name: 'إدريس أبكر',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/huthayfi/',
      name: 'علي بن عبدالرحمن الحذيفي  ',
      zeroPaddingSurahNumber: true,
    ),

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/ahmad_nauina/',
      name: 'أحمد نعينع',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/akram_al_alaqmi/',
      name: 'أكرم العلاقمي',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ب)
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/bandar_baleela/complete/',
      name: 'بندر بليلة - كامل  ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ت)
    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/tawfeeq_bin_saeed-as-sawaaigh/',
      name: 'توفيق الصائغ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ح)
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hatem_farid/collection/',
      name: 'حاتم فريد ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/hamad_sinan/',
      name: 'حمد سنان ',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (خ)
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/khaalid_al-qahtaanee/',
      name: 'خالد القحطاني  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/khalid_jalil/murattal/mp3/',
      name: 'خالد جليل  ',
      zeroPaddingSurahNumber: false,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/khalifah_taniji//',
      name: 'خليفة الطنيجي  ',
      zeroPaddingSurahNumber: true,
    ),

    RecitersModel(
      url:
          'https://download.quranicaudio.com/quran/sa3d_al-ghaamidi/complete//',
      name: 'سعد الغامدي',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.tvquran.com/download/TvQuran.com__Shirazad/',
      name: 'شيرزاد عبدالرحمن',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/saud_ash-shuraym/murattal/',
      name: 'سعود الشريم',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sa3ood_al-shuraym/older//',
      name: 'سعود الشريم - قديم  ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sahl_yaaseen/',
      name: 'سهل ياسين',
      zeroPaddingSurahNumber: true,
    ),

    // المجموعة (ص)
    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/sadaqat_ali/',
      name: 'صداقت علي ',
      zeroPaddingSurahNumber: true,
    ),
    RecitersModel(
      url: 'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/',
      name: 'صديق المنشاوي',
      zeroPaddingSurahNumber: false,
    ),

    RecitersModel(
      url: 'https://download.quranicaudio.com/quran/salah_alhashim/',
      name: 'صلاح الهاشم ',
      zeroPaddingSurahNumber: true,
    ),
  ];
  final TextEditingController _searchController = TextEditingController();
  List<int> filteredReciters = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    filteredReciters = List.generate(reciters.length, (index) => index);
  }

  void _filterReciter(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredReciters = List.generate(reciters.length, (index) => index);
      } else {
        filteredReciters = reciters
            .asMap()
            .entries
            .where((entry) => entry.value.name.contains(query))
            .map((entry) => entry.key)
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterReciter('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppStyles.styleCairoMedium15white(context).color,
        ),
        backgroundColor: AppColors.kSecondaryColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onSubmitted: _filterReciter,
                textInputAction: TextInputAction.search,
                style: AppStyles.styleCairoMedium15white(context),
                decoration: InputDecoration(
                  hintText: 'إبحث عن قاريء ...',
                  hintStyle: AppStyles.styleCairoMedium15white(context),
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text(
                'القران المرتل',
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _toggleSearch,
              child: Icon(_isSearching ? Icons.close : Icons.search),
            ),
          ),
        ],
      ),
      body: filteredReciters.isNotEmpty
          ? ListView.builder(
              itemCount: filteredReciters.length,
              itemBuilder: (context, index) {
                int actualIndex =
                    filteredReciters[index]; // Get the correct index from filteredReciters

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListSurahsListeningPage(
                          reciter: reciters[actualIndex], // Use actualIndex
                        ),
                      ),
                    );
                  },
                  child: RecitursItem(
                    title: reciters[actualIndex].name, // Use actualIndex
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'القاريء غير موجود',
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
            ),
    );
  }
}
