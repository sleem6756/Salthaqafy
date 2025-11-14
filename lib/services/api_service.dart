import 'package:dio/dio.dart';
import '../models/book.dart';
import '../models/category.dart';
import '../utils/endpoints.dart';
import '../utils/logger.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  bool _isArabicTitle(String title) {
    // Check if the title contains Arabic characters
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
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

  Future<String?> fetchMediaUrl(int mediaId) async {
    try {
      final response = await _dio.get(
        Endpoints.baseUrl + Endpoints.mediaEndpoint + mediaId.toString(),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // For WooCommerce products, try to get image from product data first
        if (data['images'] != null && data['images'].isNotEmpty) {
          return data['images'][0]['src'];
        }
        // Fallback to WordPress media structure
        if (data['media_details'] != null &&
            data['media_details']['sizes'] != null &&
            data['media_details']['sizes']['medium'] != null) {
          return data['media_details']['sizes']['medium']['source_url'];
        } else if (data['source_url'] != null) {
          return data['source_url'];
        }
      }
      return null;
    } catch (e) {
      AppLogger.e('Error fetching media', e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPages() async {
    try {
      final response = await _dio.get(
        Endpoints.baseUrl + Endpoints.pagesEndpoint,
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load pages');
      }
    } catch (e) {
      throw Exception('Error fetching pages: $e');
    }
  }
}
