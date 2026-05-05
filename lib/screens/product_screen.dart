import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/payment_method_model.dart';
import '../models/shipping_service_model.dart';
import '../widgets/product_card.dart';

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

  // Ambil data produk dan kategori dari API
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

  // Filter produk berdasarkan kategori
  void _filterByCategory(String categoryName) {
    setState(() {
      _selectedCategory = categoryName;
      if (categoryName == 'Semua') {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((p) => p.category?.categoryName == categoryName)
            .toList();
      }
    });
  }

  // Cari produk berdasarkan keyword
  void _searchProduct(String keyword) {
    setState(() {
      _filteredProducts = _allProducts
          .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.wifi, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Garuda Fiber',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
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
          _buildPembayaranTab(),
          _buildPengirimanTab(),
        ],
      ),
    );
  }

  Widget _buildProdukTab() {
    // Responsif berdasarkan lebar layar
    final double lebarLayar = MediaQuery.of(context).size.width;
    int jumlahKolom = 2;
    if (lebarLayar >= 1200) {
      jumlahKolom = 4; // desktop
    } else if (lebarLayar >= 600) {
      jumlahKolom = 3; // tablet
    }

    return Column(
      children: [
        // Header Banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang! 👋',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                'Temukan perangkat\njaringan terbaik',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchProduct,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Filter Kategori
       // Tombol Filter Kategori
Container(
  color: Colors.white,
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '${_filteredProducts.length} Produk',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
      GestureDetector(
        onTap: () {
          // Tampilkan bottom sheet kategori
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          'Pilih Kategori',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // List kategori
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        'Semua',
                        ..._categories.map((c) => c.categoryName)
                      ].map((nama) {
                        bool dipilih = _selectedCategory == nama;
                        return ListTile(
                          leading: Icon(
                            dipilih
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: dipilih
                                ? Colors.blue[800]
                                : Colors.grey,
                            size: 20,
                          ),
                          title: Text(
                            nama,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: dipilih
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: dipilih
                                  ? Colors.blue[800]
                                  : Colors.black87,
                            ),
                          ),
                          onTap: () {
                            _filterByCategory(nama);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.tune, size: 16, color: Colors.blue[800]),
              SizedBox(width: 6),
              Text(
                _selectedCategory == 'Semua'
                    ? 'Filter'
                    : _selectedCategory,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),

        // Info jumlah produk
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredProducts.length} Produk',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                _selectedCategory,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),

        // Grid Produk
        Expanded(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue[800]),
                      SizedBox(height: 12),
                      Text('Memuat produk...',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              color: Colors.grey[400], size: 80),
                          SizedBox(height: 16),
                          Text(
                            'Produk tidak ditemukan',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              _filterByCategory('Semua');
                            },
                            child: Text('Reset Filter'),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: jumlahKolom, // responsif
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: _filteredProducts[index],
                          onTap: () {
                            // Navigasi ke detail produk dengan passing argument
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: _filteredProducts[index],
                            );
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildKategoriTab() {
    return FutureBuilder<List<Category>>(
      future: _apiService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Colors.blue[800]));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Data tidak ditemukan'));
        }
        final categories = snapshot.data!;
        return Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[900]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategori Produk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${categories.length} kategori tersedia',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // List Kategori
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.category_outlined,
                          color: Colors.blue[800],
                          size: 24,
                        ),
                      ),
                      title: Text(
                        cat.categoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          cat.description,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.blue[800],
                          size: 20,
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPembayaranTab() {
    return FutureBuilder<List<PaymentMethod>>(
      future: _apiService.getPaymentMethods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Colors.blue[800]));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Data tidak ditemukan'));
        }
        final methods = snapshot.data!;
        return Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[900]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${methods.length} metode tersedia',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // List Pembayaran
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: methods.length,
                itemBuilder: (context, index) {
                  final pm = methods[index];

                  // Tentukan icon dan warna berdasarkan nama bank
                  IconData icon = Icons.account_balance;
                  Color warna = Colors.blue[800]!;
                  String namaLower = pm.namaBank.toLowerCase();

                  if (namaLower.contains('mandiri')) {
                    icon = Icons.account_balance;
                    warna = Colors.yellow[800]!;
                  } else if (namaLower.contains('bca')) {
                    icon = Icons.account_balance;
                    warna = Colors.blue[800]!;
                  } else if (namaLower.contains('bni')) {
                    icon = Icons.account_balance;
                    warna = Colors.orange[800]!;
                  } else if (namaLower.contains('bri')) {
                    icon = Icons.account_balance;
                    warna = Colors.blue[900]!;
                  } else if (namaLower.contains('gopay')) {
                    icon = Icons.account_balance_wallet;
                    warna = Colors.green[700]!;
                  } else if (namaLower.contains('dana')) {
                    icon = Icons.account_balance_wallet;
                    warna = Colors.blue[600]!;
                  } else if (namaLower.contains('ovo')) {
                    icon = Icons.account_balance_wallet;
                    warna = Colors.purple[700]!;
                  } else if (namaLower.contains('spay') ||
                      namaLower.contains('shopee')) {
                    icon = Icons.account_balance_wallet;
                    warna = Colors.orange[700]!;
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: warna.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: warna, size: 24),
                      ),
                      title: Text(
                        pm.namaBank,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'No: ${pm.nomorRekening}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            'A/N: ${pm.atasNama}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: warna.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.chevron_right,
                            color: warna, size: 20),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPengirimanTab() {
    final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return FutureBuilder<List<ShippingService>>(
      future: _apiService.getShippingServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Colors.blue[800]));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Data tidak ditemukan'));
        }
        final services = snapshot.data!;
        return Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[900]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jasa Pengiriman',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${services.length} jasa pengiriman tersedia',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // List Pengiriman
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final s = services[index];

                  // Warna berdasarkan nama jasa pengiriman
                  Color warna = Colors.orange[700]!;
                  String namaLower = s.nama.toLowerCase();
                  if (namaLower.contains('jne')) {
                    warna = Colors.orange[800]!;
                  } else if (namaLower.contains('j&t') ||
                      namaLower.contains('jnt')) {
                    warna = Colors.red[700]!;
                  } else if (namaLower.contains('indah')) {
                    warna = Colors.green[700]!;
                  } else if (namaLower.contains('sicepat')) {
                    warna = Colors.orange[600]!;
                  } else if (namaLower.contains('anteraja')) {
                    warna = Colors.yellow[800]!;
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: warna.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          color: warna,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        s.nama,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Kode: ${s.kode}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          currencyFormat.format(s.biayaDasar),
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}