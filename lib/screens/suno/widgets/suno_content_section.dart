import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/screens/suno/suno_validate/suno_validation_screen.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/audio_player/custom_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../config/branding_config.dart';

typedef IntCallback = void Function(int value);

class SunoContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;

  const SunoContentSection({
    super.key,
    required this.language,
    required this.indexUpdate,
    required this.currentIndex
  });

  @override
  State<SunoContentSection> createState() => _SunoContentSectionState();
}

class _SunoContentSectionState extends State<SunoContentSection> {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> audioCompleted = ValueNotifier<bool>(false);
  final TextEditingController textController = TextEditingController();

  int currentIndex = 0;
  final int totalContributions = 5;

  List<String> mockAudioUrls = [
    "placeholder_audio_1",
    "placeholder_audio_2",
    "placeholder_audio_3",
    "placeholder_audio_4",
    "placeholder_audio_5",
  ];

  final List<String> availableAudios = [
    "placeholder_audio_1",
    "placeholder_audio_2",
    "placeholder_audio_3",
    "placeholder_audio_4",
    "placeholder_audio_5",
    "placeholder_audio_6",
    "placeholder_audio_7",
    "placeholder_audio_8",
    "placeholder_audio_9",
    "placeholder_audio_10",
  ];

  @override
  void initState() {
    super.initState();
    textController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant SunoContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
      textController.clear();
      enableSubmit.value = false;
      audioCompleted.value = false;
    }
  }

  void _onTextChanged() {
    enableSubmit.value = textController.text.trim().isNotEmpty && audioCompleted.value;
  }

  void _onAudioEnded() {
    audioCompleted.value = true;
    _onTextChanged();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (currentIndex + 1) / totalContributions;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).r,
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8).r,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Image.asset(
              'assets/images/contribute_bg.png',
              fit: BoxFit.cover,
              width: double.infinity,
              color: BrandingConfig.instance.primaryColor,
            ),
            Padding(
              padding: EdgeInsets.all(12).r,
              child: Column(
                children: [
                  _progressHeader(progress: progress, total: totalContributions),
                  SizedBox(height: 24.w),
                  _instructionText(),
                  SizedBox(height: 30.w),
                  CustomAudioPlayer(
                    filePath: mockAudioUrls[currentIndex],
                    onAudioEnded: _onAudioEnded,
                  ),
                  SizedBox(height: 30.w),
                  _textInputField(),
                  SizedBox(height: 30.w),
                  _actionButtons(),
                  SizedBox(height: 50.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressHeader({required int total, required double progress}) =>
      Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                "${currentIndex + 1}/$total",
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 12.sp,
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.w),
          SizedBox(
            height: 4.0,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGreen4,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
            ),
          )
        ],
      );

  Widget _instructionText() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32).r,
        child: Text(
          "Listen to the audio and type what you hear",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 16.sp,
            color: AppColors.greys87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _textInputField() => ValueListenableBuilder<bool>(
        valueListenable: audioCompleted,
        builder: (context, isEnabled, child) => Container(
          padding: EdgeInsets.all(16).r,
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(8).r,
            border: Border.all(color: AppColors.grey16),
          ),
          child: TextField(
            controller: textController,
            enabled: isEnabled,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: isEnabled
                  ? "Type what you hear in the audio..."
                  : "Please listen to the complete audio first...",
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColors.grey16,
                fontSize: 14.sp,
              ),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: isEnabled ? AppColors.greys87 : AppColors.grey16,
            ),
          ),
        ),
      );

  Widget _actionButtons() {
    final bool isSessionComplete = currentIndex >= totalContributions - 1;

    if (isSessionComplete) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _contributeMoreButton(),
          SizedBox(width: 24.w),
          _validateButton(),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _skipButton(),
          SizedBox(width: 24.w),
          _submitButton(),
        ],
      );
    }
  }

  Widget _contributeMoreButton() => SizedBox(
        width: 180.w,
        child: PrimaryButtonWidget(
          title: "Contribute More",
          textFontSize: 16.sp,
          onTap: () {
            widget.indexUpdate(0);
            textController.clear();
            enableSubmit.value = false;
            audioCompleted.value = false;
          },
          textColor: AppColors.orange,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _validateButton() => SizedBox(
        width: 140.w,
        child: PrimaryButtonWidget(
          title: "Validate",
          textFontSize: 16.sp,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SunoValidationScreen(),
              ),
            );
          },
          textColor: AppColors.backgroundColor,
          decoration: BoxDecoration(
            color: AppColors.orange,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _skipButton() => SizedBox(
        width: 120.w,
        child: PrimaryButtonWidget(
          title: AppLocalizations.of(context)!.skip,
          textFontSize: 16.sp,
          onTap: () => _onSkip(),
          textColor: AppColors.orange,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _submitButton() => ValueListenableBuilder<bool>(
        valueListenable: enableSubmit,
        builder: (context, enableSubmitValue, child) => SizedBox(
          width: 120.w,
          child: PrimaryButtonWidget(
            isLoading: submitLoading,
            title: AppLocalizations.of(context)!.submit,
            textFontSize: 16.sp,
            onTap: () => _onSubmit(enableSubmitValue),
            textColor: AppColors.backgroundColor,
            decoration: BoxDecoration(
              color: enableSubmitValue ? AppColors.orange : AppColors.grey16,
              border: Border.all(
                color: enableSubmitValue ? AppColors.orange : AppColors.grey16,
              ),
              borderRadius: BorderRadius.all(Radius.circular(6.0).r),
            ),
          ),
        ),
      );

  void _onSkip() {
    textController.clear();
    enableSubmit.value = false;
    audioCompleted.value = false;
    
    final unusedAudios = availableAudios.where((audio) => !mockAudioUrls.contains(audio)).toList();
    if (unusedAudios.isNotEmpty) {
      mockAudioUrls[currentIndex] = unusedAudios.first;
    }
    
    setState(() {});
    Helper.showSnackBarMessage(
      context: context,
      text: "Audio skipped. Please listen to the new audio.",
    );
  }

  void _onSubmit(bool submitEnabled) async {
    if (!submitEnabled || textController.text.trim().isEmpty) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please enter the text before submitting.",
      );
      return;
    }

    submitLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    submitLoading.value = false;
    textController.clear();
    enableSubmit.value = false;
    audioCompleted.value = false;
    _moveToNext();
    
    Helper.showSnackBarMessage(
      context: context,
      text: "Your contribution submitted successfully",
    );
  }

  void _moveToNext() {
    if (currentIndex < totalContributions - 1) {
      widget.indexUpdate(currentIndex + 1);
    }
  }
}