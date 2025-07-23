import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  final _box = GetStorage();
  var username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    username.value = _box.read('username') ?? '';
  }

  void setUser(String name) {
    username.value = name;
    _box.write('username', name);
  }

  void clearUser() {
    username.value = '';
    _box.remove('username');
  }

  bool get isLoggedIn => username.value.isNotEmpty;
}
