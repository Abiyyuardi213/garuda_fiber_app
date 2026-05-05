import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  // Daftar item di keranjang
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  int get cartCount => _items.length;

  double get totalPrice {
    return _items.fold(0, (sum, item) {
      return sum + (item['product'].price * item['quantity'] * 16000);
    });
  }

  void addToCart(Product product, {int quantity = 1}) {
    int index = _items.indexWhere((item) => item['product'].id == product.id);
    
    if (index != -1) {
      _items[index]['quantity'] += quantity;
    } else {
      _items.add({
        'product': product,
        'quantity': quantity,
      });
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item['product'].id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int delta) {
    int index = _items.indexWhere((item) => item['product'].id == productId);
    if (index != -1) {
      _items[index]['quantity'] += delta;
      if (_items[index]['quantity'] <= 0) {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
