// Code used:
// https://docs.flutter.dev/cookbook/plugins/picture-using-camera

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../filter_image.dart';

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
    return Scaffold(
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
              onPressed: done,
              child: const Icon(Icons.check),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: takePicture,
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
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

  Future<void> done() async {
    // Display the images just taken
    if (launchedFromDisplayDocument) {
      Navigator.pop(context, editedImages);
      return;
    }
    await Navigator.popAndPushNamed(
        context,
        DisplayDocumentScreen.id,
        arguments: editedImages,
    );
  }
}

class DisplayDocumentScreen extends StatefulWidget {
  static const String id = 'display_document_screen';

  const DisplayDocumentScreen({Key? key}) : super(key: key);

  @override
  State<DisplayDocumentScreen> createState() => _DisplayDocumentScreenState();
}

class _DisplayDocumentScreenState extends State<DisplayDocumentScreen> {
  late String documentPath;
  List<String> editedImages = [];
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get routes of scanned images from context when building the first time
    if (firstBuild) {
      var newEditedImages = ModalRoute.of(context)!.settings.arguments as List<String>;
      editedImages += newEditedImages;
      firstBuild = false;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Your new document')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: ListView.builder(
        itemCount: editedImages.length,
        itemBuilder: (context, index) {
          final imagePath = editedImages[index];

          return ListTile(
            title: Text("Image " + (index+1).toString() + ":", textAlign: TextAlign.center, textScaleFactor: 1.3,),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
              child: Image.file(
                File(imagePath),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addImage,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addImage() async {
    // open window for scanning images and get their routes
    final newEditedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanDocumentScreen(launchedFromDisplayDocument: true),
      ),
    );
    setState(() { editedImages += newEditedImages; });
  }
}