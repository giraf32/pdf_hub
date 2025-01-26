import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class ShowsFirstPageCard extends StatelessWidget {
  final String filePath;

  const ShowsFirstPageCard({super.key, required this.filePath});
 // final pdfDocument = PdfDocument(sourceName: filePath);
  @override
  Widget build(BuildContext context) {
   //  final document = PdfDocument.openFile(filePath);
    return PdfDocumentViewBuilder.file(filePath,
        key: UniqueKey(),
        builder: (context, document) => Container(
              margin: const EdgeInsets.all(2.0),
              // padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1.0, color: Colors.black26),
              ),
              height: 70,
              width: 40,
              child: PdfPageView(
                document: document,
                pageNumber: 1,
                alignment: Alignment.topCenter,
              ),
            ));
  }
}
