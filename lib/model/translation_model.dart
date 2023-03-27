class TranslatedText {
  TranslationData? translationData;

  TranslatedText({this.translationData});

  TranslatedText.fromJson(Map<String, dynamic> json) {
    translationData =
        json['data'] != null ? TranslationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (translationData != null) {
      data['data'] = translationData!.toJson();
    }
    return data;
  }
}

class TranslationData {
  String? translatedText;

  TranslationData({this.translatedText});

  TranslationData.fromJson(Map<String, dynamic> json) {
    translatedText = json['translatedText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['translatedText'] = translatedText;
    return data;
  }
}
