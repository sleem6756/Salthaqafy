import 'package:dio/dio.dart';
import '../model/book.dart';
import '../model/category.dart';
import '../utils/endpoints.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  bool _isArabicTitle(String title) {
    // Check if the title contains Arabic characters
    final arabicRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    );
    return arabicRegex.hasMatch(title);
  }

  Future<List<Book>> fetchBooks({
    int page = 1,
    int perPage = 50, // Increased to load more books at once
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'per_page': perPage,
      };

      final response = await _dio.get(
        Endpoints.baseUrl + Endpoints.booksEndpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final books = (response.data as List)
            .map((json) => Book.fromJson(json))
            .where((book) => _isArabicTitle(book.title))
            .toList();
        return books;
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get(
        Endpoints.baseUrl + Endpoints.categoriesEndpoint,
        queryParameters: {
          'per_page': 100, // جلب جميع التصنيفات
        },
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Category.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}