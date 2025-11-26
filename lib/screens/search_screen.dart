import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/book_provider.dart';
import '../model/book.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_loading.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.fetchBooks();
    });
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.fetchBooks(isLoadMore: true);
    }
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(_searchController.text);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredBooks = List.from(_allBooks);
      });
      return;
    }

    final filtered = _allBooks.where((book) {
      final title = book.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery);
    }).toList();

    setState(() {
      _filteredBooks = filtered;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'البحث عن كتاب...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          // Update local books list when provider books change
          if (_allBooks.isEmpty && bookProvider.books.isNotEmpty) {
            _allBooks = List.from(bookProvider.books);
            _filteredBooks = List.from(bookProvider.books);
          }

          final List<Book> displayBooks = _searchController.text.isNotEmpty ? _filteredBooks : bookProvider.books;

          return Column(
            children: [
              // Search Results Count
              if (_searchController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'تم العثور على ${_filteredBooks.length} كتاب',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

              // Books List
              Expanded(
                child: bookProvider.isLoading && bookProvider.books.isEmpty
                    ? const ShimmerLoading()
                    : displayBooks.isEmpty
                        ? Center(
                            child: Text(
                              _searchController.text.isNotEmpty
                                  ? 'لا توجد نتائج للبحث'
                                  : 'لا توجد كتب',
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: displayBooks.length +
                                (bookProvider.isLoadingMore && _searchController.text.isEmpty ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == displayBooks.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final book = displayBooks[index];
                              final mediaUrl = book.coverImageUrl;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: BookCard(
                                  book: book,
                                  mediaUrl: mediaUrl,
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

}