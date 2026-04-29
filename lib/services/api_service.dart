import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/payment_method_model.dart';
import '../models/shipping_service_model.dart';

class ApiService {
  static const String baseUrl = 'https://warehouse.garudafiber.site/api';

  // Fetch all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kategori'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> categoriesJson = data['data'];
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
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
      final response = await http.get(Uri.parse('$baseUrl/produk'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['data'];
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch all payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/metode-pembayaran'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> paymentMethodsJson = data['data'];
        return paymentMethodsJson.map((json) => PaymentMethod.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payment methods: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching payment methods: $e');
    }
  }

  // Fetch all shipping services
  Future<List<ShippingService>> getShippingServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jasa-pengiriman'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> shippingServicesJson = data['data'];
        return shippingServicesJson.map((json) => ShippingService.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load shipping services: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching shipping services: $e');
    }
  }

  // Checkout POST request
  Future<Map<String, dynamic>> checkout(Map<String, dynamic> checkoutData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(checkoutData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Checkout failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during checkout: $e');
    }
  }
}
