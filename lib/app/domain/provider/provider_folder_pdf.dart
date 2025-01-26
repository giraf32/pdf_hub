import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/folder_pdf_api.dart';
import '../../../utility/pdf_function.dart';
import '../../ui/widget/widget_pdf_file/show_alert_dialog_pdf.dart';
import '../model/pdf_model.dart';

class ProviderFolderPdf extends ChangeNotifier {
  ProviderFolderPdf({required this.pdfRepository});
  final FolderPdfApi pdfRepository;

  // final pdfRepository =
  // FolderPdfRepository(dbServicesPdf: DbServicesPdf(InitDb.create()));

  var listPdfFileByNameFolder = <PdfModel?>[];
  var listPdfAdd = <PdfModel?>[];
  var listPdfAddFolder = <PdfModel?>[];

  bool _isTextButton = false;

  bool get isTextButton => _isTextButton;

  void setTextButton(bool value) {
    _isTextButton = value;
    notifyListeners();
  }

  void setAddPdfListFolder(PdfModel pdfModel) {
    listPdfAddFolder.add(pdfModel);
    // notifyListeners();
  }

  void deletePdfListFolder(PdfModel pdfModel) {
    int? id = pdfModel.id;
    listPdfAddFolder.removeWhere((pdfModel) => pdfModel?.id == id);
  }

  void clearListPdfAddFolder() {
    listPdfAddFolder.clear();
  }

  Future<void> updateListFolderByName(String nameFolder) async {
    try {
      listPdfFileByNameFolder = await pdfRepository.getLisPdfByNameFolderFromDb(
          nameFolder: nameFolder);
    } catch (e, s) {
      print('Error updateListFolderByName: $e');
      print('Error updateListFolderByName: $s');
    }

    notifyListeners();
  }

  Future<void> saveFileFolder(List<PdfModel?> listPdfModel,
      BuildContext context, String nameFolder) async {
    try {
      print('nameFolderSaveFileFolder : $nameFolder');
      print('pdfModelSaveFileFolder : $listPdfModel');
      final listFolder = await pdfRepository.getLisPdfByNameFolderFromDb(
          nameFolder: nameFolder);

      if (listFolder.isNotEmpty) {
        final pdfModelClone =
            comparePdfModel(listFirst: listPdfModel, listSecond: listFolder);
        if (!context.mounted) return;
        if (pdfModelClone.isNotEmpty) {
          await showAlertDialogPdf(context, pdfModelClone);
        }
      }

      await pdfRepository.saveFileFolderAppStorage(
          listPdfModels: listPdfModel, nameFolder: nameFolder);
      await updateListFolderByName(nameFolder);
    } catch (e, s) {
      print('Error savePdfFavourites: $e');
      print('Error savePdfFavourites: $s');
    }
  }

  Future<void> deletePdfFromFolder(String folder) async {
    try {
      await pdfRepository.deletePdfModelByNameFolderFromDb(nameFolder: folder);
    } catch (e, s) {
      print('Error deletePdfFolder: $e');
      print('Error deletePdfFolder: $s');
    }

    await updateListFolderByName(folder);
  }

  Future<void> changeFolder(
      {required String nameFolder, required String newNameFolder}) async {
    try {
      await pdfRepository.changeNameFolder(
          nameFolder: nameFolder, newNameFolder: newNameFolder);
    } catch (e, s) {
      print('Error changePdfFolder: $e');
      print('Error changePdfFolder: $s');
    }
  }

  Future<void> deleteFilePdf(PdfModel pdfModel) async {
    try {
      await pdfRepository.deleteFilePdfAndModelDb(pdfModel: pdfModel);
      await updateListFolderByName(pdfModel.folder);
    } catch (e, s) {
      print('Error delete: $e');
      print('Error delete: $s');
    }
  }

  Future<void> updatePdfFolderModelDb(PdfModel newPdfModel) async {
    try {
      await pdfRepository.updatePdfModelFolder(pdfModel: newPdfModel);
      await updateListFolderByName(newPdfModel.folder);
    } catch (e, s) {
      print('Error updatePdfNameFile: $e');
      print('Error updatePdfNameFile: $s');
    }
  }
}
