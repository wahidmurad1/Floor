import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_test/const/text.dart';
import 'package:hive_test/controller/connection_check_controller.dart';
import 'package:hive_test/controller/home_controller.dart';
import 'package:hive_test/model/product_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final ConnectionCheckController connectionCheckController =
      Get.find<ConnectionCheckController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(kSAppbar),
          centerTitle: true,
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: homeController.productList.length,
            itemBuilder: (context, index) {
              ProductModel product = homeController.productList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ListTile(
                  leading: Image.network(
                    product.image,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return SizedBox(
                        child: Image.asset('assets/image/network_error.webp'),
                      );
                    },
                  ),
                  title: Text(product.title),
                  trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
