import 'dart:convert';
import 'package:althaqafy/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/quran_models/fav_model.dart';
import 'model/book_mark_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  // Prevent multiple concurrent _initDatabase() calls which can lead to
  // SQLITE_BUSY (BEGIN EXCLUSIVE) when several callers try to open the
  // database at the same time. We keep the in-flight Future here and
  // await it for subsequent calls.
  static Future<Database>? _initDatabaseFuture;

  static const columnId = 'id';
  static const columnCategory = 'category';
  static const columnZekerList = 'ZekerList';

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If an initialization is already in progress, await it instead of
    // starting a second openDatabase(). This prevents concurrent opens
    // which can produce "database is locked (code 5 SQLITE_BUSY)" errors
    // on some Android emulator/device setups.
    if (_initDatabaseFuture != null) {
      _database = await _initDatabaseFuture!;
      return _database!;
    }

    _initDatabaseFuture = _initDatabase();
    try {
      _database = await _initDatabaseFuture!;
      return _database!;
    } finally {
      // Clear the future so that future calls still work if DB was closed
      _initDatabaseFuture = null;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    // await deleteDatabase(path);

    // Create a new database
    return await openDatabase(
      path,
      version: 4, // Ensure this matches your new schema version
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE favorites(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          surahIndex INTEGER,
          reciterName TEXT,
          reciterUrl TEXT,
          zeroPaddingSurahNumber INTEGER,
          url TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE bookmarks(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           surahName TEXT,
           pageNumber INTEGER
         )

       ''');
        await db.execute('''
       CREATE TABLE fontSize(
           fontSize DOUBLE
         )
       ''');
        await db.execute(
           'CREATE TABLE theme (id INTEGER PRIMARY KEY, themeMode TEXT)',
         );
        await db.execute('''
         CREATE TABLE favAzkarPage (
           $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
           $columnCategory TEXT NOT NULL,
           $columnZekerList TEXT NOT NULL
         )
       ''');
        return db.execute(
           'CREATE TABLE settings (id INTEGER PRIMARY KEY, notificationsEnabled INTEGER)',
         );
      },
    );
  }

  Future<void> insertFavorite(FavModel fav) async {
    final db = await database;
    await db.insert(
      'favorites',
      fav.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FavModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return FavModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteFavorite(int surahIndex, String reciterName) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'surahIndex = ? AND reciterName = ?',
      whereArgs: [surahIndex, reciterName],
    );
  }

  Future<bool> isFavoriteExists(int surahIndex, String reciterName) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'favorites',
      where: 'surahIndex = ? AND reciterName = ?',
      whereArgs: [surahIndex, reciterName],
    );
    return result.isNotEmpty;
  }

  // Insert Bookmark
  Future<void> insertBookmark(BookMarkModel bookmark) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch All Bookmarks
  Future<List<BookMarkModel>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) {
      return BookMarkModel.fromMap(maps[i]);
    });
  }

  // Delete Bookmark
  Future<void> deleteBookmark(int? id) async {
    final db = await database;

    // Check if the ID is null
    if (id == null) {
      throw ArgumentError("Cannot delete a bookmark without an ID.");
    }

    // Proceed with deletion
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }


  // Save font size to database
  Future<void> changeFontSize(double fontSize) async {
    final db = await database;

    // Check if a font size already exists
    final result = await db.query('fontSize');

    if (result.isNotEmpty) {
      // Update existing font size
      await db.update(
        'fontSize',
        {'fontSize': fontSize},
        where: '1', // Always update the single entry
      );
    } else {
      // Insert a new font size if it doesn't exist
      await db.insert('fontSize', {'fontSize': fontSize});
    }
  }

  // Retrieve font size from database
  Future<double> getFontSize() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query('fontSize');

    if (result.isNotEmpty) {
      return result.first['fontSize'] as double;
    } else {
      // Return default font size if no value exists
      return 35.0;
    }
  }

  Future<void> saveTheme(String themeMode) async {
    final db = await database;
    await db.insert('theme', {
      'id': 1,
      'themeMode': themeMode,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> fetchTheme() async {
    final db = await database;
    final result = await db.query('theme', where: 'id = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return result.first['themeMode'] as String;
    }
    return defaultTheme;
  }

  Future<void> insertFavAzkar(String category, List zekerList) async {
    final db = await database;
    await db.insert('favAzkarPage', {
      columnCategory: category,
      columnZekerList: jsonEncode(zekerList), // Convert list to JSON string
    });
  }

  Future<void> deleteFavAzkar(String category) async {
    final db = await database;
    await db.delete(
      'favAzkarPage',
      where: '$columnCategory = ?',
      whereArgs: [category],
    );
  }

  Future<bool> isFavZekrExit(String category) async {
    final db = await database;
    final result = await db.query(
      'favAzkarPage',
      where: '$columnCategory = ?',
      whereArgs: [category],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavsAzkar() async {
    final db = await database;
    final results = await db.query('favAzkarPage');

    return results.map((record) {
      return {
        'category':
            record[columnCategory] as String, // Ensure category is a String
        'zekerList': jsonDecode(
          record[columnZekerList] as String,
        ), // Cast to String
      };
    }).toList();
  }


  Future<void> setNotificationsEnabled(bool enabled) async {
    final db = await database;
    await db.insert('settings', {
      'id': 1,
      'notificationsEnabled': enabled ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> getNotificationsEnabled() async {
    final db = await database;
    final result = await db.query('settings', where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty && result.first['notificationsEnabled'] == 1;
  }
}
