import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/sizes_helper.dart';
import '../widgets/card.dart';
import 'create_pdf_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dateInputController = TextEditingController();
  final vehicleIdController = TextEditingController();

  String image1 = "";
  String image2 = "";
  String image3 = "";
  String image4 = "";
  String image5 = "";
  String image6 = "";
  String image7 = "";

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
    await _saveInfo();
    if (isAllAvailable) {
      print(image1.toString());
      print(image2.toString());
      print(image3.toString());
      print(image4.toString());
      print(image5.toString());
      print(image6.toString());
      print(image7.toString());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PdfScreen()),
      );
    } else {
      print("Images are empty!!");
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text("Please select all the images first!"),
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
        image1 = prefs.getString("STEP 1")!;
        image2 = prefs.getString("STEP 2")!;
        image3 = prefs.getString("STEP 3")!;
        image4 = prefs.getString("STEP 4")!;
        image5 = prefs.getString("STEP 5")!;
        image6 = prefs.getString("STEP 6")!;
        image7 = prefs.getString("STEP 7")!;
        _isAvailable();
      } catch (e) {
        isAllAvailable = false;
      }
    });
  }

  _isAvailable() {
    if (image1.length > 1 &&
        image2.length > 1 &&
        image3.length > 1 &&
        image4.length > 1 &&
        image5.length > 1 &&
        image6.length > 1 &&
        image7.length > 1) {
      isAllAvailable = true;
    }
  }
  
  _saveInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Date", dateInputController.text);
    prefs.setString("Vehicle", vehicleIdController.text);
  }
}
