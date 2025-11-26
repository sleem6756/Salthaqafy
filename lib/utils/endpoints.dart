class Endpoints {
  // الـ Base URL الخاص بالـ WordPress REST API
  static const String baseUrl = 'https://salthaqafy.com/wp-json/wp/v2';

  // المسارات المحدثة
  static const String booksEndpoint = '/media?mime_type=application/pdf'; // للكتب (ملفات PDF فقط)
  static const String categoriesEndpoint = '/product_cat'; // لتصنيفات WooCommerce
  static const String pagesEndpoint = '/pages';          // للصفحات الثابتة
  static const String mediaEndpoint = '/media/';         // للصور
}