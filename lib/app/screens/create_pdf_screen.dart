import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  createPdfFile() async {
    final image1 = pw.MemoryImage(File(imagePath1).readAsBytesSync());
    final image2 = pw.MemoryImage(File(imagePath2).readAsBytesSync());
    final image3 = pw.MemoryImage(File(imagePath3).readAsBytesSync());
    final image4 = pw.MemoryImage(File(imagePath4).readAsBytesSync());
    final image5 = pw.MemoryImage(File(imagePath5).readAsBytesSync());
    final image6 = pw.MemoryImage(File(imagePath6).readAsBytesSync());
    final image7 = pw.MemoryImage(File(imagePath7).readAsBytesSync());
    final logoImage = pw.MemoryImage((await rootBundle.load('assets/images/mas_logo.png')).buffer.asUint8List(),);

    //CARD FOR STEPS
    stepCard(step,image,text){
      return pw.Container(
        width: 200,
        margin: pw.EdgeInsets.only(bottom: 5,top: 5),
        height: 200,
        child: pw.Column(
            mainAxisAlignment:
            pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(step, textAlign: pw.TextAlign.center),
              pw.Expanded(
                child:pw.Image(image),
              ),
              pw.Text(
                text,
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
            ]),
      );
    }

    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'STEPS OF TAKING PHOTOS IN THE LOADING\n PROCEDURE',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 15),
                  ),
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                        pw.Text("Date: " + date),
                        pw.SizedBox(height: 2),
                        pw.Text("Vehicle Number: " + vehicleNumber),]),
                        pw.Container(
                              width:100,
                              height:50 ,
                              child: pw.Image(logoImage),
                            )
                    ]),
                  pw.SizedBox(height: 10),
                  pw.Table(border: pw.TableBorder.all(), children: [
                    pw.TableRow(children: [
                      stepCard("STEP 1",image1,"Lorry/Container with Vehicle/Container number"),
                      stepCard("STEP 2",image2,"Empty lorry/container with vehicle number"),
                      stepCard("STEP 3",image3,"Stage where half of the loading is completed"),
                    ]),
                    pw.TableRow(children: [
                      stepCard("STEP 4",image4,"Stage where the loading is 100% completed"),
                      stepCard("STEP 5",image5,"Doors are closed"),
                      stepCard("STEP 6",image6,"Security guard is putting the ISO certified seal"),
                    ]),
                    pw.TableRow(children: [
                      stepCard("STEP 7",image7,"Picture of the seal with the seal number"),
                    ])
                  ]),
                ]);
        }));

  }

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

  savePdfFile() async {
    if(await _requestPermission(Permission.manageExternalStorage)){
      Directory? documentDirectory = await getExternalStorageDirectory();
      print(documentDirectory!.path);
      String documentPath = "";
      //String newPath ="";
      /*List<String>folders = documentDirectory.path.split("/");
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
      }*/
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
