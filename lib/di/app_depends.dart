import 'package:pdf_hub/app/app_const.dart';
import 'package:pdf_hub/app/app_key_value.dart';
import 'package:pdf_hub/app/data/repository/folder_pdf_repository.dart';
import 'package:pdf_hub/app/data/repository/folder_repository.dart';
import 'package:pdf_hub/app/data/repository/pdf_repository.dart';
import 'package:pdf_hub/app/domain/db_api_folder.dart';
import 'package:pdf_hub/app/domain/db_api_pdf.dart';
import 'package:pdf_hub/app/domain/folder_api.dart';
import 'package:pdf_hub/app/domain/folder_pdf_api.dart';
import 'package:pdf_hub/app/domain/pdf_api.dart';
import 'package:pdf_hub/my_shared_preferences.dart';
import 'package:pdf_hub/utility/pdf_function.dart';

typedef OnError = void Function(
    String name, Object error, StackTrace? stackTrace);

class AppDepends {
  final DbApiFolder dbApiFolder;
  final DbApiPdf dbApiPdf;
  late final FolderPdfApi folderPdfRepo;
  late final FolderApi folderRepo;
  late final PdfApi pdfRepo;

  AppDepends({required this.dbApiFolder, required this.dbApiPdf});

  Future<void> init({required OnError onError}) async {
    try {
      await initFolderStart(dbApiFolder);
    } on Object catch (error, stackTrace) {
      onError("foderStert", error, stackTrace);
    }
    try {
      String? firstPage = await MySharedPreferences()
          .getFirstPage(AppKeyValue.settingsKeyFirstPages);
      if (firstPage == null) {
        await MySharedPreferences().setFirstPage(
            AppKeyValue.settingsKeyFirstPages, nameFirstPagesHistory);
      } else {
        AppKeyValue.settingsValueFirstPages = firstPage;
      }
    } on Object catch (error, stackTrace) {
      onError("mySharedPreferences", error, stackTrace);
    }
    try {
      // throw 'myError';
      pdfRepo = PdfRepository(dbServicesPdf: dbApiPdf);
     
    } on Object catch (error, stackTrace) {
      onError("pdfRepo", error, stackTrace);
    }

    try {
      folderRepo = FolderRepository(dbServicesFolder: dbApiFolder);
    } on Object catch (error, stackTrace) {
      onError("folderRepo", error, stackTrace);
    }

    try {
      folderPdfRepo = FolderPdfRepository(dbServicesPdf: dbApiPdf);
    } on Object catch (error, stackTrace) {
      onError("folderPdfRepo", error, stackTrace);
    }
  }
}
