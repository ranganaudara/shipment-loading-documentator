import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'pdf_screen.dart';
import '../util/sizes_helper.dart';
import '../widgets/card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dateInputController = TextEditingController();
  final vehicleIdController = TextEditingController();

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

  bool isAllAvailable = false;

  @override
  void initState() {
    dateInputController.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  void dispose() {
    vehicleIdController.dispose();
    dateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: displayHeight(context) * 0.03),
            Image(
                image: AssetImage('assets/images/mas_logo.png'),
                height: displayHeight(context) * 0.07),
            SizedBox(height: displayHeight(context) * 0.02),
            Text(
              "Shipment Loading Documentator",
              style: TextStyle(
                  fontSize: displayHeight(context) * 0.03,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: displayHeight(context) * 0.01,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: dateInputController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    constraints:
                        BoxConstraints(maxWidth: displayWidth(context) * 0.2),
                    labelText: "Date",
                    hintText: 'Enter the Date',
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                      setState(() {
                        dateInputController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: vehicleIdController,
                  decoration: InputDecoration(
                    constraints:
                        BoxConstraints(maxWidth: displayWidth(context) * 0.2),
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle Number',
                    hintText: 'Enter the Vehicle Number',
                  ),

                ),
              ),
            ]),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: EdgeInsets.all(displayHeight(context) * 0.02),
                crossAxisSpacing: displayWidth(context) * 0.01,
                mainAxisSpacing: displayWidth(context) * 0.01,
                crossAxisCount: 3,
                children: const <Widget>[
                  CamCard("Lorry/Container with Vehicle/Container number",
                      "STEP 1"),
                  CamCard(
                      "Empty lorry/container with vehicle number", "STEP 2"),
                  CamCard(
                      "Stage where half of the loading is completed", "STEP 3"),
                  CamCard(
                      "Stage where the loading is 100% completed", "STEP 4"),
                  CamCard("Doors are closed", "STEP 5"),
                  CamCard("Security guard is putting the ISO certified seal",
                      "STEP 6"),
                  CamCard("Picture of the seal with the seal number", "STEP 7"),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () async {
                await _generateReport();
              },
              child: const Text('Generate Report'),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  _generateReport() async {
    await _getImagePaths();

    //await _saveInfo();
    if (isAllAvailable) {
      print(imagePath1.toString());
      print(imagePath2.toString());
      print(imagePath3.toString());
      print(imagePath4.toString());
      print(imagePath5.toString());
      print(imagePath6.toString());
      print(imagePath7.toString());
      await createPdfFile();
      savePdfFile();
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfScreen(pdfFile:pdfFile),)
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const PdfScreen()),
      // );
    }
    else {
      print("Images are empty!!");
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text("Please complete all data first!"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          );
        },
      );
    }
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
        date = dateInputController.text;
        vehicleNumber = vehicleIdController.text;
        _isAvailable();
      } catch (e) {
        isAllAvailable = false;
      }
    });
  }

  _isAvailable() {
    if (imagePath1.length > 1 &&
        imagePath2.length > 1 &&
        imagePath3.length > 1 &&
        imagePath4.length > 1 &&
        imagePath5.length > 1 &&
        imagePath6.length > 1 &&
        imagePath7.length > 1 &&
        vehicleNumber.length>1&&
        date.length>1) {
      isAllAvailable = true;
      print(vehicleNumber.length);
    }
  }
  
  // _saveInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("Date", dateInputController.text);
  //   prefs.setString("Vehicle", vehicleIdController.text);
  // }

  //PDF CREATE SECTION
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
        Fluttertoast.showToast(
            msg: "PDF Saved : "+pdfFile,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black12,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });

    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    isAllAvailable = false;
  }
}
