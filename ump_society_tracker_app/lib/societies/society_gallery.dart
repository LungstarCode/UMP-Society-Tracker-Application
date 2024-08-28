import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SocietyGallery {
  final int id;
  final String societyName;
  final String imageUrl;
  final String? description;
  final String uploadDate;

  SocietyGallery({
    required this.id,
    required this.societyName,
    required this.imageUrl,
    this.description,
    required this.uploadDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'society_name': societyName,
      'image_url': imageUrl,
      'description': description,
      'upload_date': uploadDate,
    };
  }
}

class SocietyGalleryDB {
  static Future<Database> _initializeDB() async {
    String path = join(await getDatabasesPath(), 'society_gallery.db');

    return openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE society_gallery("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "society_name TEXT, "
          "image_url TEXT, "
          "description TEXT, "
          "upload_date TEXT, "
          "FOREIGN KEY (society_name) REFERENCES societies(name))",
        );
      },
      version: 1,
    );
  }

  static Future<void> addGalleryItem(SocietyGallery galleryItem) async {
    final db = await _initializeDB();
    await db.insert(
      'society_gallery',
      galleryItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<SocietyGallery>> retrieveGalleryItems(String societyName) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'society_gallery',
      where: 'society_name = ?',
      whereArgs: [societyName],
    );

    return List.generate(queryResult.length, (i) {
      return SocietyGallery(
        id: queryResult[i]['id'],
        societyName: queryResult[i]['society_name'],
        imageUrl: queryResult[i]['image_url'],
        description: queryResult[i]['description'],
        uploadDate: queryResult[i]['upload_date'],
      );
    });
  }

  static Future<void> deleteGalleryItem(String imageUrl) async {
    final db = await _initializeDB();
    await db.delete(
      'society_gallery',
      where: 'image_url = ?',
      whereArgs: [imageUrl],
    );
  }

  static Future<void> updateGalleryItem(SocietyGallery galleryItem) async {
    final db = await _initializeDB();
    await db.update(
      'society_gallery',
      galleryItem.toMap(),
      where: 'id = ?',
      whereArgs: [galleryItem.id],
    );
  }

  static Future<List<SocietyGallery>> getGalleryImages(String societyName) async {
    final db = await _initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'society_gallery',
      where: 'society_name = ?',
      whereArgs: [societyName],
    );

    return List.generate(queryResult.length, (i) {
      return SocietyGallery(
        id: queryResult[i]['id'],
        societyName: queryResult[i]['society_name'],
        imageUrl: queryResult[i]['image_url'],
        description: queryResult[i]['description'],
        uploadDate: queryResult[i]['upload_date'],
      );
    });
  }
}
