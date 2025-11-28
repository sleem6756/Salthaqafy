import 'package:althaqafy/cubit/fav_surah_cubit/fav_surah_item_cubit.dart';
import 'package:althaqafy/model/quran_models/reciters_model.dart';
import 'package:flutter/material.dart';
import 'package:althaqafy/utils/app_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quran/quran.dart' as quran;
import '../../../constants.dart';
import '../../../main.dart';
import '../../../model/audio_model.dart';
import '../../../pages/sevices/audio_handler.dart';
import '../../../widgets/surah_listening_item_widget.dart';

class ListSurahsListeningPage extends StatefulWidget {
  final RecitersModel reciter;

  const ListSurahsListeningPage({super.key, required this.reciter});

  @override
  State<ListSurahsListeningPage> createState() =>
      _ListSurahsListeningPageState();
}

class _ListSurahsListeningPageState extends State<ListSurahsListeningPage> {
  String? tappedSurahName;
  final TextEditingController _searchController = TextEditingController();
  List<int> filteredSurahs = List.generate(114, (index) => index + 1);
  bool _isSearching = false;
  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    // Don't initialize playlist here - do it lazily on first surah tap
    // This prevents auto-activation of first surah and preserves background audio
    setState(() {
      _isLoaded = true; // Mark page as ready without audio setup
    });
  }

  @override
  void dispose() {
    // DO NOT stop audio - let it continue in background
    // The global audio handler manages its own lifecycle
    super.dispose();
  }

  Future<void> _ensurePlaylistInitialized() async {
    // Check if we're already playing from this reciter
    final currentReciter = globalAudioHandler.mediaItem.value?.album;
    if (currentReciter == widget.reciter.name &&
        AudioPlayerHandler.currentPlaylist.isNotEmpty) {
      // Already on this reciter's playlist, don't reinitialize
      return;
    }

    // Different reciter or no playlist - build new playlist
    List<AudioModel> playlist = [];
    if (widget.reciter.zeroPaddingSurahNumber) {
      for (int i = 1; i <= 114; i++) {
        playlist.add(
          AudioModel(
            audioURL:
                '${widget.reciter.url}${i.toString().padLeft(3, '0')}.mp3',
            title: quran.getSurahNameArabic(i),
            album: widget.reciter.name,
          ),
        );
      }
    } else {
      for (int i = 1; i <= 114; i++) {
        playlist.add(
          AudioModel(
            audioURL: '${widget.reciter.url}$i.mp3',
            title: quran.getSurahNameArabic(i),
            album: widget.reciter.name,
          ),
        );
      }
    }

    // Initialize playlist without auto-playing
    await globalAudioHandler.initializePlaylist(
      playlist: playlist,
      album: widget.reciter.name,
    );
  }

  void updateTappedSurahName(int surahIndex) {
    if (mounted) {
      setState(() {
        tappedSurahName =
            'تشغيل سورة ${quran.getSurahNameArabic(surahIndex + 1)} الآن';
      });
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSurahs = List.generate(114, (index) => index + 1);
      } else {
        filteredSurahs = List.generate(114, (index) => index + 1)
            .where((index) => quran.getSurahNameArabic(index).contains(query))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filterSurahs(''); // Reset list when search closes.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSecondaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppStyles.styleCairoMedium15white(context).color,
        ),
        centerTitle: true,
        title: _isSearching
            ? TextField(
                style: AppStyles.styleCairoMedium15white(context),
                controller: _searchController,
                onSubmitted: _filterSurahs,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'إبحث عن سورة ...',
                  border: InputBorder.none,
                ),
                autofocus: true,
              )
            : Text(
                'استماع القران الكريم',
                style: AppStyles.styleCairoMedium15white(context),
              ),
        backgroundColor: AppColors.kPrimaryColor,
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
      body: !_isLoaded
          ? const Center(child: CircularProgressIndicator())
          : BlocConsumer<FavSurahItemCubit, FavSurahItemState>(
              listener: (context, state) {},
              builder: (context, state) {
                return ModalProgressHUD(
                  inAsyncCall: state is FavSurahItemLoading,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              widget.reciter.name,
                              style: AppStyles.styleDiodrumArabicbold20(
                                context,
                              ),
                            ),
                            if (tappedSurahName != null)
                              Text(
                                tappedSurahName!,
                                style: AppStyles.styleCairoMedium15white(
                                  context,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: filteredSurahs.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: filteredSurahs.length,
                                itemBuilder: (context, index) {
                                  final surahIndex = filteredSurahs[index] - 1;
                                  final audioUrl =
                                      widget.reciter.zeroPaddingSurahNumber
                                      ? '${widget.reciter.url}${(surahIndex + 1).toString().padLeft(3, '0')}.mp3'
                                      : '${widget.reciter.url}${surahIndex + 1}.mp3';

                                  return SurahListeningItem(
                                    index: surahIndex,
                                    audioUrl: audioUrl,
                                    onAudioTap: updateTappedSurahName,
                                    ensurePlaylistInitialized:
                                        _ensurePlaylistInitialized,
                                    reciter: widget.reciter,
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'اسم السورة غير صحيح.',
                                  style: AppStyles.styleDiodrumArabicbold20(
                                    context,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
