import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final String TABLE_TODO = "todo";
  static final String COLUMN_TODO_ID = "id";
  static final String COLUMN_TODO_TEXT = "text";
  static final String COLUMN_TODO_ISDONE = "is_done";
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  Database? myDB;

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "todoDB.db");
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_TODO($COLUMN_TODO_ID text primary key, $COLUMN_TODO_TEXT text, $COLUMN_TODO_ISDONE text )",
        );
      },
      version: 1,
    );
  }

  Future<bool> addItem({
    required String mId,
    required String mText,
    required bool mIsDone,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_TODO, {
      COLUMN_TODO_ID: mId,
      COLUMN_TODO_TEXT: mText,
      COLUMN_TODO_ISDONE: mIsDone,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_TODO);
    return mData;
  }
}
