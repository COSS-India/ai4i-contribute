import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/likho/likho_validation_content_section.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/likho/dual_language_selection_widget.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:VoiceGive/providers/likho_language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LikhoValidationScreen extends StatefulWidget {
  const LikhoValidationScreen({super.key});

  @override
  State<LikhoValidationScreen> createState() => _LikhoValidationScreenState();
}

class _LikhoValidationScreenState extends State<LikhoValidationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final LikhoLanguageProvider _languageProvider = LikhoLanguageProvider();

  bool isCompleted = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _languageProvider.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _languageProvider.removeListener(() {});
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
                    logoAsset: 'assets/images/likho_header.png',
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
                        ActionsSection(
                          itemId: 'likho_validation_item_$currentIndex', // Replace with actual validation item ID
                          module: 'likho',
                        ),
                        SizedBox(height: 16.w),
                        DualLanguageSelectionWidget(
                          description: "Select the language for validation",
                          initialSourceLanguage: _languageProvider.sourceLanguage,
                          initialTargetLanguage: _languageProvider.targetLanguage,
                          onLanguageChanged: (sourceLanguage, targetLanguage) {
                            _languageProvider.updateLanguages(sourceLanguage, targetLanguage);
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 24.w),
                        LikhoValidationContentSection(
                          sourceLanguage: _languageProvider.sourceLanguage,
                          targetLanguage: _languageProvider.targetLanguage,
                          currentIndex: currentIndex,
                          indexUpdate: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          onComplete: () {
                            setState(() {
                              isCompleted = true;
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
