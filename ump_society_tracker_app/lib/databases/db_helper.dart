import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ump_society_tracker_app/societies/society.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'tracker.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    Database db = await openDatabase(path, version: 1, onCreate: _createDb);

    // Insert default Primary Admin user
    await db.transaction((txn) async {
      await txn.insert(
        'users',
        {
          'userType': 'Primary Admin',
          'name': 'Primary',
          'surname': 'Admin',
          'email': 'society.admin@ump.ac.za',
          'password': 'admin',
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    });

    return db;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        userType TEXT,
        name TEXT,
        surname TEXT,
        studentNumber TEXT,
        username TEXT,
        email TEXT UNIQUE,
        password TEXT,
        societyName TEXT,
        position TEXT,
        reference TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE societies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        category TEXT,
        imagePath TEXT,
        color TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return users.isNotEmpty ? users.first : null;
  }

  Future<void> updateUserProfilePicture(String email, String imagePath) async {
    final db = await database;
    await db.update(
      'users',
      {'profileImageUrl': imagePath},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<bool> validateUser(String identifier, String password) async {
    Database db = await database;

    // Check if Primary Admin login
    bool isPrimaryAdmin = await _isPrimaryAdminUser(identifier);

    if (isPrimaryAdmin) {
      var res = await db.query("users", where: "email = ? OR username = ?", whereArgs: [identifier, identifier]);
      if (res.isNotEmpty) {
        if (res[0]['password'] == password) {
          return true;
        }
      }
    } else {
      // Handle regular Member/Admin login
      var res = await db.query("users", where: "studentNumber = ? AND password = ?", whereArgs: [identifier, password]);
      if (res.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  Future<bool> _isPrimaryAdminUser(String identifier) async {
    Database db = await database;

    var res = await db.query("users", where: "email = ? OR username = ?", whereArgs: [identifier, identifier]);
    if (res.isNotEmpty) {
      return res[0]['userType'] == 'Primary Admin';
    }

    return false;
  }

  Future<void> insertSociety(Society society) async {
    final db = await database;
    await db.insert(
      'societies',
      society.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Society>> getAllSocieties() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('societies');

    return List.generate(maps.length, (i) {
      return Society(
        name: maps[i]['name'],
        description: maps[i]['description'],
        category: maps[i]['category'],
      );
    });
  }

  Future<Map<String, dynamic>?> getCurrentUser(String email) async {
  Database db = await database;
  List<Map<String, dynamic>> users = await db.query('users', where: 'email = ?', whereArgs: [email]);
  return users.isNotEmpty ? users.first : null;
}
}
