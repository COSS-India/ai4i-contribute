import 'package:flutter/material.dart';
import '../screens/bolo_india/models/language_model.dart';

class BoloLanguageProvider extends ChangeNotifier {
  static final BoloLanguageProvider _instance = BoloLanguageProvider._internal();
  factory BoloLanguageProvider() => _instance;
  BoloLanguageProvider._internal();

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