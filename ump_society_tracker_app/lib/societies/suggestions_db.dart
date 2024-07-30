import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Data model for suggestions
class SuggestionsData {
  final int id;
  final String societyId;
  final String studentNumber;
  final String suggestion;
  final DateTime timestamp;

  SuggestionsData({
    required this.id,
    required this.societyId,
    required this.studentNumber,
    required this.suggestion,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'societyId': societyId,
      'studentNumber': studentNumber,
      'suggestion': suggestion,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SuggestionsData.fromMap(Map<String, dynamic> map) {
    return SuggestionsData(
      id: map['id'],
      societyId: map['societyId'],
      studentNumber: map['studentNumber'],
      suggestion: map['suggestion'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

/// Database helper class for suggestions
class SuggestionsDB {
  static Database? _database;
  static final SuggestionsDB instance = SuggestionsDB._privateConstructor();

  SuggestionsDB._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'suggestions_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE suggestions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        societyId TEXT NOT NULL,
        studentNumber TEXT,
        suggestion TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<void> createSuggestion(SuggestionsData suggestion) async {
    final Database db = await instance.database;
    await db.insert('suggestions', suggestion.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SuggestionsData>> getSuggestionsBySocietyId(String societyId) async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('suggestions',
        where: 'societyId = ?',
        whereArgs: [societyId],
        orderBy: 'timestamp DESC');

    return List.generate(maps.length, (i) {
      return SuggestionsData.fromMap(maps[i]);
    });
  }
}
