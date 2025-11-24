import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:VoiceGive/models/get_started_model.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_contribute/bolo_contribute.dart';
import 'package:VoiceGive/screens/module_selection_screen.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_get_started/get_started_item.dart';
import 'package:VoiceGive/screens/bolo_india/widgets/bolo_headers_section.dart';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';

class BoloGetStarted extends StatefulWidget {
  const BoloGetStarted({super.key});

  @override
  State<BoloGetStarted> createState() => _BoloGetStartedState();
}

class _BoloGetStartedState extends State<BoloGetStarted> {
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
    final branding = BrandingConfig.instance;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(
        showThreeLogos: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // BOLO India header with back button (full-bleed, edge-to-edge)
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.all(16).r,
            //   decoration: BoxDecoration(color: AppColors.bannerColor),
            //   child:
            //       Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //     InkWell(
            //       onTap: () {
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => const ModuleSelectionScreen()),
            //         );
            //       },
            //       child: Icon(
            //         Icons.arrow_circle_left_outlined,
            //         color: Colors.white,
            //         size: 36.sp,
            //       ),
            //     ),
            //     SizedBox(width: 24.w),
            //     branding.bannerImage.isNotEmpty
            //         ? ImageWidget(
            //             imageUrl: branding.bannerImage,
            //             height: 40.w,
            //             width: 40.w,
            //           )
            //         : SizedBox(width: 40.w, height: 40.w),
            //     SizedBox(width: 8.w),
            //   ]),
            // ),
            BoloHeadersSection(
                logoAsset: 'assets/images/bolo_header.png',
              title: 'BOLO India',
              subtitle: 'Enrich your language by donating your voice',
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
                  // Indicators (left)
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
                  // Skip button (right)
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
                              builder: (context) => const BoloContribute(),
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

  Widget actionButtons() {
    return _currentPage == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 110.w,
                child: PrimaryButtonWidget(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8).r,
                    border: Border.all(color: AppColors.darkGreen),
                  ),
                  title: AppLocalizations.of(context)!.skip,
                  textColor: AppColors.darkGreen,
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BoloContribute(),
                        ));
                  },
                ),
              ),
              SizedBox(width: 50.w),
              SizedBox(
                width: 110.w,
                child: PrimaryButtonWidget(
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkGreen),
                  ),
                  title: AppLocalizations.of(context)!.next,
                  textColor: Colors.white,
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 110.w,
                child: PrimaryButtonWidget(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8).r,
                    border: Border.all(color: AppColors.darkGreen),
                  ),
                  title: AppLocalizations.of(context)!.previous,
                  textColor: AppColors.darkGreen,
                  onTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ),
              SizedBox(width: 50.w),
              SizedBox(
                width: 110.w,
                child: PrimaryButtonWidget(
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkGreen),
                  ),
                  title: AppLocalizations.of(context)!.finish,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BoloContribute()),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
