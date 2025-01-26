import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/provider/provider_pdf.dart';
import 'package:pdf_hub/app/ui/widget/widget_history/animated_text.dart';
import 'package:pdf_hub/app/ui/widget/widget_pdf_file/pdf_list_item.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<ProviderPDF>(builder: (_, notifier, __) {
      if (notifier.notifierState == NotifierState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if(notifier.pdfModelListHistory.isNotEmpty){
          return  ListView(
            children: notifier.pdfModelListHistory.map((e) {
              return PdfListItem(pdfModel: e!);
            }).toList(),
          );
        } else {
          return AnimatedText();
        }

      }
    });
  }
}
