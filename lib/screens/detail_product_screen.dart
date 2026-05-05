import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class DetailProdukScreen extends StatefulWidget {
  final Product product;

  const DetailProdukScreen({super.key, required this.product});

  @override
  State<DetailProdukScreen> createState() => _DetailProdukScreenState();
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  int _jumlah = 1;

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    Product p = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Produk'),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Image.network(p.image, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.category.toUpperCase(), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(p.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(currencyFormat.format(p.price * 16000), style: const TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(p.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => _jumlah > 1 ? _jumlah-- : null)),
                Text('$_jumlah'),
                IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _jumlah++)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addToCart(p, quantity: _jumlah);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$_jumlah item ditambahkan')),
                  );
                },
                child: const Text('Beli Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}