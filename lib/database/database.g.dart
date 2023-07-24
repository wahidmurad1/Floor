// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductDao? _productDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Product` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `price` REAL NOT NULL, `description` TEXT NOT NULL, `category` TEXT NOT NULL, `image` TEXT NOT NULL, `rate` REAL NOT NULL, `count` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'Product',
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image,
                  'rate': item.rate,
                  'count': item.count
                }),
        _productUpdateAdapter = UpdateAdapter(
            database,
            'Product',
            ['id'],
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image,
                  'rate': item.rate,
                  'count': item.count
                }),
        _productDeletionAdapter = DeletionAdapter(
            database,
            'Product',
            ['id'],
            (Product item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image,
                  'rate': item.rate,
                  'count': item.count
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Product> _productInsertionAdapter;

  final UpdateAdapter<Product> _productUpdateAdapter;

  final DeletionAdapter<Product> _productDeletionAdapter;

  @override
  Future<List<Product>> getAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM Product',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int,
            title: row['title'] as String,
            price: row['price'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            image: row['image'] as String,
            rate: row['rate'] as double,
            count: row['count'] as int));
  }

  @override
  Future<Product?> getProductById(int id) async {
    return _queryAdapter.query('SELECT * FROM Product WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Product(
            id: row['id'] as int,
            title: row['title'] as String,
            price: row['price'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            image: row['image'] as String,
            rate: row['rate'] as double,
            count: row['count'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllProducts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Product');
  }

  @override
  Future<void> deleteProductById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Product WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertProduct(List<Product> product) async {
    await _productInsertionAdapter.insertList(
        product, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertNewProduct(Product product) async {
    await _productInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _productUpdateAdapter.update(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProduct(Product product) async {
    await _productDeletionAdapter.delete(product);
  }
}
