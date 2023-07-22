import 'package:get/get.dart';
import 'package:hive_test/controller/home_controller.dart';

class AllControllerBinder implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController()); //Controller name
  }
}
