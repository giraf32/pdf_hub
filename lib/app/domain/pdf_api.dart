import 'package:pdf_hub/app/domain/model/pdf_model.dart';

abstract class PdfApi {

  Future<void> insertDbListPdfModel({required List<PdfModel> listPdfModels});
  Future<void> deleteFilePdfAndModelDb({required PdfModel pdfModel});
  Future<List<PdfModel?>> getPdfListModelFromDbHistory();
  Future<void> updatePdfModel({required PdfModel pdfModel});
  Future<List<PdfModel>?> getPdfListDeviceStorage();
  Future<void> deleteDbPdfModel({required PdfModel pdfModel});
  Future<int?> getNumberPages({required PdfModel pdfModel});
 


}

