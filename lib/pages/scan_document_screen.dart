// Code used:
// https://docs.flutter.dev/cookbook/plugins/picture-using-camera

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:penzz/helpers/filter_image.dart';
import 'package:penzz/pages/save_document_screen.dart';

// A screen that allows users to take a picture using a given camera.
class ScanDocumentScreen extends StatefulWidget {
  static const String id = 'scan_document_screen';
  final bool launchedFromDisplayDocument;

  const ScanDocumentScreen({Key? key, this.launchedFromDisplayDocument = false}) : super(key: key);

  @override
  ScanDocumentScreenState createState() => ScanDocumentScreenState(launchedFromDisplayDocument: launchedFromDisplayDocument);
}

class ScanDocumentScreenState extends State<ScanDocumentScreen> {
  late CameraController _controller;
  late Future<void> _initializeCamera;
  final bool launchedFromDisplayDocument;
  List<String> editedImages = [];

  ScanDocumentScreenState({required this.launchedFromDisplayDocument});

  @override
  void initState() {
    super.initState();
    _initializeCamera = _initializeCameraFunc();
  }

  Future<void> _initializeCameraFunc() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.
        body: FutureBuilder<void>(
          future: _initializeCamera,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15,),
                  CameraPreview(_controller),
                ]
              );
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: FloatingActionButton(
                heroTag: "doneFloatingButton",
                onPressed: done,
                child: const Icon(Icons.check),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: FloatingActionButton(
                heroTag: "takePictureFloatingButton",
                onPressed: takePicture,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeCamera;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      // TODO: Detect the edges of a paper

      // Enhance the image to make it look like pdf
      File editedImage = await(editImage(File(image.path)));

      editedImages.add(editedImage.path);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  Future<bool> goBack() async {
    if (launchedFromDisplayDocument) {
      return true;
    }
    Navigator.pop(context, []);
    return true;
  }

  Future<void> done() async {
    // Display the images just taken
    if (launchedFromDisplayDocument) {
      Navigator.pop(context, editedImages);
      return;
    }
    await Navigator.pushReplacementNamed(
        context,
        SaveDocumentScreen.id,
        arguments: editedImages,
    );
  }
}



