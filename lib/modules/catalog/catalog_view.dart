import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/socket_service.dart';
import '../login/user_controller.dart';
import 'catalog_controller.dart';

class CatalogView extends GetView<CatalogController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog - ${controller.username}'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () => Get.toNamed('/chat', arguments: {
              'username': controller.username,
            }),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.find<UserController>().clearUser();
              Get.delete<SocketService>();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: Obx(() => GridView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 3 / 4,
        ),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/product', arguments: product),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child:Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${product.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}
