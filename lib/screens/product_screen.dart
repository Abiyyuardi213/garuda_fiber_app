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
  tabAlignment: TabAlignment.start,
  indicatorColor: Colors.white,
  indicatorWeight: 3,
  indicatorSize: TabBarIndicatorSize.label,
  dividerColor: Colors.transparent,
  labelColor: Colors.white,
  unselectedLabelColor: Colors.white54,
  labelStyle: const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ),
  unselectedLabelStyle: const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  ),
  tabs: const [
    Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 16),
          SizedBox(width: 6),
          Text('Produk'),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.category_outlined, size: 16),
          SizedBox(width: 6),
          Text('Kategori'),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payment_outlined, size: 16),
          SizedBox(width: 6),
          Text('Pembayaran'),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping_outlined, size: 16),
          SizedBox(width: 6),
          Text('Pengiriman'),
        ],
      ),
    ),
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
  int jumlahKolom = lebarLayar >= 1200 ? 4 : lebarLayar >= 600 ? 3 : 2;

  return CustomScrollView(
    slivers: [
      // Hero banner
      SliverToBoxAdapter(child: _buildHeroBanner()),

      // Chip kategori
      SliverToBoxAdapter(child: _buildChipKategori()),

      // Filter & sort
      SliverToBoxAdapter(child: _buildFilterSort()),

      // Info produk
      SliverToBoxAdapter(child: _buildInfoProduk()),

      // Loading state
      if (_isLoading)
        const SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF1565C0)),
                SizedBox(height: 12),
                Text('Memuat produk...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        )

      // Empty state
      else if (_filteredProducts.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, color: Colors.grey[400], size: 80),
                const SizedBox(height: 16),
                const Text('Produk tidak ditemukan', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _selectedCategory = 'Semua');
                    _applyFiltersAndSort();
                  },
                  child: const Text('Reset Filter'),
                ),
              ],
            ),
          ),
        )

      // Grid produk
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(
                product: _filteredProducts[index],
                onTap: () => Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: _filteredProducts[index],
                ),
              ),
              childCount: _filteredProducts.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: jumlahKolom,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: lebarLayar >= 1200 ? 0.72 : lebarLayar >= 600 ? 0.68 : 0.62,
            ),
          ),
        ),
    ],
  );
}

// ── HERO BANNER ──────────────────────────────────────────
Widget _buildHeroBanner() {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting + ikon dekoratif
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang! 👋',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Temukan ', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'Produk\n', style: TextStyle(color: Color(0xFF90CAF9))),
                        TextSpan(text: 'terbaik untukmu', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _decoIcon(Icons.shopping_bag_outlined),
                const SizedBox(height: 8),
                _decoIcon(Icons.local_offer_outlined),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Stats pills
        Row(
          children: [
            _statPill(Icons.inventory_2_outlined, '${_allProducts.length} Produk'),
            const SizedBox(width: 8),
            _statPill(Icons.category_outlined, '${_categories.length} Kategori'),
            const SizedBox(width: 8),
            _statPill(Icons.star_outline, 'Top rated'),
          ],
        ),
        const SizedBox(height: 12),

        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => _applyFiltersAndSort(),
            decoration: const InputDecoration(
              hintText: 'Cari produk...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Promo cards scrollable
        SizedBox(
          height: 72,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _promoCard('PROMO HARI INI', 'Diskon s/d 30%', 'Produk pilihan'),
              _promoCard('GRATIS ONGKIR', 'Min. belanja 100rb', 'Semua wilayah'),
              _promoCard('FLASH SALE', 'Tiap Jumat jam 12', 'Stok terbatas'),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    ),
  );
}

Widget _decoIcon(IconData icon) {
  return Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: Colors.white, size: 18),
  );
}

Widget _statPill(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(99),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF90CAF9)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    ),
  );
}

