import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/sizes_helper.dart';

class CamCard extends StatefulWidget {
  const CamCard(this.cardText, this.step, {Key? key}) : super(key: key);
  final String cardText;
  final String step;

  @override
  State<CamCard> createState() => _CamCardState();
}

class _CamCardState extends State<CamCard> {
  bool _isImageAvailable = false;
  late File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        splashColor: Colors.blueAccent,
        onTap: () {
          _showOptions(context);
        },
        child: SizedBox(
          width: displayWidth(context) * 0.4,
          height: displayWidth(context) * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isImageAvailable
                  ? Image.file(
                      _image,
                      height: displayWidth(context) * 0.23,
                      width: displayWidth(context) * 0.23,
                      fit: BoxFit.fitWidth,
                    )
                  : Column(
                      children: [
                        SizedBox(height: displayWidth(context) * 0.02),
                        Icon(
                          Icons.photo_camera_outlined,
                          size: displayWidth(context) * 0.05,
                        ),
                        SizedBox(height: displayWidth(context) * 0.07),
                        SizedBox(height: displayWidth(context) * 0.02),
                        Text(
                          widget.cardText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: displayWidth(context) * 0.02),
                        ),
                      ],
                    ),
              Text(
                widget.step,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text("Take a picture from camera"),
                  onTap: () {
                    Navigator.pop(context);
                    _showCamera(widget.step);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from photo library"),
                  onTap: () {
                    Navigator.pop(context);
                    _showPhotoLibrary(widget.step);
                  },
                )
              ]));
        });
  }

  void _showPhotoLibrary(step) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isImageAvailable = true;
        prefs.setString(step, pickedFile.path);
      } else {
        _showWarning(context);
      }
    });
  }

  void _showWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListTile(
            leading: const Icon(Icons.warning_amber_rounded),
            title: const Text("No image is selected"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showCamera(step) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isImageAvailable = true;
        prefs.setString(step, pickedFile.path);
      } else {
        _showWarning(context);
      }
    });
  }
}
