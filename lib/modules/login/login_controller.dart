import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Tentative/modules/login/user_controller.dart';
import '../../services/socket_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();

  void login() async {
    final name = usernameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a name');
      return;
    }

    final userController = Get.find<UserController>();
    userController.setUser(name);

    final socketService = SocketService(name);
    await socketService.connect();

    Get.put<SocketService>(socketService);

    Get.offAllNamed(AppRoutes.CATALOG, arguments: {'username': name});
  }

  @override
  void onInit() {
    super.onInit();
    final userController = Get.find<UserController>();
    if (userController.isLoggedIn) {
      Get.offAllNamed(AppRoutes.CATALOG);
    }
  }



  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }
}
