import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyPdfViewer extends StatefulWidget {
  const MyPdfViewer({super.key, required this.file});
  final File file;
  @override
  State<MyPdfViewer> createState() => _MyPdfViewerState();
}

class _MyPdfViewerState extends State<MyPdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf Viewer'),
        backgroundColor: Colors.amber,
      ),
      body: SfPdfViewer.file(widget.file,maxZoomLevel: 7,),
    );
  }
}
