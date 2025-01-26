
import 'package:pdf_hub/app/domain/db_api_folder.dart';
import 'package:pdf_hub/app/domain/model/folder_model.dart';
import 'package:sqflite/sqflite.dart';

class DbServicesFolder implements DbApiFolder {
  //final InitDb initDb;
  final Database db;

  DbServicesFolder({required this.db});

  //DbServicesFolder(this.initDb);

  @override
  Future<void> deleteFolderDb({required int? id}) async {
    //final db = await initDb.database;
    await db.delete('folder', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<FolderModel?>> getListFolderDb() async {
   // final db = await initDb.database;
    final List<Map<String, dynamic>> folderMaps = await db.query('folder');

    return List.generate(folderMaps.length, (index) {
      return FolderModel(
        id: folderMaps[index]['id'],
        nameFolder: folderMaps[index]['nameFolder'],
      );
    });
  }

  @override
  Future<void> insertFolderDb({required FolderModel folder}) async {
    //final db = await initDb.database;
    await db.insert('folder', folder.toMapPDF(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateFolderDb({required FolderModel folder}) async {
    //final db = await initDb.database;
  await db.update('folder', folder.toMapPDF(),
        where: 'id = ?', whereArgs: [folder.id]);
  }
}
