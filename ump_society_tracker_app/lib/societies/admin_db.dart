import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AdminDB {
  static final AdminDB instance = AdminDB._init();
  static Database? _database;

  AdminDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('admins.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const adminTable = '''
    CREATE TABLE admins (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student_number TEXT NOT NULL,
      society_id TEXT NOT NULL
    );
    ''';

    await db.execute(adminTable);
  }

  Future<bool> isAdmin(String studentNumber, String societyId) async {
    final db = await instance.database;
    final result = await db.query(
      'admins',
      where: 'student_number = ? AND society_id = ?',
      whereArgs: [studentNumber, societyId],
    );

    return result.isNotEmpty;
  }
}