Widget _promoCard(String tag, String title, String sub) {
  return Container(
    width: 140,
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(tag, style: const TextStyle(color: Color(0xFF90CAF9), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    ),
  );
}

// ── CHIP KATEGORI CEPAT ───────────────────────────────────
Widget _buildChipKategori() {
  final List<Map<String, dynamic>> chipItems = [
    {'label': 'Semua', 'icon': Icons.grid_view_rounded, 'value': 'Semua'},
    ..._categories.map((c) => {
      'label': c.categoryName,
      'icon': Icons.label_outline,
      'value': c.id,
    }),
  ];

  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori cepat',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: chipItems.map((item) {
              final bool isActive = _selectedCategory == item['value'];
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = item['value']);
                  _applyFiltersAndSort();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF1565C0) : Colors.white,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: isActive ? const Color(0xFF1565C0) : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 14,
                        color: isActive ? Colors.white : Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? Colors.white : Colors.grey[700],
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

// ── FILTER & SORT ─────────────────────────────────────────
Widget _buildFilterSort() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune, size: 16, color: Colors.blue[800]),
                  const SizedBox(width: 6),
                  Text('Filter', style: TextStyle(fontSize: 13, color: Colors.blue[800], fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: _showSortSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sort, size: 16, color: Colors.blue[800]),
                  const SizedBox(width: 6),
                  Text(
                    _sortBy == 'Default' ? 'Urutkan' : _sortBy,
                    style: TextStyle(fontSize: 13, color: Colors.blue[800], fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ── INFO PRODUK ───────────────────────────────────────────
Widget _buildInfoProduk() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_filteredProducts.length} Produk',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        if (_selectedCategory != 'Semua')
          GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = 'Semua');
              _applyFiltersAndSort();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.close, size: 12, color: Colors.red[400]),
                  const SizedBox(width: 4),
                  Text('Reset Filter', style: TextStyle(fontSize: 11, color: Colors.red[400])),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

// ── BOTTOM SHEETS ─────────────────────────────────────────
void _showFilterSheet() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 10), width: 40, height: 4,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Icon(Icons.tune, color: Colors.blue[800]),
            const SizedBox(width: 8),
            const Text('Filter Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
        ),
        const Divider(),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: ['Semua', ..._categories.map((c) => c.categoryName)].map((nama) {
              bool dipilih = _selectedCategory == nama || (_selectedCategory == 'Semua' && nama == 'Semua');
              return ListTile(
                leading: Icon(dipilih ? Icons.check_circle : Icons.circle_outlined,
                  color: dipilih ? Colors.blue[800] : Colors.grey, size: 20),
                title: Text(nama, style: TextStyle(fontSize: 13,
                  fontWeight: dipilih ? FontWeight.bold : FontWeight.normal,
                  color: dipilih ? Colors.blue[800] : Colors.black87)),
                onTap: () {
                  setState(() => _selectedCategory = nama == 'Semua' ? 'Semua'
                    : _categories.firstWhere((c) => c.categoryName == nama).id);
                  _applyFiltersAndSort();
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}

void _showSortSheet() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 10), width: 40, height: 4,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Icon(Icons.sort, color: Colors.blue[800]),
            const SizedBox(width: 8),
            const Text('Urutkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
        ),
        const Divider(),
        ...['Default', 'Harga Rendah', 'Harga Tinggi', 'Rating'].map((sort) {
          bool dipilih = _sortBy == sort;
          return ListTile(
            leading: Icon(dipilih ? Icons.check_circle : Icons.circle_outlined,
              color: dipilih ? Colors.blue[800] : Colors.grey, size: 20),
            title: Text(sort, style: TextStyle(fontSize: 13,
              fontWeight: dipilih ? FontWeight.bold : FontWeight.normal,
              color: dipilih ? Colors.blue[800] : Colors.black87)),
            onTap: () {
              setState(() => _sortBy = sort);
              _applyFiltersAndSort();
              Navigator.pop(context);
            },
          );
        }),
        const SizedBox(height: 16),
      ],
    ),
  );
}

 Widget _buildKategoriTab() {
  return Column(
    children: [
      // Header
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[700]!],
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
              '${_categories.length} kategori tersedia',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),

      // List Kategori
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
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
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  cat.categoryName.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
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
                onTap: () {
                  setState(() => _selectedCategory = cat.id);
                  _applyFiltersAndSort();
                  _tabController.animateTo(0);
                },
              ),
            );
          },
        ),
      ),
    ],
  );
 }
    }