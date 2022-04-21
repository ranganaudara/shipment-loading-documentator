import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String pdfFile = '';

  String imagePath1 = "";
  String imagePath2 = "";
  String imagePath3 = "";
  String imagePath4 = "";
  String imagePath5 = "";
  String imagePath6 = "";
  String imagePath7 = "";

  String date = "";
  String vehicleNumber = "";

  var pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    _getImagePaths();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Visibility(
                visible: pdfFile.isNotEmpty,
                child: SfPdfViewer.file(File(pdfFile),
                    canShowScrollHead: false, canShowScrollStatus: false),
              ),
            ),
            TextButton(
                onPressed: () async {
                  await createPdfFile();
                  savePdfFile();
                },
                child: Text('Create a Pdf')),
          ],
        ),
      ),
    );
  }

  createPdfFile() {
    final image1 = pw.MemoryImage(File(imagePath1).readAsBytesSync());
    final image2 = pw.MemoryImage(File(imagePath2).readAsBytesSync());
    final image3 = pw.MemoryImage(File(imagePath3).readAsBytesSync());
    final image4 = pw.MemoryImage(File(imagePath4).readAsBytesSync());
    final image5 = pw.MemoryImage(File(imagePath5).readAsBytesSync());
    final image6 = pw.MemoryImage(File(imagePath6).readAsBytesSync());
    final image7 = pw.MemoryImage(File(imagePath7).readAsBytesSync());

    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    'STEPS OF TAKING PHOTOS IN THE LOADING PROCEDURE',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 15),
                  ),
                  pw.Divider(),
                  pw.Row(children: [
                    pw.Text("Date: " + date),
                    pw.SizedBox(width: 20),
                    pw.Text("Vehicle Number: " + vehicleNumber),
                  ]),
                  pw.SizedBox(height: 10),
                  pw.Table(border: pw.TableBorder.all(), children: [
                    pw.TableRow(children: [
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("STEP 1", textAlign: pw.TextAlign.center),
                              pw.Image(image1),
                              pw.Text(
                                "Lorry/Container with Vehicle/Container number",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 10),
                            ]),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("STEP 2", textAlign: pw.TextAlign.center),
                              pw.Image(image2),
                              pw.Text(
                                "Empty lorry/container with vehicle number",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 10),
                            ]),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("STEP 3", textAlign: pw.TextAlign.center),
                              pw.Image(image3),
                              pw.Text(
                                "Stage where half of the loading is completed",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 10),
                            ]),
                      ),
                    ]),
                    pw.TableRow(children: [
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("STEP 4", textAlign: pw.TextAlign.center),
                              pw.Image(image4),
                              pw.Text(
                                "Stage where the loading is 100% completed",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 10),
                            ]),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("STEP 5", textAlign: pw.TextAlign.center),
                              pw.Image(image5),
                              pw.Text(
                                "Doors are closed",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 10),
                            ]),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("STEP 6", textAlign: pw.TextAlign.center),
                              pw.Image(image6),
                              pw.Text(
                                "Security guard is putting the ISO certified seal",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 10),
                            ]),
                      ),
                    ]),
                    pw.TableRow(children: [
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("STEP 7", textAlign: pw.TextAlign.center),
                              pw.Image(image7),
                              pw.Text(
                                "Picture of the seal with the seal number",
                                textAlign: pw.TextAlign.center,
                              ),
                              pw.SizedBox(height: 10),
                            ]),
                      ),
                    ])
                  ]),
                ]),
          ];
        }));
  }
  /*Future<bool>savefile()async{
    Directory directory;
    if(Platform.isAndroid){
      if(await _requestPermission(Permission.storage)){
        directory = (await getExternalStorageDirectories()) as Directory;
        print(directory);
      }
      else{
        return false;
      }
    }
  }*/

  Future<bool>_requestPermission(Permission permission)async{
    if(await permission.isGranted){
      return true;
    }else{
      var result = await permission.request();
      if(result == PermissionStatus.granted){
        return true;
      }else{
        return false;
      }
    }
  }

  /*savePdfFile() async {
    Directory documentDirectory;
    String documentPath;
    if(Platform.isAndroid){
      if(await _requestPermission(Permission.storage)){
        documentDirectory = (await getExternalStorageDirectories()) as Directory;
        documentPath = documentDirectory.path;
        print(documentPath);
        String id = DateTime.now().toString();

        File file = File("$documentPath/$id.pdf");
        file.writeAsBytesSync(await pdf.save());
        setState(() {
          pdfFile = file.path;
          pdf = pw.Document();
        });
      }
      else{
        return false;
      }
    }
    // await preferences.clear();
  }*/

  savePdfFile() async {
    if(await _requestPermission(Permission.storage)){
      Directory? documentDirectory = await getExternalStorageDirectory();
      print(documentDirectory!.path);
      String documentPath = "";
      String newPath ="";
      List<String>folders = documentDirectory.path.split("/");
      for(int x = 1;x<folders.length;x++){
        String folder = folders[x];
        if(folder != "Android"){
          newPath+= "/"+folder;
        }else{
          break;
        }
      }
      newPath = newPath+"/MAS";
      documentDirectory = Directory(newPath);
      if((!await documentDirectory.exists())){
        await documentDirectory.create(recursive: true);
      }
      documentPath= documentDirectory.path;
      String id = DateTime.now().toString();

      File file = File("$documentPath/$id.pdf");

      file.writeAsBytesSync(await pdf.save());
      setState(() {
        pdfFile = file.path;
        pdf = pw.Document();
      });

    }


    // await preferences.clear();
  }

  _getImagePaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      try {
        imagePath1 = prefs.getString("STEP 1")!;
        imagePath2 = prefs.getString("STEP 2")!;
        imagePath3 = prefs.getString("STEP 3")!;
        imagePath4 = prefs.getString("STEP 4")!;
        imagePath5 = prefs.getString("STEP 5")!;
        imagePath6 = prefs.getString("STEP 6")!;
        imagePath7 = prefs.getString("STEP 7")!;
        date = prefs.getString("Date")!;
        vehicleNumber = prefs.getString("Vehicle")!;
      } catch (e) {
        print("No imagePath paths to get");
      }
    });
  }
}
