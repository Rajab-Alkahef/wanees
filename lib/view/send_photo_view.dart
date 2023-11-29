// import 'dart:async';

// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_app/services/api_py_response.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.file});
  final XFile file;
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Receive Photos'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Keep your face in front of camera'),
              ElevatedButton(
                onPressed: () async {
                  ApiHandler api = ApiHandler("as");
                  // final pickedFile =
                  //     await ImagePicker().pickImage(source: ImageSource.camera);
                  await api.sendData(widget.file);
                },
                child: const Text('Select Photo'),
              ),
              const Text(""),
            ],
          ),
        ),
      ),
    );
  }
}




// // Pick an image from the device gallery.
                  // final pickedFile = await ImagePicker().pickImage(
                  //     source: ImageSource.gallery); //ImageSource.gallery);

                  // // If an image was picked, send it to the Flask API endpoint.
                  // if (pickedFile != null) {
                  //   // Create a new multipart request.
                  //   final multipartRequest = MultipartRequest(
                  //       'POST', Uri.parse('http://localhost:5000/api/photo'));

                  //   // Add the photo to the request.
                  //   multipartRequest.files.add(
                  //     MultipartFile(
                  //       'photo',
                  //       pickedFile.openRead(),
                  //       MultipartFile.fromBytes("photo", [4, 4, 4]).length,
                  //       filename: pickedFile.path,
                  //     ),
                  //   );

                  //   // Send the request.
                  //   final response = await multipartRequest.send();

                  //   // If the response is successful, show a success message.
                  //   if (response.statusCode == 200) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //           content: Text('Photo successfully sent!')),
                  //     );
                  //   } else {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //           content: Text('Error sending photo.'),
                  //           backgroundColor: Colors.red),
                  //     );
                  //   }
                  // }