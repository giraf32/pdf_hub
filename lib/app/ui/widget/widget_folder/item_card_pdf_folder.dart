import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pdf_hub/app/ui/widget/widget_folder/menu_button_folder.dart';
import 'package:pdf_hub/app/ui/widget/widget_pdf_file/shows_first_page_card.dart';
import 'package:pdf_hub/app_router/app_router.gr.dart';
import '../../../domain/model/pdf_model.dart';

class ItemCardPdfFolder extends StatelessWidget {
  const ItemCardPdfFolder({super.key, required this.pdfModel});

  final PdfModel pdfModel;

  @override
  Widget build(BuildContext context) {
    File? file;

    return Card(
      elevation: 3,
      color: Theme.of(context).cardColor,
      child: ListTile(
        subtitle: Text(
          pdfModel.dateTime.toString(),
          style: TextStyle(fontSize: 12),
        ),
        title: Text(
          pdfModel.name,
          style: TextStyle(fontSize: 14),
        ),
        // subtitle: Text('$dateCreateFile | $sizeFile'),
        onTap: () {
          file = File(pdfModel.path);
          if (file == null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Файл не найден')));
          } else {
            // context.read<ProviderPDF>().appBarHide = false;
            if (!context.mounted) return;
            // OpenPdfRx().openPDFRoute(context, file!, pdfModel.name);
            context.router.push(PdfRx(file: file!, pdfModel: pdfModel));
          }
        },
        trailing: MenuButtonFolder(pdfModel: pdfModel),
        leading: ShowsFirstPageCard(
          filePath: pdfModel.path,
        ),
      ),
    );
  }
}
