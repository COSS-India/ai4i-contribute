import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/likho/likho_content_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/likho/dual_language_selection_widget.dart';
import 'package:VoiceGive/providers/likho_language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikhoContribute extends StatefulWidget {
  const LikhoContribute({super.key});

  @override
  State<LikhoContribute> createState() => _LikhoContributeState();
}

class _LikhoContributeState extends State<LikhoContribute> {
  final LikhoLanguageProvider _languageProvider = LikhoLanguageProvider();
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _languageProvider.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _languageProvider.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              BoloHeadersSection(
                logoAsset: 'assets/images/likho_header.png',
                title: 'Contribution',
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
                      itemId: 'likho_item_${currentIndex.value}', // Replace with actual item ID
                      module: 'likho',
                    ),
                    SizedBox(height: 16.w),
                    DualLanguageSelectionWidget(
                      description: "Select the language for contribution",
                      initialSourceLanguage: _languageProvider.sourceLanguage,
                      initialTargetLanguage: _languageProvider.targetLanguage,
                      onLanguageChanged: (source, target) {
                        _languageProvider.updateLanguages(source, target);
                        currentIndex.value = 0;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 24.w),
                    ValueListenableBuilder<int>(
                        valueListenable: currentIndex,
                        builder: (context, index, child) {
                          return LikhoContentSection(
                            sourceLanguage: _languageProvider.sourceLanguage,
                            targetLanguage: _languageProvider.targetLanguage,
                            currentIndex: index,
                            indexUpdate: (value) => setState(() {
                              currentIndex.value = value;
                            }),
                          );
                        }),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
