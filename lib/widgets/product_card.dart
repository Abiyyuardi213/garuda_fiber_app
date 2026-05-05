import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ← penting!
          children: [
            // Gambar Produk
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1.2, // ← gambar selalu proporsional
                child: product.image != null
                    ? Image.network(
                        'https://warehouse.garudafiber.site/storage/produk/${product.image}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey, size: 40),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.image,
                            color: Colors.grey, size: 40),
                      ),
              ),
            ),

            // Info Produk
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Merek
                  Text(
                    product.merk ?? 'Garuda Fiber',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),

                  // Nama Produk
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),

                  // Kategori
                  Text(
                    product.category?.categoryName ?? 'Tanpa Kategori',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  // Harga
                  Text(
                    currencyFormat.format(product.price),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    maxLines: 1,
                  ),

                  // Satuan
                  Text(
                    'per ${product.uom?.name ?? 'Unit'}',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  SizedBox(height: 6),

                  // Tombol Beli
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onTap,
                      child: Text(
                        'Beli',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}