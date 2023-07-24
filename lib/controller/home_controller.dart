import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_test/database/database.dart';
import 'dart:convert';
import 'package:hive_test/entity/product.dart';
import 'package:hive_test/model/product_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final _productList = <ProductModel>[].obs;
  List<ProductModel> get productList => _productList;
  set productList(List<ProductModel> value) => productList.assignAll(value);
  List<ProductModel> fetchedProducts = [];
  var database;

  customOnInit() async {
    database =
        await $FloorAppDatabase.databaseBuilder('database.g.dart').build();
    await fetchAndStoreProducts(database);
  }

  @override
  void onInit() {
    super.onInit();
    customOnInit();
  }

  fetchAndStoreProducts(AppDatabase database) async {
    try {
      //await database.productDao.deleteAllProducts();
      productList = await fetchProductsFromDatabase(database);
      // for (int i = 1; i <= 8; i++) {
      //   await database.productDao.deleteProductById(i);
      // }
      // productList = await fetchProductsFromDatabase(database);
      log('Local : ' + productList.length.toString());

      fetchedProducts = await fetchProductsFromApi();
      log('From Api : ' + fetchedProducts.length.toString());
      // productList = fetchedProducts;

      await storeProductsInDatabase(fetchedProducts, database);
    } catch (e) {
      print('Error fetching products from API: $e');
      // Fetch data from the local database if API call fails.

      productList = await fetchProductsFromDatabase(database);

      // await database.productDao.deleteProductById(productList[].id);
      // productList = await fetchProductsFromDatabase(database);
    }
  }

  Future<List<ProductModel>> fetchProductsFromApi() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      return jsonData.map((item) {
        return ProductModel(
          id: item['id'],
          title: item['title'],
          price: item['price'].toDouble(),
          description: item['description'],
          category: mapStringToCategory(item['category']),
          image: item['image'],
          rating: Rating(
            rate: item['rating']['rate'].toDouble(),
            count: item['rating']['count'],
          ),
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<ProductModel>> fetchProductsFromDatabase(
      AppDatabase database) async {
    final List<Product> productEntities =
        await database.productDao.getAllProducts();
    return productEntities.map((entity) {
      return ProductModel(
        id: entity.id,
        title: entity.title,
        price: entity.price,
        description: entity.description,
        category: mapStringToCategory(entity.category),
        image: entity.image,
        rating: Rating(
          rate: entity.rate,
          count: entity.count,
        ),
      );
    }).toList();
  }

  storeProductsInDatabase(
      List<ProductModel> products, AppDatabase database) async {
    final productEntities = products
        .map((product) => Product(
              id: product.id,
              title: product.title,
              price: product.price,
              description: product.description,
              category: _mapCategoryToString(product.category),
              image: product.image,
              rate: product.rating.rate,
              count: product.rating.count,
            ))
        .toList();

    final localProductEntities = productList
        .map((product) => Product(
              id: product.id,
              title: product.title,
              price: product.price,
              description: product.description,
              category: _mapCategoryToString(product.category),
              image: product.image,
              rate: product.rating.rate,
              count: product.rating.count,
            ))
        .toList();

    //final List<Product> existingProducts =
    //await database.productDao.getAllProducts();
    // print(productEntities);
    //!This is also valid
    // List<Product> existingProducts = [];
    // for (var existingProduct
    //     in productEntities.sublist(0, productEntities.length)) {
    //   existingProducts.add(existingProduct);
    // }
    // // log(productEntities.length);
    // await database.productDao.insertProduct(existingProducts);
    List<Product> existingProducts = [];
    for (var i = 0; i < localProductEntities.length; i++) {
      existingProducts.add(localProductEntities[i]);
    }
    List<Product> serverProducts = [];
    for (var i = 0; i < productEntities.length - 4; i++) {
      serverProducts.add(productEntities[i]);
    }
    // await database.productDao.insertProduct(existingProducts);
    log('Existing Product : ' + existingProducts.length.toString());
    log('List of  Product : ' + productEntities.length.toString());
    log('reduce : ' + serverProducts.length.toString());
    // await database.productDao.insertProduct(existingProducts);
    Set<int> serverIds = serverProducts.map((product) => product.id).toSet();
    Set<int> fetchedIds = fetchedProducts.map((product) => product.id).toSet();
    // Set<int> productEntitiesIds = products.map((product) => product.id).toSet();
    // if (existingProducts.length <= productEntities.length) {
    //   for (var product in existingProducts) {
    //     if (!fetchedIds.contains(product.id)) {
    //       // log('Inside the if');
    //       log('fetch Ids' + fetchedIds.toString());
    //       log('Delete');
    //       await database.productDao.deleteProductById(product.id);
    //     }
    //   }
    // }
    // var difference = serverProducts.length - existingProducts.length;
    // if (existingProducts.length >= serverProducts.length) {
    //   for (int i = 1; i <= difference; i++) {
    //     //log('inside for');
    //     //log('Inside if');
    //     if (await database.productDao.getProductById(serverProducts[i].id) ==
    //         null) {
    //       log(difference.toString());
    //       log('Delete');
    //       await database.productDao.deleteProductById(productEntities[i].id);
    //     }
    //   }
    // }
    var difference = existingProducts.length - serverProducts.length;
    if (difference > 0) {
      for (int i = difference - 1; i >= 0; i--) {
        //log('Inside if');
        if (serverIds != fetchedIds) {
          //log(serverIds.toString());
          //log(fetchedIds.toString());

          //log(difference.toString());
          log('Delete');
          await database.productDao.deleteProductById(existingProducts[i].id);
        }
      }
    } else {
      for (int i = 0; i < productEntities.length; i++) {
        // for (int j = 0; j < existingProducts.length; j++) {
        if (await database.productDao.getProductById(productEntities[i].id) ==
            null) {
          log('Insert');
          await database.productDao.insertNewProduct(productEntities[i]);
        }
      }
    }

    // for (var product in productEntities) {
    //   if (!existingIds.(product.id)) {
    //     log('fetch Ids' + fetchedIds.toString());
    //     log('existing Ids' + existingIds.toString());
    //     log('Insert');
    //   }
    // }

    //!for insert and delete data which are not exists in local database
    // if (existingProducts.length > productEntities.length) {
    //   for (var i = productEntities.length; i < existingProducts.length; i++) {
    //     // log('The value : ' + i.toString());
    //     await database.productDao.deleteProduct(existingProducts[i]);
    //   }
    // } else if (productEntities.length > existingProducts.length) {
    //   List<Product> newData = [];
    //   log('outside of loop');
    //   log('Existing Product2 : ' + existingProducts.length.toString());
    //   log('List of  Product2 : ' + productEntities.length.toString());
    //   for (int j = existingProducts.length; j < productEntities.length; j++) {
    //     newData.add(existingProducts[j]);
    //   }
    //   log('new Data value : ' + newData.length.toString());
    //   await database.productDao.insertProduct(newData);
    // }
    // await database.productDao.insertProduct(existingProducts);
    // productList = await fetchProductsFromDatabase(database);
    // return;
    // await database.productDao.insertProduct(existingProducts);
    //productList = await fetchProductsFromDatabase(database);
    // if()

    // await database.productDao.insertProduct(productEntities);

    // await database.productDao.deleteAllProducts();
    // await database.productDao.getAllProducts();
    // await database.productDao.deleteProductById(product.id);
    // for (var product in products) {

    //   await database.productDao.deleteProductById(product.id);
    // }
  }

  Category mapStringToCategory(String categoryString) {
    switch (categoryString) {
      case 'men\'s clothing':
        return Category.MEN_S_CLOTHING;
      case 'jewelery':
        return Category.JEWELERY;
      case 'electronics':
        return Category.ELECTRONICS;
      case 'women\'s clothing':
        return Category.WOMEN_S_CLOTHING;
      default:
        return Category.MEN_S_CLOTHING;
    }
  }

  String _mapCategoryToString(Category category) {
    switch (category) {
      case Category.MEN_S_CLOTHING:
        return 'men\'s clothing';
      case Category.JEWELERY:
        return 'jewelery';
      case Category.ELECTRONICS:
        return 'electronics';
      case Category.WOMEN_S_CLOTHING:
        return 'women\'s clothing';
      default:
        return 'men\'s clothing';
    }
  }
}
