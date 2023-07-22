import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_test/controller/connection_check_controller.dart';

class ConnectivityCheck extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ConnectivityCheck> {
  ConnectionCheckController connectionCheckController =
      Get.put(ConnectionCheckController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internet Connectivity Checker'),
      ),
      body: Obx(() => Center(
            child: connectionCheckController.isConnected.value
                ? Text('Internet is connected.')
                : Text('No internet connection.'),
          )),
    );
  }
}
