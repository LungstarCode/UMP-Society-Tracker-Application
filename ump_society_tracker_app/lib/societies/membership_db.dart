import 'package:sqflite/sqflite.dart';

// Define the Member model
class Member {
  final String studentId;
  final String name;
  final String surname;
  final String societyName;

  Member({
    required this.studentId,
    required this.name,
    required this.surname,
    required this.societyName,
  });

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'name': name,
      'surname': surname,
      'society_name': societyName,
    };
  }
}

// Define the MembershipDB class
class MembershipDB {
  static Future<Database> _initializeDB() async {
    // Using an in-memory database for testing
    return openDatabase(
      ':memory:',
      onCreate: (database, version) async {
        // Create tables
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

        // Create the members table
        await database.execute(
          'CREATE TABLE members('
          'student_id TEXT, '
          'name TEXT, '
          'surname TEXT, '
          'society_name TEXT, '
          'PRIMARY KEY(student_id, society_name), '
          'FOREIGN KEY(society_name) REFERENCES societies(name))',
        );
      },
      version: 1,
    );
  }

  // Method to add a member to a society
  static Future<void> addMember(Member member) async {
    final db = await _initializeDB();
    await db.insert(
      'members',
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to retrieve all members of a specific society
  static Future<List<Member>> retrieveMembersOfSociety(String societyName) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'members',
      where: 'society_name = ?',
      whereArgs: [societyName],
    );
    return List.generate(queryResult.length, (i) {
      return Member(
        studentId: queryResult[i]['student_id'] ?? '',
        name: queryResult[i]['name'] ?? '',
        surname: queryResult[i]['surname'] ?? '',
        societyName: queryResult[i]['society_name'] ?? '',
      );
    });
  }

  // Method to check if a student is already a member of a society
  static Future<bool> checkMembership(String studentId, String societyName) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'members',
      where: 'student_id = ? AND society_name = ?',
      whereArgs: [studentId, societyName],
    );
    return result.isNotEmpty;
  }

  // Method to retrieve all societies a member belongs to
  static Future<List<String>> retrieveSocietiesForStudent(String studentId) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'members',
      where: 'student_id = ?',
      whereArgs: [studentId],
    );
    return List.generate(queryResult.length, (i) {
      return queryResult[i]['society_name'] ?? '';
    });
  }

  static Future<List<Member>> retrieveUserSocieties(String studentId) async {
  final db = await _initializeDB();
  final List<Map<String, dynamic>> queryResult = await db.query(
    'members',
    where: 'student_id = ?',
    whereArgs: [studentId],
  );

  return List.generate(queryResult.length, (i) {
    return Member(
      studentId: queryResult[i]['student_id'] ?? '',
      name: queryResult[i]['name'] ?? '',
      surname: queryResult[i]['surname'] ?? '',
      societyName: queryResult[i]['society_name'] ?? '',
    );
  });
}
}
