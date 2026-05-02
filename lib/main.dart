import 'package:flutter/material.dart';
import 'screens/product_screen.dart';
import 'screens/detail_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garuda Fiber',
      debugShowCheckedModeBanner: false,

      // ThemeData konsisten
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      // Named Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductScreen(),
      },

      // Named Route dengan argument (passing argument)
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final product = settings.arguments;
          return MaterialPageRoute(
            builder: (context) =>
                DetailProdukScreen(product: product as dynamic),
          );
        }
        return null;
      },
    );
  }
}