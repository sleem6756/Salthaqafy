import 'package:flutter/material.dart';
import '../model/book.dart';
import '../model/category.dart';
import '../services/api_service.dart';
import '../utils/logger.dart';

class BookProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  final List<Book> _books = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreBooks = true;
  int _currentPage = 1;
  int? _selectedCategoryId;

  List<Book> get books => _books;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreBooks => _hasMoreBooks;
  int? get selectedCategoryId => _selectedCategoryId;

  Future<void> fetchBooks({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (_isLoadingMore || !_hasMoreBooks) return;
      _isLoadingMore = true;
    } else {
      _isLoading = true;
      _books.clear();
      _currentPage = 1;
      _hasMoreBooks = true;
    }

    notifyListeners();

    try {
      final newBooks = await _apiService.fetchBooks(
        page: _currentPage,
      );

      if (newBooks.isEmpty) {
        _hasMoreBooks = false;
      } else {
        _books.addAll(newBooks);
        _currentPage++;

        // Note: With the new media structure, cover images are already included
        // in the book.coverImageUrl field from the media_details
      }
    } catch (e) {
      AppLogger.e('Error fetching books', e);
      _hasMoreBooks = false;
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.fetchCategories();
    } catch (e) {
      AppLogger.e('Error fetching categories', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Note: getMediaUrl method is no longer needed since cover images are included in the book model
}