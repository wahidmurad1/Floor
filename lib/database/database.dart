import 'dart:async';
import 'package:floor/floor.dart';
import 'package:hive_test/dao/product_dao.dart';
import 'package:hive_test/entity/product.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Product])
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;
}
