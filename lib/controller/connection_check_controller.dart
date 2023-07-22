import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionCheckController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // checkInternetConnectivity();
    checkInternet();
  }

  RxBool isConnected = RxBool(false);
  RxBool isInternetConnected = RxBool(false);

  // Future<void> checkInternetConnectivity() async {
  //   isInternetConnected.value = await checkInternet();
  //   isConnected.value = isInternetConnected.value;
  // }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isConnected.value = true;
      return true;
    } else {
      isConnected.value = false;
      return false;
    }
  }
}
