import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';

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
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        title: Text(
          'Garuda Fiber',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.white,
              child: p.image != null
                  ? Image.network(
                      'https://warehouse.garudafiber.site/storage/produk/${p.image}',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey, size: 80),
                      ),
                    )
                  : Center(
                      child: Icon(Icons.image, color: Colors.grey, size: 80),
                    ),
            ),

            // Info Produk
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      p.category?.categoryName ?? 'Tanpa Kategori',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  // Nama Produk
                  Text(
                    p.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),

                  // Merek
                  Text(
                    p.merk ?? 'Garuda Fiber',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Harga
                  Text(
                    currencyFormat.format(p.price),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'per ${p.uom?.name ?? 'Unit'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 12),

                  Divider(),
                  SizedBox(height: 8),

                  // SKU
                  Row(
                    children: [
                      Text('SKU: ',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      Text(p.sku,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 4),

                  // Dimensi
                  if (p.dimensi != null)
                    Row(
                      children: [
                        Text('Dimensi: ',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        Text(p.dimensi!,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  SizedBox(height: 4),

                  // Berat
                  Row(
                    children: [
                      Text('Berat: ',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      Text('${p.weight} kg',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            // Deskripsi
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    p.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Pilih Jumlah
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jumlah Pesanan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Tombol minus
                      GestureDetector(
                        onTap: () {
                          if (_jumlah > 1) {
                            setState(() => _jumlah--);
                          }
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(Icons.remove, size: 18),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '$_jumlah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16),
                      // Tombol plus
                      GestureDetector(
                        onTap: () {
                          setState(() => _jumlah++);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(Icons.add, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 100),
          ],
        ),
      ),

      // Tombol Bawah
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            // Tambah ke Keranjang
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart_outlined,
                    color: Colors.blue[800]),
                label: Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(color: Colors.blue[800], fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.blue[800]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            // Beli Sekarang
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Beli Sekarang',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}