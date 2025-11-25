import 'package:flutter/material.dart';
import '../screens/bolo_india/models/language_model.dart';

class LanguageProvider extends ChangeNotifier {
  static final LanguageProvider _instance = LanguageProvider._internal();
  factory LanguageProvider() => _instance;
  LanguageProvider._internal();

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