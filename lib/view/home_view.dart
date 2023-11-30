import 'dart:async';
import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_app/models/tts_model.dart';
import 'package:voice_app/services/api_py_response.dart';
import 'package:voice_app/services/api_response.dart';
import 'package:voice_app/widgets/face_widget.dart';
import 'package:voice_app/widgets/state_widget.dart';
import 'package:voice_app/widgets/text_to_speech_result.dart';
// import 'package:voice_app/services/api_response.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String wordSpoken = "";
  double lastWords = 0;
  String gptTalk = "";
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  String emotion = "fearful";
  // File? imagePath;
  XFile? imageToSend;
  bool isCapturingPhoto = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initializeCamera();
    _startPeriodicTimer();
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
    const duration = Duration(seconds: 20);
    Timer.periodic(duration, (Timer timer) async {
      if (!isCapturingPhoto) {
        isCapturingPhoto = true;
        await _controller.startImageStream((CameraImage image) async {
          // Process the live camera image if needed
        });

        imageToSend = await takePhoto();
        ApiHandler api = ApiHandler("as");
        var req = await api.sendData(imageToSend!);
        emotion = req == 500 ? "Fearful" : req;
        setState(() {});
        print("emotion ########");
        print(emotion);
        await _controller.stopImageStream(); // Stop the live stream
        isCapturingPhoto = false;
      }
    });
  }

  Future<XFile> takePhoto() async {
    var alternativePic = XFile("assets/abd13.jpg");
    try {
      await _initializeControllerFuture;
      final XFile picture = await _controller.takePicture();

      // var picture = basepicture ?? alternativePic ;
      setState(() {
        showCapturedPhoto = true;
      });
      return picture;
      // Use 'picture' for further processing (e.g., display, save, share).
    } catch (e) {
      log("Error taking picture: $e");
      return alternativePic;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  var res;
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      lastWords = 0;
    });
  }

  ApiRespons apiRespons = ApiRespons();

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      wordSpoken = result.recognizedWords;
      lastWords = result.confidence;
    });
    print("lastWords===== $wordSpoken");
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('emotional damage============ $emotion');
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 350,
            child: StateMachineMuscot(
              emotion: emotion,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          StateWidget(
              speechToText: _speechToText, speechEnabled: _speechEnabled),
          TalkingTextResultWidget(wordSpoken: wordSpoken),
          if (_speechToText.isNotListening && lastWords > 0)
            Text(
              "Conf is ${(lastWords * 100).toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          const SizedBox(
            height: 55,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarGlow(
                animate: _speechToText.isListening ? true : false,
                glowColor: Colors.amber,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: GestureDetector(
                  onTapUp: (de) async {
                    _stopListening();

                    gptTalk = await apiRespons.getResponse(prompt: wordSpoken);
                    setState(() {});
                    TextToSpech.speak(text: gptTalk);
                    print("gptTalk======== $gptTalk");
                  },
                  onTapDown: (de) {
                    if (_speechToText.isNotListening) {
                      _startListening();
                    } else {
                      print('Speech not available');
                    }
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Center(
                      child: Icon(
                        _speechToText.isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 1,
              ),
              GestureDetector(
                onTap: () async {
                  TextToSpech.flutterTts.stop();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange,
                  child: Center(
                    child: Icon(
                      _speechToText.isListening
                          ? Icons.volume_up_outlined
                          : Icons.volume_off,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
