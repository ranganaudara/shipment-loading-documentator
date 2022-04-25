import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatefulWidget {
  String pdfFile;

   PdfScreen({
    Key? key,
    required this.pdfFile,
}) :super(key: key);
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Visibility(
                visible: widget.pdfFile.isNotEmpty,
                child: SfPdfViewer.file(File(widget.pdfFile),
                    canShowScrollHead: false, canShowScrollStatus: false),
              ),
            ),
            // TextButton(
            //     onPressed: () async {
            //       Navigator.pop(context,true);
            //       // await createPdfFile();
            //       // savePdfFile();
            //     },
            //     child: Text('Create a Pdf')),
          ],
        ),
      ),
    );
  }
}