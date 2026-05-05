import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/payment_method_model.dart';
import '../models/shipping_service_model.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Fetch all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = json.decode(response.body);
        return categoriesJson.map((name) => Category(
          id: name,
          categoryName: name.toString().toUpperCase(),
          description: 'Kategori produk $name',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        )).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Mock payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    return [
      PaymentMethod(
        id: '1',
        namaBank: 'BCA Transfer',
        nomorRekening: '1234567890',
        atasNama: 'FAKE STORE',
        deskripsi: 'Transfer bank manual ke rekening BCA',
        status: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PaymentMethod(
        id: '2',
        namaBank: 'Mandiri Transfer',
        nomorRekening: '0987654321',
        atasNama: 'FAKE STORE',
        deskripsi: 'Transfer bank manual ke rekening Mandiri',
        status: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Mock shipping services
  Future<List<ShippingService>> getShippingServices() async {
    return [
      ShippingService(
        id: '1',
        nama: 'JNE Reguler',
        kode: 'JNE-REG',
        biayaDasar: 15000,
        status: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ShippingService(
        id: '2',
        nama: 'J&T Express',
        kode: 'JNT-EXP',
        biayaDasar: 12000,
        status: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  // Mock checkout
  Future<Map<String, dynamic>> checkout(Map<String, dynamic> checkoutData) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      'status': 'success',
      'message': 'Pesanan berhasil dibuat!',
      'order_id': 'ORD-${DateTime.now().millisecondsSinceEpoch}'
    };
  }
}
