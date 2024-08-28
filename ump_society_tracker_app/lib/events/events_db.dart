import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Event {
  final String id;
  final String name;
  final String date;
  final String time;
  final String venue;
  final String duration;
  int seats; // Changed to non-final to allow modification
  final String? theme;
  final String description;
  final String societyId;
  final List<String> rsvps; // List of user IDs who have RSVP'd

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.venue,
    required this.duration,
    required this.seats,
    this.theme,
    required this.description,
    required this.societyId,
    this.rsvps = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'venue': venue,
      'duration': duration,
      'seats': seats,
      'theme': theme,
      'description': description,
      'society_id': societyId,
      'rsvps': rsvps.join(','), // Convert list to comma-separated string
    };
  }
}

class EventsDB {
  static Future<Database> _initializeDB() async {
    String path = join(await getDatabasesPath(), 'events.db');

    return openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE events("
          "id TEXT PRIMARY KEY, "
          "name TEXT, "
          "date TEXT, "
          "time TEXT, "
          "venue TEXT, "
          "duration TEXT, "
          "seats INTEGER, "
          "theme TEXT, "
          "description TEXT, "
          "society_id TEXT, "
          "rsvps TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> createEvent(Event event) async {
    final db = await _initializeDB();
    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Event>> retrieveEvents(String societyId) async {
    final Database db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'events',
      where: 'society_id = ?',
      whereArgs: [societyId],
    );
    return List.generate(queryResult.length, (i) {
      return Event(
        id: queryResult[i]['id'],
        name: queryResult[i]['name'],
        date: queryResult[i]['date'],
        time: queryResult[i]['time'],
        venue: queryResult[i]['venue'],
        duration: queryResult[i]['duration'],
        seats: queryResult[i]['seats'],
        theme: queryResult[i]['theme'],
        description: queryResult[i]['description'],
        societyId: queryResult[i]['society_id'],
        rsvps: (queryResult[i]['rsvps'] as String).split(','), // Convert comma-separated string back to list
      );
    });
  }

  static Future<void> rsvpEvent(String eventId, String userId) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [eventId],
    );

    if (queryResult.isNotEmpty) {
      final event = Event(
        id: queryResult.first['id'],
        name: queryResult.first['name'],
        date: queryResult.first['date'],
        time: queryResult.first['time'],
        venue: queryResult.first['venue'],
        duration: queryResult.first['duration'],
        seats: queryResult.first['seats'],
        theme: queryResult.first['theme'],
        description: queryResult.first['description'],
        societyId: queryResult.first['society_id'],
        rsvps: (queryResult.first['rsvps'] as String).split(','), // Convert comma-separated string back to list
      );

      if (!event.rsvps.contains(userId) && event.seats > 0) { // Check if there are seats available
        event.rsvps.add(userId);
        event.seats--; // Decrement the number of seats
        await db.update(
          'events',
          event.toMap(),
          where: 'id = ?',
          whereArgs: [eventId],
        );
      }
    }
  }

  static Future<void> cancelRsvpEvent(String eventId, String userId) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [eventId],
    );

    if (queryResult.isNotEmpty) {
      final event = Event(
        id: queryResult.first['id'],
        name: queryResult.first['name'],
        date: queryResult.first['date'],
        time: queryResult.first['time'],
        venue: queryResult.first['venue'],
        duration: queryResult.first['duration'],
        seats: queryResult.first['seats'],
        theme: queryResult.first['theme'],
        description: queryResult.first['description'],
        societyId: queryResult.first['society_id'],
        rsvps: (queryResult.first['rsvps'] as String).split(','), // Convert comma-separated string back to list
      );

      if (event.rsvps.contains(userId)) {
        event.rsvps.remove(userId);
        event.seats++; // Increment the number of seats
        await db.update(
          'events',
          event.toMap(),
          where: 'id = ?',
          whereArgs: [eventId],
        );
      }
    }
  }

  static Future<List<String>> getRsvps(String eventId) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [eventId],
    );

    if (queryResult.isNotEmpty) {
      return (queryResult.first['rsvps'] as String).split(',');
    } else {
      return [];
    }
  }


  static Future<List<Event>> retrieveUserRsvps(String userId) async {
  final db = await _initializeDB();
  final List<Map<String, dynamic>> queryResult = await db.query(
    'events',
    where: 'rsvps LIKE ?',
    whereArgs: ['%$userId%'],
  );

  return List.generate(queryResult.length, (i) {
    return Event(
      id: queryResult[i]['id'],
      name: queryResult[i]['name'],
      date: queryResult[i]['date'],
      time: queryResult[i]['time'],
      venue: queryResult[i]['venue'],
      duration: queryResult[i]['duration'],
      seats: queryResult[i]['seats'],
      theme: queryResult[i]['theme'],
      description: queryResult[i]['description'],
      societyId: queryResult[i]['society_id'],
      rsvps: (queryResult[i]['rsvps'] as String).split(','),
    );
  });
}

}
