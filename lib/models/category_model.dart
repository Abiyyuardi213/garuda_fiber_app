class Category {
  final String id;
  final String categoryName;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      categoryName: json['category_name'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
