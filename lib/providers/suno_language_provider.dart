import 'package:flutter/material.dart';
import '../screens/bolo_india/models/language_model.dart';

class SunoLanguageProvider extends ChangeNotifier {
  static final SunoLanguageProvider _instance = SunoLanguageProvider._internal();
  factory SunoLanguageProvider() => _instance;
  SunoLanguageProvider._internal();

  LanguageModel _selectedLanguage = LanguageModel(
    languageName: "Hindi",
    nativeName: "हिन्दी",
    isActive: true,
    languageCode: "hi",
    region: "India",
    speakers: "",
  );

  LanguageModel get selectedLanguage => _selectedLanguage;

  void updateLanguage(LanguageModel language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}