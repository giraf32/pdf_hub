import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/model/pdf_model.dart';
import 'package:pdf_hub/app/settings/info_app.dart';
import 'package:pdf_hub/app/ui/widget/widget_folder/folder_pdf_list.dart';

import '../app/ui/viewer_pdf/pdf_rx.dart';

class OpenPdfRx {
  void openPDFRoute(BuildContext context, File file, PdfModel pdfModel) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PdfRx(
                file: file,
                pdfModel: pdfModel,
              )));
}

// class OpenPdfScreenHome {
//   void openPDFRoute(BuildContext context) => Navigator.of(context).push(
//       MaterialPageRoute(builder: (context) => HistoryPagePdf(title: 'Home')));
// }
// class OpenFolder {
//   void openPDFRoute(BuildContext context) => Navigator.of(context).push(
//       MaterialPageRoute(builder: (context) => FolderPage()));
// }
class OpenListPdfFolder {
  void openPDFRoute(BuildContext context, String nameFolder) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FolderPdfList(nameFolder: nameFolder)));
}

class OpenInfo {
  void openInfoAppRoute(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => InfoApp()));
}
