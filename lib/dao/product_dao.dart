import 'package:floor/floor.dart';
import 'package:hive_test/entity/product.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM Product')
  Future<List<Product>> getAllProducts();

  @Query('SELECT * FROM Product WHERE id = :id')
  Future<Product?> getProductById(int id);

  @insert
  Future<void> insertProduct(List<Product> product);

  @update
  Future<void> updateProduct(Product product);

  @delete
  Future<void> deleteProduct(Product product);

  @Query('DELETE FROM Product')
  Future<void> deleteAllProducts();

  @Query('DELETE FROM Product WHERE id = :id')
  Future<void> deleteProductById(int id);
}
