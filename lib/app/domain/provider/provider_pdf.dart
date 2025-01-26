import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/model/pdf_model.dart';
import 'package:pdf_hub/app/domain/pdf_api.dart';
import '../../../utility/pdf_function.dart';
import '../../ui/widget/widget_pdf_file/show_alert_dialog_pdf.dart';

enum NotifierState { initial, loading, loaded }

//enum NotifierStateListAddPdfFolder { initial, loading, loaded }

class ProviderPDF extends ChangeNotifier {
  ProviderPDF({required this.pdfRepository});
  final PdfApi pdfRepository;

  NotifierState _notifierState = NotifierState.initial;

  NotifierState get notifierState => _notifierState;

  void _setNotifierState(NotifierState state) {
    _notifierState = state;
    notifyListeners();
  }

  // final pdfRepository =
  //     PdfRepository(dbServicesPdf: DbServicesPdf(InitDb.create()));
  var pdfModelListHistory = <PdfModel?>[];

  bool changeMenuItemFavourites = false;

  Future<void> addListPdfFileFromDeviceStorage(BuildContext context) async {
    try {
      // _setNotifierState(NotifierState.loading);
      final listPdfModelsStorage =
          await pdfRepository.getPdfListDeviceStorage();

      if (listPdfModelsStorage == null) {
        _setNotifierState(NotifierState.loaded);
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
      log('Error addOpenPdf: $e');
      log('Error addOpenPdf: $s');
    }
  }

  Future<void> deleteFilePdf(PdfModel pdfModel) async {
    try {
      await pdfRepository.deleteFilePdfAndModelDb(pdfModel: pdfModel);
      await updatePdfListModelHistory();
    } catch (e, s) {
      print('Error delete: $e');
      print('Error delete: $s');
    }
  }

  Future<void> deleteFilePdfAfterCompare(List<PdfModel?> listPdf) async {
    try {
      if (listPdf.isNotEmpty) {
        for (var element in listPdf) {
          await pdfRepository.deleteFilePdfAndModelDb(pdfModel: element!);
        }
      }
      // await updatePdfListModelHistory();
      // await updatePDFListModelFavourites();
    } catch (e, s) {
      print('Error delete after compare: $e');
      print('Error delete after compare: $s');
    }
  }

  Future<void> updatePdfListModelHistory() async {
    try {
      //  _setNotifierState(NotifierState.loading);

      pdfModelListHistory = await pdfRepository.getPdfListModelFromDbHistory();

      // print('listLocalPdf 0 $localListPdf');
    } catch (e, s) {
      print('Error updatePdfList: $e');
      print('Error updatePdfList: $s');
    }
    // _setNotifierState(NotifierState.loaded);
    notifyListeners();
  }

  Future<void> updatePdfModelDb(PdfModel newPdfModel) async {
    try {
      await pdfRepository.updatePdfModel(pdfModel: newPdfModel);
      await updatePdfListModelHistory();
    } catch (e, s) {
      print('Error updatePdfNameFile: $e');
      print('Error updatePdfNameFile: $s');
    }
  }

  Future<int?> getPageNumber(PdfModel pdfModel) async {
    int? pageNumber;
    try {
      pageNumber = await pdfRepository.getNumberPages(pdfModel: pdfModel);
    } catch (e, s) {
      print('Error getPageNumber: $e');
      print('Error getPageNumber: $s');
    }
    return pageNumber;
  }

  Future<void> updatePageNumber(int pageNumber, PdfModel pdfModel) async {
    try {
      final newPdfModel = pdfModel.copyWith(pageNumber: pageNumber);
      await pdfRepository.updatePdfModel(pdfModel: newPdfModel);
    } catch (e, s) {
      print('Error updatePageNumber: $e');
      print('Error updatePageNumber: $s');
    }
  }
}
