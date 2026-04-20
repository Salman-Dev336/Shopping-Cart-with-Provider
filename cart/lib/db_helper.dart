import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:cart/cart_model.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    _db ??= await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cart (id INTEGER PRIMARY KEY, productId TEXT UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)',
    );
  }

  /// ✅ FIXED: Handle duplicate insert
  Future<void> insert(Cart cart) async {
    final dbClient = await db;

    await dbClient.insert(
      'cart',
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // ✅ IMPORTANT
    );
  }

  Future<List<Cart>> getCartList() async {
    final dbClient = await db;
    final result = await dbClient.query('cart');

    return result.map((e) => Cart.fromMap(e)).toList();
  }
}