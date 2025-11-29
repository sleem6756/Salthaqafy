import 'package:althaqafy/cubit/azkar_cubit/azkar_cubit.dart';
import 'package:althaqafy/cubit/azkar_cubit/azkar_state.dart';
import 'package:althaqafy/cubit/ruqiya_cubit/ruqiya_cubit.dart'; // Added for Ruqiya filtering
import 'package:althaqafy/model/azkar_model/azkar_model/azkar_model.dart';
import 'package:althaqafy/pages/azkar_pages/fav_azkar_page.dart';
import 'package:althaqafy/pages/azkar_pages/zekr_page.dart';
import 'package:althaqafy/pages/ruqiya_pages/ruqiya_page.dart'; // For RuqiyaItem
import 'package:althaqafy/utils/app_style.dart';
import 'package:althaqafy/widgets/reciturs_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';

class AzkarPage extends StatefulWidget {
  const AzkarPage({super.key});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage>
    with SingleTickerProviderStateMixin {
  // Controllers and Focus
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // State
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load Azkar data
    final azkarCubit = context.read<AzkarCubit>();
    azkarCubit.loadAzkar();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // FIXED SEARCH CRASH: Use onSubmitted instead of onChanged to prevent rapid state updates
  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        // Show search field and request focus
        _searchFocusNode.requestFocus();
      } else {
        // Clear search and reset query
        _searchController.clear();
        _searchQuery = "";
        _searchFocusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppStyles.styleCairoMedium15white(context).color,
        ),
        backgroundColor: AppColors.kSecondaryColor,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: _performSearch, // Trigger search on enter/submit
                style: AppStyles.styleCairoMedium15white(context),
                decoration: InputDecoration(
                  hintText: 'إبحث عن ذكر ...',
                  hintStyle: AppStyles.styleCairoMedium15white(context),
                  border: InputBorder.none,
                  // Add clear button inside the field
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch(""); // Clear results immediately
                    },
                  ),
                ),
              )
            : Text(
                'الأذكار',
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
        actions: [
          if (!_isSearching) // Only show search icon when not searching
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _toggleSearch,
                child: const Icon(Icons.search),
              ),
            ),
          if (_isSearching) // Show close button when searching
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _toggleSearch,
                child: const Icon(Icons.close),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: AppStyles.styleDiodrumArabicbold20(context),
          unselectedLabelStyle: AppStyles.styleDiodrumArabicbold20(
            context,
          ).copyWith(color: Colors.grey),
          tabs: const [
            Tab(text: "ذكر"),
            Tab(text: "الرقية"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // First Tab: Azkar List
          _buildAzkarTab(),
          // Second Tab: Ruqiya List (Inlined to support filtering)
          _buildRuqiyaTab(),
        ],
      ),
    );
  }

  Widget _buildAzkarTab() {
    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        if (state is AzkarLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state is AzkarLoaded) {
          // Filter logic
          List<AzkarModel> azkarToDisplay = state.azkar;
          if (_searchQuery.isNotEmpty) {
            azkarToDisplay = state.azkar.where((azkar) {
              return azkar.category != null &&
                  azkar.category!.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
            }).toList();
          }

          if (azkarToDisplay.isEmpty) {
            return Center(
              child: Text(
                "لا توجد نتائج",
                style: AppStyles.styleDiodrumArabicbold20(context),
              ),
            );
          }

          return ListView.builder(
            itemCount: azkarToDisplay.length + (_searchQuery.isEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              // Show "Fav Azkar" item only when NOT searching and at index 0
              if (_searchQuery.isEmpty && index == 0) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FavAzkarPage()),
                    );
                  },
                  child: const RecitursItem(title: "أذكاري المفضلة"),
                );
              }

              final actualIndex = _searchQuery.isEmpty ? index - 1 : index;
              final item = azkarToDisplay[actualIndex];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ZekrPage(
                        zekerCategory: item.category!,
                        zekerList: item.array!,
                      ),
                    ),
                  );
                },
                child: RecitursItem(title: "${item.category}"),
              );
            },
          );
        } else if (state is AzkarError) {
          return const Center(child: Text("حدث خطأ في تحميل الأذكار"));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildRuqiyaTab() {
    // Re-implementing RuqiyaPage logic here to allow filtering
    return BlocProvider(
      create: (context) => RuqiyaCubit()..loadRuqiya(),
      child: BlocBuilder<RuqiyaCubit, RuqiyaState>(
        builder: ((context, state) {
          if (state is RuqiyaLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is RuqiyaLoaded) {
            // Filter logic for Ruqiya
            var ruqiyaToDisplay = state.ruqiya;
            if (_searchQuery.isNotEmpty) {
              ruqiyaToDisplay = state.ruqiya.where((item) {
                final textMatch =
                    item.text != null &&
                    item.text!.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    );
                final infoMatch =
                    item.info != null &&
                    item.info!.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    );
                return textMatch || infoMatch;
              }).toList();
            }

            if (ruqiyaToDisplay.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد نتائج",
                  style: AppStyles.styleDiodrumArabicbold20(context),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: ruqiyaToDisplay.length,
                itemBuilder: (context, index) {
                  return RuqiyaItem(
                    text: ruqiyaToDisplay[index].text!,
                    info: ruqiyaToDisplay[index].info!,
                  );
                },
              ),
            );
          } else if (state is RuqiyaError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
