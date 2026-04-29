import 'category_model.dart';
import 'uom_model.dart';

class Product {
  final String id;
  final String sku;
  final String name;
  final String description;
  final double price;
  final double weight;
  final int minStock;
  final int maxStock;
  final String categoryId;
  final String? merk;
  final String? dimensi;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;
  final Uom? uom;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.minStock,
    required this.maxStock,
    required this.categoryId,
    this.merk,
    this.dimensi,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.uom,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      weight: double.tryParse(json['weight'].toString()) ?? 0.0,
      minStock: json['min_stock'] ?? 0,
      maxStock: json['max_stock'] ?? 0,
      categoryId: json['category_id'] ?? '',
      merk: json['merk'],
      dimensi: json['dimensi'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      uom: json['uom'] != null ? Uom.fromJson(json['uom']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'description': description,
      'price': price,
      'weight': weight,
      'min_stock': minStock,
      'max_stock': maxStock,
      'category_id': categoryId,
      'merk': merk,
      'dimensi': dimensi,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category': category?.toJson(),
      'uom': uom?.toJson(),
    };
  }
}
