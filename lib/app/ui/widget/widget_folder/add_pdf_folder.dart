import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/model/pdf_model.dart';
import 'package:pdf_hub/app/domain/provider/provider_folder_pdf.dart';
import 'package:pdf_hub/app/ui/widget/widget_folder/change_check_box.dart';

import 'package:provider/provider.dart';
import '../../../domain/provider/provider_pdf.dart';

class AddPdfFolder extends StatefulWidget {
  const AddPdfFolder({super.key, required this.folderName});

  final String folderName;

  @override
  State<AddPdfFolder> createState() => _AddPdfFolderState();
}

class _AddPdfFolderState extends State<AddPdfFolder> {
  var listPdfHistory = <PdfModel?>[];

  @override
  void initState() {
    listPdfHistory = context.read<ProviderPDF>().pdfModelListHistory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool textButton = context.watch<ProviderFolderPdf>().isTextButton;
    // final _context = context.read<ProviderFolderPdf>();
    return Container(
        height: 500,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(18.0)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            listPdfHistory.isNotEmpty
                ? Expanded(
                    flex: 6,
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          PdfModel itemPdfName = listPdfHistory[index]!;
                          return ChangeCheckBox(pdfModel: itemPdfName);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: listPdfHistory.length),
                  )
                : const Expanded(
                    flex: 4,
                    child: Text(
                      ' Файл не найден.\n Добавьте файл в приложение.',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
            SizedBox(
              height: 10,
            ),
            Expanded(
                flex: 1,
                child: textButton
                    ? TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.grey.shade300),
                        onPressed: () async {
                          var pdfListFavourites = context
                              .read<ProviderFolderPdf>()
                              .listPdfAddFolder;
                          debugPrint(
                              'listAddCheckBox _______________ $pdfListFavourites');
                          if (pdfListFavourites.isNotEmpty) {
                            await context
                                .read<ProviderFolderPdf>()
                                .saveFileFolder(pdfListFavourites, context,
                                    widget.folderName);
                            if (context.mounted) {
                              context
                                  .read<ProviderFolderPdf>()
                                  .clearListPdfAddFolder();
                              Navigator.pop(context);
                              context
                                  .read<ProviderFolderPdf>()
                                  .setTextButton(false);
                            }
                            // context.router.replace(FolderPdfRoute(nameFolder: widget.folderNam;
                          } else {
                            debugPrint(
                                'listNotCheckBox _______________ $pdfListFavourites');
                          }
                        },
                        child: const Text(
                          'Добавить в папку',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ))
                    : const Center(
                        child: Text(
                        'Выберите файл',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      )))
          ],
        ));
  }
}
