// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   bool _speechAvailable = false;
//   String _lastWords = '';
//   String _currentWords = '';
//   final String _selectedLocaleId = 'es_MX';

//   printLocales() async {
//     var locales = await _speechToText.locales();
//     for (var local in locales) {
//       debugPrint(local.name);
//       debugPrint(local.localeId);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   void errorListener(SpeechRecognitionError error) {
//     debugPrint(error.errorMsg.toString());
//   }

//   void statusListener(String status) async {
//     debugPrint("status $status");
//     if (status == "done" && _speechEnabled) {
//       setState(() {
//         _lastWords += " $_currentWords";
//         _currentWords = "";
//         _speechEnabled = false;
//       });
//       await _startListening();
//     }
//   }

//   /// This has to happen only once per app
//   void _initSpeech() async {
//     _speechAvailable = await _speechToText.initialize(
//         onError: errorListener,
//         onStatus: statusListener
//     );
//     setState(() {});
//   }

//   /// Each time to start a speech recognition session
//   Future _startListening() async {
//     debugPrint("=================================================");
//     await _stopListening();
//     await Future.delayed(const Duration(milliseconds: 50));
//     await _speechToText.listen(
//         onResult: _onSpeechResult,
//         localeId: _selectedLocaleId,
//         cancelOnError: false,
//         partialResults: true,
//         listenMode: ListenMode.dictation
//     );
//     setState(() {
//       _speechEnabled = true;
//     });
//   }

//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   Future _stopListening() async {
//     setState(() {
//       _speechEnabled = false;
//     });
//     await _speechToText.stop();
//   }

//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _currentWords = result.recognizedWords;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Speech Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: const Text(
//                 'Recognized words:',
//                 style: TextStyle(fontSize: 20.0),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   _lastWords.isNotEmpty
//                       ? '$_lastWords $_currentWords'
//                       : _speechAvailable
//                       ? 'Tap the microphone to start listening...'
//                       : 'Speech not available',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//         _speechToText.isNotListening ? _startListening : _stopListening,
//         tooltip: 'Listen',
//         child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
//       ),
//     );
//   }
// }


// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Receive Photos'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Select a photo to send'),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Pick an image from the device gallery.
//                   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

//                   // If an image was picked, send it to the Flask API endpoint.
//                   if (pickedFile != null) {
//                     // Create a new multipart request.
//                     final multipartRequest = MultipartRequest('POST', Uri.parse('http://localhost:5000/api/photo'));

//                     // Add the photo to the request.
//                     multipartRequest.files.add(MultipartFile('photo', pickedFile.openRead()));

//                     // Send the request.
//                     final response = await multipartRequest.send();

//                     // If the response is successful, show a success message.
//                     if (response.statusCode == 200) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Photo successfully sent!')),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error sending photo.'), backgroundColor: Colors.red),
//                       );
//                     }
//                   }
//                 },
//                 child: Text('Select Photo'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }