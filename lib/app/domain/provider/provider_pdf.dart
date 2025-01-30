import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/model/pdf_model.dart';
import 'package:pdf_hub/app/domain/pdf_api.dart';
import '../../../utility/pdf_function.dart';
import '../../ui/widget/widget_pdf_file/show_alert_dialog_pdf.dart';

class ProviderPDF extends ChangeNotifier {
  ProviderPDF({required this.pdfRepository});
  final PdfApi pdfRepository;

  var pdfModelListHistory = <PdfModel?>[];

  bool changeMenuItemFavourites = false;

  Future<void> addListPdfFileFromDeviceStorage(BuildContext context) async {
    try {
      final listPdfModelsStorage =
          await pdfRepository.getPdfListDeviceStorage();

      if (listPdfModelsStorage == null) {
        return;
      }
      final pdfListModelDb = await pdfRepository.getPdfListModelFromDbHistory();

      final pdfModelClone = comparePdfModel(
          listFirst: listPdfModelsStorage, listSecond: pdfListModelDb);
      if (!context.mounted) return;
      if (pdfModelClone.isNotEmpty) {
        await showAlertDialogPdf(context, pdfModelClone);
      }
      await pdfRepository.insertDbListPdfModel(
          listPdfModels: listPdfModelsStorage);

      await updatePdfListModelHistory();
    } catch (e, s) {
      log('Error addListPdfFileFromDeviceStorage: $e', stackTrace: s);
    }
  }

  Future<void> deleteFilePdf(PdfModel pdfModel) async {
    try {
      await pdfRepository.deleteFilePdfAndModelDb(pdfModel: pdfModel);
      await updatePdfListModelHistory();
    } catch (e, s) {
      log('Error deleteFilePdf: $e', stackTrace: s);
    }
  }

  Future<void> deleteFilePdfAfterCompare(List<PdfModel?> listPdf) async {
    try {
      if (listPdf.isNotEmpty) {
        for (var element in listPdf) {
          await pdfRepository.deleteFilePdfAndModelDb(pdfModel: element!);
        }
      }
    } catch (e, s) {
      log('Error DeleteAfterCompare: $e', stackTrace: s);
    }
  }

  Future<void> updatePdfListModelHistory() async {
    try {
      pdfModelListHistory = await pdfRepository.getPdfListModelFromDbHistory();
    } catch (e, s) {
      log('Error updatePdfListModelHistory: $e', stackTrace: s);
    }

    notifyListeners();
  }

  Future<void> updatePdfModelDb(PdfModel newPdfModel) async {
    try {
      await pdfRepository.updatePdfModel(pdfModel: newPdfModel);
      await updatePdfListModelHistory();
    } catch (e, s) {
      log('Error updatePdfModelDb: $e', stackTrace: s);
    }
  }

  Future<int?> getPageNumber(PdfModel pdfModel) async {
    int? pageNumber;
    try {
      pageNumber = await pdfRepository.getNumberPages(pdfModel: pdfModel);
    } catch (e, s) {
      log('Error getPageNumber: $e', stackTrace: s);
    }
    return pageNumber;
  }

  Future<void> updatePageNumber(int pageNumber, PdfModel pdfModel) async {
    try {
      final newPdfModel = pdfModel.copyWith(pageNumber: pageNumber);
      await pdfRepository.updatePdfModel(pdfModel: newPdfModel);
    } catch (e, s) {
      log('Error updatePageNumber: $e', stackTrace: s);
    }
  }
}
