import 'inv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_INV = "inv";
  static const String COLUMN_ID = "id";
  static const String COLUMN_SCHNAME = "schname";
  static const String COLUMN_TYPE = "type";
  static const String COLUMN_AMOUNT = "amount";
  static const String COLUMN_YEAR = "year";
  static const String COLUMN_DATE = "date";

  static const String COLUMN_MATURED = "isMatured";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'hi.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating inv table");

        await database.execute(
          "CREATE TABLE $TABLE_INV ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_SCHNAME TEXT,"
              "$COLUMN_TYPE TEXT,"
              "$COLUMN_AMOUNT TEXT,"
              "$COLUMN_YEAR TEXT,"
              "$COLUMN_DATE TEXT,"
              "$COLUMN_MATURED INTEGER"
              ")",
        );
      },
    );
  }

  Future<List<Inv>> getInvs() async {
    final db = await database;

    var invs = await db
        .query(TABLE_INV, columns: [COLUMN_ID, COLUMN_SCHNAME, COLUMN_TYPE, COLUMN_AMOUNT, COLUMN_DATE, COLUMN_MATURED]);

    List<Inv> invList = List<Inv>();

    invs.forEach((currentInv) {
      Inv inv = Inv.fromMap(currentInv);

      invList.add(inv);
    });

    return invList;
  }

  Future<Inv> insert(Inv inv) async {
    final db = await database;
    inv.id = await db.insert(TABLE_INV, inv.toMap());
    return inv;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_INV,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Inv inv) async {
    final db = await database;

    return await db.update(
      TABLE_INV,
      inv.toMap(),
      where: "id = ?",
      whereArgs: [inv.id],
    );
  }
}