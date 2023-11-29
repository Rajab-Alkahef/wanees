import 'package:flutter/material.dart';
import 'package:voice_app/models/tts_model.dart';
import 'package:voice_app/view/home_view.dart';
// import 'package:voice_app/view/camera_view.dart';
// import 'package:voice_app/view/send_photo_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(s))
  TextToSpech.initTTS();
  runApp(const FriendApp());
}

class FriendApp extends StatelessWidget {
  const FriendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
