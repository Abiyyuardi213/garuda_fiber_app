class Uom {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Uom({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Uom.fromJson(Map<String, dynamic> json) {
    return Uom(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
