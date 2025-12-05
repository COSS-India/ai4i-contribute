import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_validation_screen/widgets/bolo_validate_section.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/language_selection.dart';
import 'package:VoiceGive/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../module_selection_screen.dart';

class BoloValidationScreen extends StatefulWidget {
  const BoloValidationScreen({
    super.key,
  });

  @override
  State<BoloValidationScreen> createState() => _BoloValidationScreenState();
}

class _BoloValidationScreenState extends State<BoloValidationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final LanguageProvider _languageProvider = LanguageProvider();

  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ModuleSelectionScreen()),
        );
        return false;
      },
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
                    logoAsset: 'assets/images/bolo_header.png',
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
                          itemId:
                              'bolo_validation_item', // Replace with actual validation item ID
                          module: 'bolo',
                        ),
                        SizedBox(height: 16.w),
                        LanguageSelection(
                          description: "Select language for validation",
                          initialLanguage: _languageProvider.selectedLanguage,
                          onLanguageChanged: (value) {
                            _languageProvider.updateLanguage(value);
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 24.w),
                        BoloValidateSection(
                          languageModel: _languageProvider.selectedLanguage,
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
            isCompleted
                ? Positioned(
                    child: _buildConfetti(),
                  )
                : SizedBox()
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
