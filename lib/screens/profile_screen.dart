import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Abiyyu Ardilian',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'abiyyu@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu List
            _buildMenuItem(Icons.shopping_bag_outlined, 'Pesanan Saya', () {}),
            _buildMenuItem(Icons.favorite_outline, 'Favorit', () {}),
            _buildMenuItem(Icons.location_on_outlined, 'Alamat Pengiriman', () {}),
            _buildMenuItem(Icons.payment_outlined, 'Metode Pembayaran', () {}),
            const Divider(),
            _buildMenuItem(Icons.settings_outlined, 'Pengaturan', () {}),
            _buildMenuItem(Icons.help_outline, 'Pusat Bantuan', () {}),
            _buildMenuItem(Icons.logout, 'Keluar', () {}, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blue[800]),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
