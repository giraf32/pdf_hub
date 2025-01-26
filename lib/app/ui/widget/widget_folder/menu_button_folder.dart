import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/model/pdf_model.dart';
import 'package:pdf_hub/app/domain/provider/provider_folder_pdf.dart';
import 'package:pdf_hub/app/ui/widget/widget_folder/change_name_file_folder.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


class MenuButtonFolder extends StatelessWidget {
  const MenuButtonFolder({super.key, required this.pdfModel});

  final PdfModel pdfModel;

  @override
  Widget build(BuildContext context) {
    // var listFolder = context.read<ProviderPDF>().getListFolderName();
    return PopupMenuButton(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              padding: const EdgeInsets.all(5.0),
              onTap: () {
                context.read<ProviderFolderPdf>().deleteFilePdf(pdfModel);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Файл удалён'),
                  behavior: SnackBarBehavior.floating,
                ));
              },
              child: const Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 10),
                  Text('Удалить'),
                ],
              ),
            ),
            PopupMenuItem(
              padding: const EdgeInsets.all(5.0),
              onTap: () {
                Share.shareXFiles([XFile(pdfModel.path)]);
              },
              child: const Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 10),
                  Text('Отправить')
                ],
              ),
            ),
            PopupMenuItem(
              padding: const EdgeInsets.all(5.0),
              onTap: () {
                showBottomSheet(
                    backgroundColor: Theme.of(context).cardColor,
                    context: context,
                    builder: (context) {
                      return ChangeNameFileFolder(pdfModel: pdfModel);
                    });
              },
              child: const Row(
                children: [
                  Icon(Icons.drive_file_rename_outline),
                  SizedBox(width: 10),
                  Text('Переименовать')
                ],
              ),
            ),
          ];
        });
  }
}
