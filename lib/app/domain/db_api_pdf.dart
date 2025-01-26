import 'package:pdf_hub/app/domain/model/pdf_model.dart';

abstract class DbApiPdf{

  Future<int> insertPdfDb({ required PdfModel pdfModel});
  Future<void> updatePdfDb({ required PdfModel pdfModel});
  Future<List<PdfModel>> getPdfListDb();
  Future<void> deletePdfDb({required int? id});

}