import 'package:get/get.dart';
import '../modules/catalog/product_detail_view.dart';
import '../modules/login/login_view.dart';
import '../modules/catalog/catalog_view.dart';
import '../modules/chat/chat_view.dart';
import '../modules/login/login_controller.dart';
import '../modules/catalog/catalog_controller.dart';
import '../modules/chat/chat_controller.dart';
import '../modules/login/splash_view.dart';

class AppPages {
  static final pages = [
    GetPage(name: '/', page: () => SplashView()),
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => LoginController())),
    ),
    GetPage(
      name: '/catalog',
      page: () => CatalogView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => CatalogController())),
    ),
    GetPage(
      name: '/chat',
      page: () => ChatView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => ChatController())),
    ),
    GetPage(
      name: '/product',
      page: () => ProductDetailView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => CatalogController())),
    ),
  ];
}
