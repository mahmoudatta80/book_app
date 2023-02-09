import 'package:book_app/book_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  static Database? myDatabase;

  Future<Database?> createDatabase() async{
    if(myDatabase != null) {
      return myDatabase;
    }else {
      String path = join(await getDatabasesPath() , 'roadmap2.db');
      myDatabase = await openDatabase(
          path,
          version: 1,
          onCreate: (db , v) {
            db.execute(
              'CREATE TABLE books(id INTEGER PRIMARY KEY, bookTitle TEXT, bookAuthor Text, bookCoverUrl Text)',
            );
            print('create database');
          }
      );
      return myDatabase;
    }
  }

  Future<int> insertToDatabase(BookModel bookModel) async{
    Database? myDatabase = await createDatabase();
    return myDatabase!.insert('books', bookModel.toMap());
  }

  Future<List> readAllFromDatabase() async{
    Database? myDatabase = await createDatabase();
    return myDatabase!.query('books');
  }

  Future<int> deleteFromDatabase(int id) async{
    Database? myDatabase = await createDatabase();
    return myDatabase!.delete('books' , where: 'id = ?' , whereArgs: [id]);
  }
}