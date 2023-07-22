import 'package:floor/floor.dart';
import 'package:hive_test/dao/cart_dao.dart';
import 'package:hive_test/entity/cart.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'database.g.dart';

// part 'database.g.dart';
// part 'database.g.dart';
// part 'database.g.dart';

@Database(version: 1, entities: [Cart])
abstract class AppDatabase extends FloorDatabase {
  CartDAO get cartDAO;
}
