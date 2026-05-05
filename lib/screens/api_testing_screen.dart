import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/payment_method_model.dart';
import '../models/shipping_service_model.dart';
import '../widgets/product_card.dart';
import 'package:intl/intl.dart';

class ApiTestingScreen extends StatefulWidget {
  const ApiTestingScreen({super.key});

  @override
  State<ApiTestingScreen> createState() => _ApiTestingScreenState();
}

class _ApiTestingScreenState extends State<ApiTestingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeStore API Test'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Produk', icon: Icon(Icons.inventory)),
            Tab(text: 'Kategori', icon: Icon(Icons.category)),
            Tab(text: 'Pembayaran', icon: Icon(Icons.payment)),
            Tab(text: 'Pengiriman', icon: Icon(Icons.local_shipping)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductTab(),
          _buildCategoryTab(),
          _buildPaymentTab(),
          _buildShippingTab(),
        ],
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator(color: Colors.blue));

  Widget _buildError(Object? error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Error: $error', textAlign: TextAlign.center),
          ],
        ),
      );

  Widget _buildEmpty() => const Center(child: Text('Data tidak ditemukan'));

  Widget _buildProductTab() {
    return FutureBuilder<List<Product>>(
      future: _apiService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty();

        final products = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: products[index],
              onTap: () {},
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryTab() {
    return FutureBuilder<List<Category>>(
      future: _apiService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error);
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmpty();

        final categories = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final cat = categories[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.label)),
              title: Text(cat.categoryName),
              subtitle: Text(cat.description),
              trailing: const Icon(Icons.chevron_right),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentTab() {
    return FutureBuilder<List<PaymentMethod>>(
      future: _apiService.getPaymentMethods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error);
        final methods = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final pm = methods[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance, color: Colors.blue),
                title: Text(pm.namaBank),
                subtitle: Text('No: ${pm.nomorRekening}\nA/N: ${pm.atasNama}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShippingTab() {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return FutureBuilder<List<ShippingService>>(
      future: _apiService.getShippingServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoading();
        if (snapshot.hasError) return _buildError(snapshot.error);
        final services = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final s = services[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.local_shipping, color: Colors.orange),
                title: Text(s.nama),
                subtitle: Text('Kode: ${s.kode}'),
                trailing: Text(
                  currencyFormat.format(s.biayaDasar),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
