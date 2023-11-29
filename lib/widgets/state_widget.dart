import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class StateWidget extends StatelessWidget {
  const StateWidget({
    super.key,
    required SpeechToText speechToText,
    required bool speechEnabled,
  })  : _speechToText = speechToText,
        _speechEnabled = speechEnabled;

  final SpeechToText _speechToText;
  final bool _speechEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          _speechToText.isListening
              ? "Is Listing..........."
              // If listening isn't active but could be tell the user
              // how to start it, otherwise indicate that speech
              // recognition is not yet ready or not supported on
              // the target device
              : _speechEnabled
                  ? "press button"
                  : 'Speech not available',
          maxLines: 18,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
