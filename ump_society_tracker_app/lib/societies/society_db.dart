import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Society {
  final String name;
  final String description;
  final String category;
  final bool pinned;
  final String adminNames;
  final String adminId;


  Society( {
    required this.name,
    required this.description,
    required this.category,
    this.pinned = false,
    required this.adminNames,
    required this.adminId,
  });

   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'pinned': pinned ? 1 : 0,
      'admin_names': adminNames,
      'admin_id': adminId,
    };
  }
}

class SocietyRequest {
  final String name;
  final String description;
  final String category;
  final String status; // 'pending', 'approved', 'rejected'
  final String adminNames;
  final String adminId;

  SocietyRequest({
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.adminNames,
    required this.adminId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'status': status,
      'admin_names': adminNames,
      'admin_id': adminId,
    };
  }
}

class PrimaryAdminUser {
  final String email;
  final String password;

  PrimaryAdminUser({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class SocietyDB {
  static Future<Database> _initializeDB() async {
    String path = join(await getDatabasesPath(), 'society.db');

    return openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE societies("
          "name TEXT PRIMARY KEY, "
          "description TEXT, "
          "category TEXT, "
          "pinned INTEGER, "
          "admin_names TEXT, "
          "admin_id TEXT)",
        );
        await database.execute(
          "CREATE TABLE society_requests("
          "name TEXT PRIMARY KEY, "
          "description TEXT, "
          "category TEXT, "
          "status TEXT, "
          "admin_names TEXT, "
          "admin_id TEXT)",
        );
        await database.execute(
          'CREATE TABLE primary_admin(email TEXT PRIMARY KEY, password TEXT)',
        );

        // Insert default primary admin user
        await database.insert(
          'primary_admin',
          PrimaryAdminUser(email: 'society.admin@ump.ac.za', password: 'admin').toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
      version: 1,
    );
  }

   static Future<void> createSocietyRequest(
      String name,
      String description,
      String category,
      String adminNames,
      String adminId) async {
    final db = await _initializeDB();
    final societyRequest = SocietyRequest(
      name: name,
      description: description,
      category: category,
      status: 'pending',
      adminNames: adminNames,
      adminId: adminId,
    );
    await db.insert('society_requests', societyRequest.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> approveSociety(SocietyRequest request) async {
    final Database db = await _initializeDB();
    Society society = Society(name: request.name, description: request.description, category: request.category, adminNames: request.adminNames, adminId: request.adminId, );
    await db.insert(
      'societies',
      society.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.delete(
      'society_requests',
      where: 'name = ?',
      whereArgs: [request.name],
    );
  }

  static Future<void> rejectSociety(SocietyRequest request) async {
    final Database db = await _initializeDB();
    await db.delete(
      'society_requests',
      where: 'name = ?',
      whereArgs: [request.name],
    );
  }

  static Future<List<Society>> retrieveSocieties() async {
    final Database db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'societies',
      orderBy: 'pinned DESC, name ASC', // Pinned societies at the top
    );
    return List.generate(queryResult.length, (i) {
    return Society(
      name: queryResult[i]['name'] ?? '',  // Default to empty string if null
      description: queryResult[i]['description'] ?? '',  // Default to empty string if null
      category: queryResult[i]['category'] ?? '',  // Default to empty string if null
      pinned: queryResult[i]['pinned'] == 1,
      adminNames: queryResult[i]['admin_names'] ?? '',  // Default to empty string if null
      adminId: queryResult[i]['admin_id'] ?? '',  // Default to empty string if null
    );
  });
}
  static Future<void> pinSociety(String name) async {
    final Database db = await _initializeDB();
    await db.update(
      'societies',
      {'pinned': 1},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  static Future<void> unpinSociety(String name) async {
    final Database db = await _initializeDB();
    await db.update(
      'societies',
      {'pinned': 0},
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  static Future<int> getPinnedSocietyCount() async {
    final Database db = await _initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'societies',
      where: 'pinned = ?',
      whereArgs: [1],
    );
    return result.length;
  }

   static Future<List<SocietyRequest>> retrieveSocietyRequests() async {
    final Database db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('society_requests');
    return List.generate(queryResult.length, (i) {
      return SocietyRequest(
        name: queryResult[i]['name'],
        description: queryResult[i]['description'],
        category: queryResult[i]['category'],
        status: queryResult[i]['status'],
        adminNames: queryResult[i]['admin_names'],
        adminId: queryResult[i]['admin_id'],
      );
    });
  }


  static Future<bool> validatePrimaryAdmin(String email, String password) async {
    final Database db = await _initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'primary_admin',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  static Future<bool> checkDuplicateSociety(String name) async {
    final Database db = await _initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'societies',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  static Future<void> updateSociety(
    String id, // Assuming 'id' is the primary key or identifier of the society
    String name,
    String description,
    String category,
  ) async {
    final db = await _initializeDB();
    await db.update(
      'societies',
      {
        'name': name,
        'description': description,
        'category': category,
      },
      where: 'id = ?', 
      whereArgs: [id],
    );
}

static Future<Society?> retrieveSocietyByName(String name) async {
  final Database db = await _initializeDB();
  final List<Map<String, dynamic>> result = await db.query(
    'societies',
    where: 'name = ?',
    whereArgs: [name],
  );

  if (result.isNotEmpty) {
    return Society(
      name: result[0]['name'],
      description: result[0]['description'],
      category: result[0]['category'],
      pinned: result[0]['pinned'] == 1,
      adminNames: result[0]['admin_names'],
      adminId: result[0]['admin_id'],
    );
  }
  return null;
}
}