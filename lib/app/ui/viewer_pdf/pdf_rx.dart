import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pdf_hub/app/domain/model/pdf_model.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/provider/provider_pdf.dart';

@RoutePage()
class PdfRx extends StatefulWidget {
  final File file;
  final PdfModel pdfModel;

  const PdfRx({super.key, required this.file, required this.pdfModel});

  @override
  State<PdfRx> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PdfRx> with WidgetsBindingObserver {
  final controller = PdfViewerController();
  ProviderPDF? providerPdf;

  @override
  void initState() {
    super.initState();
    providerPdf = context.read<ProviderPDF>();
    // _pages;
  }

  double? _toolbarHeight = 50;

  _deleteToolBar() {
    _toolbarHeight = 0;
  }

  _showToolBar() {
    _toolbarHeight = 50;
  }

  int myPagesNumber = 1;

  @override
  void dispose() {
    providerPdf?.updatePageNumber(myPagesNumber, widget.pdfModel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) _deleteToolBar();
    if (orientation == Orientation.portrait && context.mounted) _showToolBar();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        toolbarHeight: _toolbarHeight,
        title: Text(
          widget.pdfModel.name,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: FutureBuilder<int?>(
          future: context.read<ProviderPDF>().getPageNumber(widget.pdfModel),
          builder: (BuildContext context, AsyncSnapshot<int?> snapshot) {
            if (snapshot.hasData) {
              return PdfViewer.file(
                widget.file.path,
                controller: controller,
                initialPageNumber: snapshot.data!,
                params: PdfViewerParams(
                    enableTextSelection: true,
                    linkHandlerParams: PdfLinkHandlerParams(
                      linkColor: Colors.grey.withAlpha(10),
                      onLinkTap: (link) {
                        // handle URL or Dest
                        if (link.url != null) {
                          // to do so or validating the link destination
                          _shouldOpenUrl(context, link.url!);
                        } else if (link.dest != null) {
                          controller.goToDest(link.dest);
                        }
                      },
                    ),
                    onViewSizeChanged: (viewSize, oldViewSize, controller) {
                      if (oldViewSize != null) {
                        final centerPosition =
                            controller.value.calcPosition(oldViewSize);
                        final newMatrix =
                            controller.calcMatrixFor(centerPosition);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          controller.goTo(newMatrix);
                        });
                      }
                    },
                    viewerOverlayBuilder: (context, size, handleLinkTap) => [
                          PdfViewerScrollThumb(
                              controller: controller,
                              orientation: ScrollbarOrientation.right,
                              thumbSize: const Size(
                                40,
                                100,
                              ),
                              thumbBuilder:
                                  (context, thumbSize, pageNumber, controller) {
                                myPagesNumber = pageNumber!;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          pageNumber.toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Icon(
                                          Icons.dehaze,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onDoubleTap: () {
                              controller.zoomUp();
                            },
                          )
                        ]),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Future<bool> _shouldOpenUrl(BuildContext context, Uri url) async {
    final result = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Navigate to URL?'),
          content: SelectionArea(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: 'Вы точно хотите перейти по этой ссылке?\n'),
                  TextSpan(
                    text: url.toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('отмена'),
            ),
            TextButton(
              // onPressed: () => Navigator.of(context).pop(true),
              onPressed: () {
                launchUrl(url);
                Navigator.of(context).pop(true);
              },
              child: const Text('перейти'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
