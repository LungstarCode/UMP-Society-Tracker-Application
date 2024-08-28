import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Contact {
  final String contactPerson;
  final String email;
  final String cellNumber;
  final String adminId; // Foreign key to link with Society's adminId
  final String? whatsappGroupLink; // Optional field for WhatsApp group chat link

  Contact({
    required this.contactPerson,
    required this.email,
    required this.cellNumber,
    required this.adminId,
    this.whatsappGroupLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'contact_person': contactPerson,
      'email': email,
      'cell_number': cellNumber,
      'admin_id': adminId,
      'whatsapp_group_link': whatsappGroupLink,
    };
  }
}

class ContactsDB {
  static Future<Database> _initializeDB() async {
    String path = join(await getDatabasesPath(), 'contacts.db');

    return openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE contacts("
          "contact_person TEXT, "
          "email TEXT, "
          "cell_number TEXT, "
          "admin_id TEXT, " // Foreign key to link with Society's adminId
          "whatsapp_group_link TEXT, "
          "FOREIGN KEY(admin_id) REFERENCES societies(admin_id) "
          "ON DELETE CASCADE ON UPDATE NO ACTION)",
        );
      },
      version: 1,
    );
  }

  static Future<void> createContact(Contact contact) async {
    final db = await _initializeDB();
    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Contact>> retrieveContactsForAdmin(String adminId) async {
    final Database db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'contacts',
      where: 'admin_id = ?',
      whereArgs: [adminId],
    );
    return List.generate(queryResult.length, (i) {
      return Contact(
        contactPerson: queryResult[i]['contact_person'],
        email: queryResult[i]['email'],
        cellNumber: queryResult[i]['cell_number'],
        adminId: queryResult[i]['admin_id'],
        whatsappGroupLink: queryResult[i]['whatsapp_group_link'],
      );
    });
  }

  static Future<void> updateContact(String adminId, String contactPerson, String email, String cellNumber, {String? whatsappGroupLink}) async {
    final db = await _initializeDB();
    await db.update(
      'contacts',
      {
        'contact_person': contactPerson,
        'email': email,
        'cell_number': cellNumber,
        'whatsapp_group_link': whatsappGroupLink,
      },
      where: 'admin_id = ?',
      whereArgs: [adminId],
    );
  }

  static Future<void> deleteContact(String adminId) async {
    final db = await _initializeDB();
    await db.delete(
      'contacts',
      where: 'admin_id = ?',
      whereArgs: [adminId],
    );
  }
}
