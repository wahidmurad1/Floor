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
      final List<ProductModel> fetchedProducts = await fetchProductsFromApi();
      productList = fetchedProducts;

      await storeProductsInDatabase(productList, database);
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
    final List<Product> existingProducts =
        await database.productDao.getAllProducts();
    await database.productDao.insertProduct(productEntities);
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
