import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product_model.dart';
import '../../services/socket_service.dart';
import '../login/user_controller.dart';

class CatalogController extends GetxController {
  final products = <Product>[].obs;
  final scrollController = ScrollController();
  late String username; // use late instead of final
  late SocketService socketService;
  bool _isRemoteScroll = false;

  @override
  void onInit() {
    super.onInit();
    username = Get.arguments?['username'] ??
        Get.find<UserController>().username.value;

    loadMockProducts();
    socketService = Get.find<SocketService>();

    scrollController.addListener(() {
      if (_isRemoteScroll) return;
      socketService.sendScrollPosition(scrollController.offset);
    });

    socketService.onScrollReceived((offset) {
      _isRemoteScroll = true;
      scrollController.jumpTo(offset);
      _isRemoteScroll = false;
    });
  }

  void loadMockProducts() {
    products.assignAll([
      Product(id: '1', name: 'Watch', image: 'assets/images/watch.jpg', price: 120.0),
      Product(id: '2', name: 'Shoes', image: 'assets/images/shoes.jpg', price: 80.0),
      Product(id: '3', name: 'Phone', image: 'assets/images/phone.jpg', price: 400.0),
      Product(id: '4', name: 'Backpack', image: 'assets/images/backpack.jpg', price: 60.0),
      Product(id: '5', name: 'Jacket', image: 'assets/images/jacket.jpg', price: 150.0),
      Product(id: '6', name: 'Laptop', image: 'assets/images/laptop.jpg', price: 900.0),
      Product(id: '7', name: 'Headphones', image: 'assets/images/headphones.jpg', price: 200.0),
      Product(id: '8', name: 'Camera', image: 'assets/images/camera.jpg', price: 650.0),
    ]);
  }

  void scrollTo(double offset) {
    scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void listenToUserPresence() {
    socketService.onUserJoined((id) {
      Get.snackbar('User Joined', '$id joined the app');
    });
    socketService.onUserLeft((id) {
      Get.snackbar('User Left', '$id left the app');
    });
  }

  void listenForBroadcast() {
    socketService.onBroadcast((msg) {
      Get.snackbar('Admin Message', msg);
    });
  }



  @override
  void onClose() {
    scrollController.dispose();
    socketService.disposeSocket();
    super.onClose();
  }
}
