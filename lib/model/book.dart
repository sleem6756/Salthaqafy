class Book {
  final int id;
  final String title;
  final String pdfUrl;
  final String? coverImageUrl;
  final DateTime? dateGmt;

  Book({
    required this.id,
    required this.title,
    required this.pdfUrl,
    this.coverImageUrl,
    this.dateGmt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    DateTime? dateGmt;
    if (json['date_gmt'] != null) {
      try {
        dateGmt = DateTime.parse(json['date_gmt']);
      } catch (e) {
        dateGmt = null;
      }
    }

    return Book(
      id: json['id'],
      title: json['title']['rendered'] ?? '',
      pdfUrl: json['source_url'] ?? '',
      coverImageUrl: json['media_details']?['sizes']?['medium']?['source_url'] ??
                    json['media_details']?['sizes']?['full']?['source_url'],
      dateGmt: dateGmt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'rendered': title},
      'source_url': pdfUrl,
      'date_gmt': dateGmt?.toIso8601String(),
      'media_details': {
        'sizes': {
          'medium': {'source_url': coverImageUrl},
          'full': {'source_url': coverImageUrl},
        },
      },
    };
  }
}