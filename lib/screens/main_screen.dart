import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import '../providers/cart_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProductScreen(), // Halaman Katalog
    const CartScreen(),    // Halaman Keranjang
    const ProfileScreen(), // Halaman Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil jumlah item dari provider
    final int count = context.watch<CartProvider>().cartCount;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('$count'),
              isLabelVisible: count > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              label: Text('$count'),
              isLabelVisible: count > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
