import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/actions_section.dart';
import 'package:VoiceGive/screens/suno/widgets/suno_content_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/language_selection.dart';
import 'package:VoiceGive/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SunoContribute extends StatefulWidget {
  const SunoContribute({super.key});

  @override
  State<SunoContribute> createState() => _SunoContributeState();
}

class _SunoContributeState extends State<SunoContribute> {
  final LanguageProvider _languageProvider = LanguageProvider();
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  final GlobalKey _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Reset to first item when screen is initialized
    currentIndex.value = 0;
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
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              BoloHeadersSection(
                logoAsset: 'assets/images/suno_header.png',
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
                      itemId: 'suno_item_${currentIndex.value}', // Replace with actual item ID
                      module: 'suno',
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
                          return SunoContentSection(
                            key: _contentKey,
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
