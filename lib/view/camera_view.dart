import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_app/services/api_py_response.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  File? imagePath;
  XFile? imageToSend;
  bool isCapturingPhoto = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startPeriodicTimer();
    // _controller = CameraController(
    //   widget.camera,
    //   ResolutionPreset.medium,
    // );
    // _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  _startPeriodicTimer() {
    const duration = Duration(seconds: 35);
    Timer.periodic(duration, (Timer timer) async {
      if (!isCapturingPhoto) {
        isCapturingPhoto = true;
        await _controller.startImageStream((CameraImage image) async {
          // Process the live camera image if needed
        });

        imageToSend = await takePhoto();
        ApiHandler api = ApiHandler("as");
        await api.sendData(imageToSend!);

        await _controller.stopImageStream(); // Stop the live stream
        isCapturingPhoto = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final periodicTimer = Timer.periodic(
    //   const Duration(seconds: 35),
    //   (timer) async {
    //     imageToSend = await takePhoto();
    //     ApiHandler api = ApiHandler("as");
    //     // final pickedFile =
    //     //     await ImagePicker().pickImage(source: ImageSource.camera);
    //     await api.sendData(imageToSend!);
    //     // Update user about remaining time
    //   },
    // );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Camera App')),
        // body: const Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text('Keep your face in front of camera'),
        //       Text(""),
        //     ],
        //   ),
        // ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: cheakConnection,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: takePhoto,
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }

  takePhoto() async {
    try {
      await _initializeControllerFuture;
      final XFile picture = await _controller.takePicture();

      setState(() {
        showCapturedPhoto = true;
        imagePath = File(picture.path);
      });
      return picture;
      // Use 'picture' for further processing (e.g., display, save, share).
    } catch (e) {
      log("Error taking picture: $e");
    }
  }

  Widget cheakConnection(context, snapshot) {
    // final size = MediaQuery.of(context).size;
    // final deviceRatio = size.width / size.height;
    if (snapshot.connectionState == ConnectionState.done) {
      return Center(child: CameraPreview(_controller));
      // showCapturedPhoto == false
      //     ? CameraPreview(_controller)
      //     : Center(child: Image.file(imagePath!)), //
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
