import 'package:floor/floor.dart';
import 'package:hive_test/entity/cart.dart';

@dao
abstract class CartDAO {
  @Query('SELECT * FROM  Cart WHERE uid=:uid')
  Stream<List<Cart>> getAllItemInCartByUid(String uid);

  @Query('SELECT * FROM  Cart WHERE uid=:uid AND id=:id')
  Stream<List<Cart>> getItemInCartByUid(String uid, String id);

  @Query('SELECT FROM  Cart WHERE uid=:uid')
  Stream<List<Cart>> clear(String uid);

  @insert
  Future<void> insertCart(Cart product);
  @update
  Future<void> updatecart(Cart product);
  @delete
  Future<void> deleteCart(Cart product);
}
