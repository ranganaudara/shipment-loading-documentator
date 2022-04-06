// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// class TakePictureScreen extends StatefulWidget {
//   final CameraDescription camera;
//   TakePictureScreen({required this.camera});
//
//   @override
//   _TakePictureScreenState createState() => _TakePictureScreenState();
// }
//
// class _TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _cameraController;
//   late Future<void> _initializeCameraControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _cameraController =
//         CameraController(widget.camera, ResolutionPreset.medium);
//
//     _initializeCameraControllerFuture = _cameraController.initialize();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: <Widget>[
//       FutureBuilder(
//         future: _initializeCameraControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_cameraController);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     ]);
//   }
// }