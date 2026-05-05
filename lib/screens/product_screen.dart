import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String _selectedCategory = 'Semua';
  String _sortBy = 'Default';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() async {
    try {
      List<Product> products = await _apiService.getProducts();
      List<Category> categories = await _apiService.getCategories();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFiltersAndSort() {
    List<Product> results = _allProducts;

    // Filter Kategori
    if (_selectedCategory != 'Semua') {
      results = results.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // Search
    if (_searchController.text.isNotEmpty) {
      results = results.where((p) => p.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }

    // Sort
    if (_sortBy == 'Harga Rendah') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Harga Tinggi') {
      results.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Rating') {
      results.sort((a, b) => (b.rating?.rate ?? 0).compareTo(a.rating?.rate ?? 0));
    }

    setState(() {
      _filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        title: const Text('Global FakeStore', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return IconButton(
                icon: Badge(
                  label: Text('${cart.cartCount}'),
                  isLabelVisible: cart.cartCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                },
              );
            },
          ),
        ],
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
          _buildProdukTab(),
          _buildKategoriTab(),
          const Center(child: Text('Halaman Pembayaran')),
          const Center(child: Text('Halaman Pengiriman')),
        ],
      ),
    );
  }

  Widget _buildProdukTab() {
    final double lebarLayar = MediaQuery.of(context).size.width;
    int jumlahKolom = lebarLayar >= 600 ? 3 : 2;

    return Column(
      children: [
        // Search & Sort Header
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => _applyFiltersAndSort(),
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Urutkan:', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: _sortBy,
                    items: ['Default', 'Harga Rendah', 'Harga Tinggi', 'Rating']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _sortBy = val!);
                      _applyFiltersAndSort();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Filter Kategori dengan ChoiceChip
        Container(
          height: 50,
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                'Semua',
                ..._categories.map((c) => c.id)
              ].map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat.toUpperCase(), style: const TextStyle(fontSize: 11)),
                    selected: _selectedCategory == cat,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = cat);
                      _applyFiltersAndSort();
                    },
                    selectedColor: Colors.blue[100],
                    labelStyle: TextStyle(color: _selectedCategory == cat ? Colors.blue[900] : Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Grid Produk
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: jumlahKolom,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: _filteredProducts[index],
                      onTap: () {
                        Navigator.pushNamed(context, '/detail', arguments: _filteredProducts[index]);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildKategoriTab() {
    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return ListTile(
          title: Text(cat.categoryName),
          onTap: () {
            setState(() => _selectedCategory = cat.id);
            _applyFiltersAndSort();
            _tabController.animateTo(0);
          },
        );
      },
    );
  }
}