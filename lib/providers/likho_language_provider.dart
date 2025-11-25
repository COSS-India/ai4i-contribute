import 'package:flutter/material.dart';
import '../screens/bolo_india/models/language_model.dart';

class LikhoLanguageProvider extends ChangeNotifier {
  static final LikhoLanguageProvider _instance = LikhoLanguageProvider._internal();
  factory LikhoLanguageProvider() => _instance;
  LikhoLanguageProvider._internal();

  LanguageModel _sourceLanguage = LanguageModel(
    languageName: "Hindi",
    nativeName: "हिन्दी",
    isActive: true,
    languageCode: "hi",
    region: "India",
    speakers: "",
  );

  LanguageModel _targetLanguage = LanguageModel(
    languageName: "Marathi",
    nativeName: "मराठी",
    isActive: true,
    languageCode: "mr",
    region: "India",
    speakers: "",
  );

  LanguageModel get sourceLanguage => _sourceLanguage;
  LanguageModel get targetLanguage => _targetLanguage;

  void updateLanguages(LanguageModel source, LanguageModel target) {
    _sourceLanguage = source;
    _targetLanguage = target;
    notifyListeners();
  }
}