import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_test/binder/all_controller_binder.dart';
import 'package:hive_test/dao/cart_dao.dart';
import 'package:hive_test/database/database.dart';
import 'package:hive_test/screen/connectivity_check.dart';
import 'package:hive_test/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('edmt_cart_system.db').build();
  final dao = database.cartDAO;
  AllControllerBinder().dependencies();
  runApp(MyApp(dao: dao));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CartDAO? dao;

  MyApp({super.key, this.dao});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ProductScreen(),
    );
  }
}
