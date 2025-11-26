import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../widgets/book_card.dart';
import '../../widgets/shimmer_loading.dart';
import 'search_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.fetchBooks();
      bookProvider.fetchCategories();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      bookProvider.fetchBooks(isLoadMore: true);
    }
  }

  void _openSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void _refreshBooks() {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider.fetchBooks(); // This will reset and fetch from page 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الكتب'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.contact_mail),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearchPage,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBooks,
          ),
        ],
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          return Column(
            children: [
              // Certificate Image
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/cert.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),


              // Books Count Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'جميع الكتب (${bookProvider.books.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Books List
              Expanded(
                child: bookProvider.isLoading && bookProvider.books.isEmpty
                    ? const ShimmerLoading()
                    : bookProvider.books.isEmpty
                        ? const Center(
                            child: Text('لا توجد كتب'),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: bookProvider.books.length +
                                (bookProvider.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == bookProvider.books.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final book = bookProvider.books[index];
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