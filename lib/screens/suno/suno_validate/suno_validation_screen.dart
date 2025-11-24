import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/suno/widgets/suno_validation_content_section.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/language_selection.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SunoValidationScreen extends StatefulWidget {
  const SunoValidationScreen({super.key});

  @override
  State<SunoValidationScreen> createState() => _SunoValidationScreenState();
}

class _SunoValidationScreenState extends State<SunoValidationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  bool isCompleted = false;
  int currentIndex = 0;
  LanguageModel selectedLanguage = LanguageModel(
      languageName: "Hindi",
      nativeName: "हिन्दी",
      isActive: true,
      languageCode: "hi",
      region: "India",
      speakers: "");

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  BoloHeadersSection(
                    logoAsset: 'assets/images/suno_header.png',
                    title: 'Validation',
                    onBackPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ModuleSelectionScreen()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0).r,
                    child: Column(
                      children: [
                        ActionsSection(),
                        SizedBox(height: 16.w),
                        LanguageSelection(
                          description: "Select the language for validation",
                          onLanguageChanged: (value) {
                            selectedLanguage = value;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 24.w),
                        SunoValidationContentSection(
                          language: selectedLanguage,
                          currentIndex: currentIndex,
                          indexUpdate: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          onBackPressed: () {
                            setState(() {
                              if (currentIndex > 0) {
                                currentIndex = currentIndex - 1;
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Positioned(
                child: _buildConfetti(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return Center(
      child: Lottie.asset(
        'assets/animations/confetti.json',
        controller: _controller,
        fit: BoxFit.fill,
        alignment: Alignment.center,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          _controller.forward();
        },
      ),
    );
  }
}
