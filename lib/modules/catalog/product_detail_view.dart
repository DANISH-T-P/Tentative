import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/product_model.dart';
import 'catalog_controller.dart';

class ProductDetailView extends GetView<CatalogController> {
  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  product.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
                )

              ),
              const SizedBox(height: 20),
              Text(
                product.name,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, color: Colors.green[700]),
              ),
              const SizedBox(height: 30),
              Divider(),
              const SizedBox(height: 10),
              Text(
                "Product Description:\n\nThis is a high-quality ${product.name} ideal for daily use. It combines durability, design, and value. Perfect for those who want quality and style at an affordable price.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar("Info", "${product.name} added to cart!");
                },
                child: Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
