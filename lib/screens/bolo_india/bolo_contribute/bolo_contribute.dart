import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_contribute/widgets/bolo_content_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/language_selection.dart';
import 'package:VoiceGive/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoloContribute extends StatefulWidget {
  const BoloContribute({super.key});

  @override
  State<BoloContribute> createState() => _BoloContributeState();
}

class _BoloContributeState extends State<BoloContribute> {
  final LanguageProvider _languageProvider = LanguageProvider();
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
        appBar: CustomAppBar(
          showThreeLogos: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              BoloHeadersSection(
                logoAsset: 'assets/images/bolo_header.png',
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
                      itemId: 'bolo_item_${currentIndex.value}', // Replace with actual item ID
                      module: 'bolo',
                    ),
                    SizedBox(height: 16.w),
                    LanguageSelection(
                      description: AppLocalizations.of(context)!
                          .selectLanguageForContribution,
                      initialLanguage: _languageProvider.selectedLanguage,
                      onLanguageChanged: (value) {
                        _languageProvider.updateLanguage(value);
                        currentIndex.value = 0;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 24.w),
                    ValueListenableBuilder<int>(
                        valueListenable: currentIndex,
                        builder: (context, index, child) {
                          return BoloContentSection(
                            language: _languageProvider.selectedLanguage,
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
      ),
    );
  }
}
