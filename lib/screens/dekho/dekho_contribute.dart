import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/language_selection.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/dekho/dekho_content_section.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:VoiceGive/config/branding_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DekhoContribute extends StatefulWidget {
  const DekhoContribute({super.key});

  @override
  State<DekhoContribute> createState() => _DekhoContributeState();
}

class _DekhoContributeState extends State<DekhoContribute> {
  LanguageModel selectedLanguage = LanguageModel(
    languageCode: 'hi',
    languageName: 'Hindi',
    nativeName: 'हिन्दी',
    isActive: true,
    region: 'India',
    speakers: '',
  );

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(
        showThreeLogos: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            BoloHeadersSection(
              logoAsset: 'assets/images/dekho_header.png',
              title: 'DEKHO India',
              subtitle: 'Enrich your language by describing images',
              onBackPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const ModuleSelectionScreen()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0).r,
              child: Column(
                children: [
                  ActionsSection(),
                  SizedBox(height: 16.w),
                  LanguageSelection(
                description: 'Select the language for contribution',
                initialLanguage: selectedLanguage,
                onLanguageChanged: (language) {
                  setState(() {
                    selectedLanguage = language;
                    currentIndex = 0;
                  });
                },
                  ),
                  SizedBox(height: 24.w),
                  DekhoContentSection(
                    selectedLanguage: selectedLanguage,
                    indexUpdate: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    currentIndex: currentIndex,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
