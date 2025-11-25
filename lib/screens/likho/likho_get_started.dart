import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:VoiceGive/models/get_started_model.dart';
import 'package:VoiceGive/screens/likho/likho_contribute.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_get_started/get_started_item.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/branding_config.dart';

class LikhoGetStarted extends StatefulWidget {
  const LikhoGetStarted({super.key});

  @override
  State<LikhoGetStarted> createState() => _LikhoGetStartedState();
}

class _LikhoGetStartedState extends State<LikhoGetStarted> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<GetStartedModel> getStartedData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeGetStartedData();
  }

  void _initializeGetStartedData() {
    final l10n = AppLocalizations.of(context)!;
    getStartedData = [
      GetStartedModel(
        title: l10n.checkYourSetup,
        illustrationImageUrl: "assets/images/bolo_illustration1.png",
        instructions: [
          GetStartedInstruction(
            title: l10n.pleaseTestYourSpeaker,
            description: l10n.pleaseTestYourSpeakerDescription,
            iconPath: "assets/icons/support_icon.png",
          ),
          GetStartedInstruction(
            title: l10n.pleaseTestYourMicrophone,
            description: l10n.pleaseTestYourMicrophoneDescription,
            iconPath: "assets/icons/mic_icon.png",
          ),
          GetStartedInstruction(
            title: l10n.noBackgroundNoise,
            description: l10n.noBackgroundNoiseDescription,
            iconPath: "assets/icons/sound_off_icon.png",
          ),
        ],
      ),
      GetStartedModel(
        title: l10n.speakNaturally,
        illustrationImageUrl: "assets/images/bolo_illustration2.png",
        instructions: [
          GetStartedInstruction(
            title: l10n.recordExactlyAsShown,
            description: l10n.recordExactlyAsShownDescription,
            iconPath: "assets/icons/record_icon.png",
          ),
          GetStartedInstruction(
            title: l10n.dontRecordPunctuations,
            description: l10n.dontRecordPunctuationsDescription,
            iconPath: "assets/icons/punctuation_icon.png",
          ),
          GetStartedInstruction(
            title: l10n.tapRecordToStart,
            description: l10n.tapRecordToStartDescription,
            iconPath: "assets/icons/play_icon.png",
          ),
        ],
      ),
    ];
  }

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
                logoAsset: 'assets/images/likho_header.png',
              title: 'LIKHO India',
              subtitle: 'Enrich your language by donating your text',
              onBackPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const ModuleSelectionScreen()),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0).r,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: getStartedData.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    final data = getStartedData[index];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            data.title,
                            style: BrandingConfig.instance.getPrimaryTextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.w),
                          ImageWidget(
                            imageUrl: data.illustrationImageUrl,
                            height: 220.w,
                            width: 220.w,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0).r,
                            child: Column(
                              children: [
                                for (int i = 0;
                                    i < data.instructions.length;
                                    i++) ...[
                                  GetStartedItem(
                                    iconPath: data.instructions[i].iconPath,
                                    title: data.instructions[i].title,
                                    description:
                                        data.instructions[i].description,
                                  ),
                                  if (i < data.instructions.length - 1)
                                    Divider(
                                      color: AppColors.grey08,
                                      height: 30.w,
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 8.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              child: Row(
                children: [
                  Row(
                    children: List.generate(
                      getStartedData.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: _currentPage == i ? 16.w : 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.orange
                              : AppColors.grey16,
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 130.w,
                    child: PrimaryButtonWidget(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(8).r,
                        border: Border.all(color: AppColors.grey),
                      ),
                      title: AppLocalizations.of(context)!.skip,
                      textColor: AppColors.grey84,
                      textFontSize: 16.sp,
                      verticalPadding: 12.w,
                      horizontalPadding: 22.w,
                      onTap: () {
                        if (_currentPage == 0) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LikhoContribute(),
                            ),
                          );
                        }
                      },
                    ),
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