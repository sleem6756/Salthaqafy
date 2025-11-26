class Category {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int parent;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.parent,
    required this.count,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      parent: json['parent'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'parent': parent,
      'count': count,
    };
  }
}