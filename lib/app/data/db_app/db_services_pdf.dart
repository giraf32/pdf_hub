import 'dart:async';
import 'package:pdf_hub/app/domain/db_api_pdf.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/model/pdf_model.dart';

class DbServicesPdf implements DbApiPdf {
  // final InitDb initDb;
  final Database db;

  DbServicesPdf({required this.db});

  @override
  Future<int> insertPdfDb({required PdfModel pdfModel}) async {
   // final db = await initDb.database;
    var id = await db.insert('pdf', pdfModel.toMapPDF(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  @override
  Future<List<PdfModel>> getPdfListDb() async {
   // final db = await initDb.database;
    final List<Map<String, dynamic>> pdfMaps = await db.query('pdf');

    return List.generate(pdfMaps.length, (index) {
      return PdfModel(
        id: pdfMaps[index]['id'],
        path: pdfMaps[index]['path'],
        name: pdfMaps[index]['name'],
        pageNumber: pdfMaps[index]['pageNumber'],
        dateTime: pdfMaps[index]['dateTime'],
        size: pdfMaps[index]['size'],
        folder: pdfMaps[index]['folder'],
      );
    });
  }

  @override
  Future<void> deletePdfDb({required int? id}) async {
   // final db = await initDb.database;
    await db.delete('pdf', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updatePdfDb({required PdfModel pdfModel}) async {
   // final db = await initDb.database;
    db.update('pdf', pdfModel.toMapPDF(),
        where: 'id = ?', whereArgs: [pdfModel.id]);
  }
}
