import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator_provider_demo/custom_widget/listening_widget.dart';
import 'package:translator_provider_demo/extenstion.dart';

class ListingSpeechProvider extends ChangeNotifier {
  String _recordedText = '';
  OverlayEntry? _overlayEntry;
  final stt.SpeechToText _speech = stt.SpeechToText();

  String get recordedText => _recordedText;
  OverlayEntry? get overlayEntry => _overlayEntry;

  set overlayEntry(OverlayEntry? value) {
    _overlayEntry = value;
    notifyListeners();
  }

  set recordedText(String value) {
    _recordedText = value;
    notifyListeners();
  }

  void init() {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: MediaQuery.of(context).size.height / 2 - 150,
          left: MediaQuery.of(context).size.width / 2 - 150,
          child: Material(
            elevation: 4.0,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: <Widget>[
                  const ListeningMic(isListening: true)
                      .paddingSymmetric(vertical: 16, horizontal: 8),
                  const Text(
                    'Listening...',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ).paddingOnly(bottom: 16),

                  /* RaisedButton(
                    child: Text('Close'),
                    onPressed: () {
                      _overlayEntry.remove();
                      _overlayEntry = null;
                      setState(() {
                        _isHoldingButton = false;
                      });
                    },
                  ),*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void startListening() async {
    bool available = await _speech.initialize();
    if (!available) {
      print('The user has denied the use of speech recognition.');
      return;
    }
    _speech.listen(
      onResult: (result) {
        recordedText = result.recognizedWords;
      },
      onSoundLevelChange: (level) {
        print('level: $level');
      },
    );
  }

  void stopListening() {
    _speech.stop();
    recordedText = '';
  }

  void showDialog(BuildContext context) {
    init();
    Overlay.of(context).insert(overlayEntry!);
  }

  hideDialog() {
    overlayEntry!.remove();
    overlayEntry = null;
  }
}
