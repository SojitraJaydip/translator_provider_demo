import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:translator_provider_demo/main.dart';
import 'package:translator_provider_demo/model/available_language.dart';
import 'package:translator_provider_demo/model/translation_model.dart';
import 'package:translator_provider_demo/utils/custom_snackbar.dart';

class FetchAllLanguageProvider extends ChangeNotifier {
  bool _isLoading = false;
  Language? _language;
  Languages? _translateFrom;
  TranslatedText? _translatedText;
  String? _errorMessage;
  final TextEditingController translateFromController = TextEditingController();
  late FlutterTts _flutterTts;
  bool _isSpeakingFromLanguage = false;
  bool _isSpeakingToLanguage = false;
  bool _isErrorFromTranslationText = false;
  bool _isErrorToTranslationText = false;
  bool _isErrorFromTextField = false;

  bool _isTranslating = false;

  String _translateFromText = "";

  String _translateToText = "";

  Languages? get translateFrom => _translateFrom;

  Languages? _translateTo;

  bool get isErrorFromTranslationText => _isErrorFromTranslationText;
  bool get isErrorToTranslationText => _isErrorToTranslationText;
  bool get isErrorFromTextField => _isErrorFromTextField;

  bool get isTranslating => _isTranslating;
  Language? get language => _language;
  String get translateFromText => _translateFromText;
  Languages? get translateTo => _translateTo;
  bool get isLoading => _isLoading;
  String get translateToText => _translateToText;
  TranslatedText? get translatedText => _translatedText;

  bool get isSpeakingFromLanguage => _isSpeakingFromLanguage;

  bool get isSpeakingToLanguage => _isSpeakingToLanguage;

  String? get errorMessage => _errorMessage;

  FlutterTts get flutterTts => _flutterTts;

  set errorMessage(String? value) {
    _errorMessage = value;
    //notifyListeners();
  }

  set isErrorFromTranslationText(bool value) {
    _isErrorFromTranslationText = value;
    notifyListeners();
  }

  set isErrorToTranslationText(bool value) {
    _isErrorToTranslationText = value;
    notifyListeners();
  }

  set isErrorFromTextField(bool value) {
    _isErrorFromTextField = value;
    notifyListeners();
  }

  set flutterTts(FlutterTts value) {
    _flutterTts = value;
  }

  set translateTo(Languages? value) {
    _translateTo = value;
    notifyListeners();
  }

  set translateFromText(String value) {
    _translateFromText = value;
    notifyListeners();
  }

  set translateFrom(Languages? value) {
    _translateFrom = value;
    notifyListeners();
  }

  set language(Language? value) {
    _language = value;
    notifyListeners();
  }

  set translateToText(String value) {
    _translateToText = value;
    notifyListeners();
  }

  set translatedText(TranslatedText? value) {
    _translatedText = value;
    notifyListeners();
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  set isSpeakingFromLanguage(bool value) {
    _isSpeakingFromLanguage = value;
    notifyListeners();
  }

  set isTranslating(bool value) {
    _isTranslating = value;
    notifyListeners();
  }

  set isSpeakingToLanguage(bool value) {
    _isSpeakingToLanguage = value;
    notifyListeners();
  }

  final String _baseUrl = "https://text-translator2.p.rapidapi.com";
  Future<void> getAllLanguages() async {
    errorMessage = null;
    isLoading = true;
    try {
      final url = Uri.parse("$_baseUrl/getLanguages");

      final data = await http.get(url, headers: {
        "X-RapidAPI-Key": "83e9e809demsh4dbb3bd71f9bf1cp19770bjsnef003333bb21",
        "X-RapidAPI-Host": "text-translator2.p.rapidapi.com",
      });

      if (data.statusCode == 200) {
        language = Language.fromJson(jsonDecode(data.body));
      } else {
        errorMessage = "Something went wrong";
        CustomSnackBar.show(navigatorKey.currentContext!,
            "Something went wrong", SnackBarType.error);
      }
    } on SocketException catch (e) {
      errorMessage = e.message;

      CustomSnackBar.show(navigatorKey.currentContext!,
          'Please check your internet connection!', SnackBarType.error);
    } catch (e) {
      errorMessage = e.toString();
      CustomSnackBar.show(navigatorKey.currentContext!, "Someting went wrong",
          SnackBarType.error);
    } finally {
      isLoading = false;
    }
  }

  void resetError() {
    isErrorFromTranslationText = false;
    isErrorToTranslationText = false;
    isErrorFromTextField = false;
  }

  Future<void> translateText({bool loading = false}) async {
    if (loading) {
      isLoading = true;
    }
    isTranslating = true;
    try {
      final url = Uri.parse("$_baseUrl/translate");

      final data = await http.post(url, headers: {
        "X-RapidAPI-Key": "83e9e809demsh4dbb3bd71f9bf1cp19770bjsnef003333bb21",
        "X-RapidAPI-Host": "text-translator2.p.rapidapi.com",
      }, body: {
        "source_language": translateFrom?.code ?? 'en',
        "target_language": translateTo?.code ?? 'gu',
        "text": translateFromController.text,
      });

      if (data.statusCode == 200) {
        translatedText = TranslatedText.fromJson(jsonDecode(data.body));
        translateToText = translatedText?.translationData?.translatedText ?? "";
      } else {
        print(data.statusCode);
      }
    } on SocketException catch (e) {
      errorMessage = e.message;

      CustomSnackBar.show(navigatorKey.currentContext!,
          'Please check your internet connection!', SnackBarType.error);
    } catch (e) {
      errorMessage = e.toString();
      CustomSnackBar.show(navigatorKey.currentContext!, "Something went wrong",
          SnackBarType.error);
    } finally {
      if (loading) {
        isLoading = false;
      }
      isTranslating = false;
    }
  }

  Future<void> speakToLanguageText() async {
    isSpeakingToLanguage = true;
    flutterTts = FlutterTts();

    try {
      await flutterTts.setLanguage(translateTo?.code ?? "en-US");
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(translateToText);

      flutterTts.setCompletionHandler(() {
        flutterTts.stop();
        isSpeakingToLanguage = false;
        print("Stop Speaking");
      });
    } catch (e) {
      CustomSnackBar.show(navigatorKey.currentContext!, "Something went wrong",
          SnackBarType.error);
    }
  }

  Future<void> speakFromLanguageText() async {
    isSpeakingFromLanguage = true;
    flutterTts = FlutterTts();

    try {
      await flutterTts.setLanguage(translateFrom?.code ?? "en-US");
      await flutterTts.setPitch(1);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(translateFromText);

      flutterTts.setCompletionHandler(() {
        flutterTts.stop();
        print("Stop Speaking");
        isSpeakingFromLanguage = false;
      });
    } catch (e) {
      CustomSnackBar.show(navigatorKey.currentContext!, "Something went wrong",
          SnackBarType.error);
    }
  }
}
