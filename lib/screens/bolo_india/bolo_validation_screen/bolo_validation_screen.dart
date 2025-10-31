import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_validation_screen/widgets/bolo_validate_section.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/language_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

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

  bool isCompleted = false;
  LanguageModel selectedLanguage = LanguageModel(
      languageName: "Marathi",
      nativeName: "मराठी",
      isActive: true,
      languageCode: "mr",
      region: "India",
      speakers: "");

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Start animations
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  BoloHeadersSection(),
                  Padding(
                    padding: const EdgeInsets.all(12.0).r,
                    child: Column(
                      children: [
                        ActionsSection(),
                        SizedBox(height: 16.w),
                        LanguageSelection(
                          description: "Select language for validation",
                          onLanguageChanged: (value) {
                            selectedLanguage = value;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 24.w),
                        BoloValidateSection(
                          languageModel: selectedLanguage,
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
