import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/dekho/dekho_validation_content_section.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/language_selection.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:VoiceGive/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class DekhoValidationScreen extends StatefulWidget {
  const DekhoValidationScreen({super.key});

  @override
  State<DekhoValidationScreen> createState() => _DekhoValidationScreenState();
}

class _DekhoValidationScreenState extends State<DekhoValidationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final LanguageProvider _languageProvider = LanguageProvider();
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
                logoAsset: 'assets/images/dekho_header.png',
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
                      itemId: 'dekho_validation_item_$currentIndex', // Replace with actual validation item ID
                      module: 'dekho',
                    ),
                    SizedBox(height: 16.w),
                    LanguageSelection(
                      description: "Select the language for validation",
                      initialLanguage: _languageProvider.selectedLanguage,
                      onLanguageChanged: (value) {
                        _languageProvider.updateLanguage(value);
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 24.w),
                    DekhoValidationContentSection(
                      language: _languageProvider.selectedLanguage,
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