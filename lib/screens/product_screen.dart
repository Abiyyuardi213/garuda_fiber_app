import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _productsFuture;

  // Widget initialization
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Method to fetch products from ApiService
  void _loadProducts() {
    setState(() {
      _productsFuture = _apiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'Terjadi Kesalahan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadProducts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, color: Colors.grey[400], size: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'Tidak Ada Produk',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 4. Success State (Data Display)
          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  // Logic when a product is clicked
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Anda memilih: ${product.name}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
