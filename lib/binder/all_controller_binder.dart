import 'package:get/get.dart';
import 'package:hive_test/controller/connection_check_controller.dart';
import 'package:hive_test/controller/home_controller.dart';

class AllControllerBinder implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<ConnectionCheckController>(ConnectionCheckController());
  }
}
