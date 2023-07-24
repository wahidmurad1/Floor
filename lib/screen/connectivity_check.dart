import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_test/controller/connection_check_controller.dart';

class ConnectivityCheck extends StatelessWidget {
  ConnectivityCheck({super.key});

  final ConnectionCheckController connectionCheckController =
      Get.put(ConnectionCheckController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internet Connectivity Checker'),
      ),
      body: Obx(() => Center(
            child: connectionCheckController.isConnected.value
                ? const Text('Internet is connected.')
                : const Text('No internet connection.'),
          )),
    );
  }
}
