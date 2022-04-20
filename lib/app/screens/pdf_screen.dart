import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatefulWidget {
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String pdfFile = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: pdfFile.isNotEmpty,
              child: SfPdfViewer.file(File(pdfFile),
                  canShowScrollHead: false, canShowScrollStatus: false),
            ),
            TextButton(
                onPressed: () {
                },
                child: Text('Create a Pdf')),
          ],
        ),
      ),
    );
  }
}