import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => cart.clearCart(),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      final product = item['product'] as Product;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Image.network(product.image, width: 50, fit: BoxFit.contain),
                          title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(currencyFormat.format(product.price * 16000)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.updateQuantity(product.id, -1),
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.updateQuantity(product.id, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        currencyFormat.format(cart.totalPrice),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
