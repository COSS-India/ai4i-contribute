import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/audio_player/custom_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/branding_config.dart';

class SunoValidateSection extends StatefulWidget {
  final LanguageModel languageModel;
  final VoidCallback onComplete;

  const SunoValidateSection({
    super.key,
    required this.languageModel,
    required this.onComplete,
  });

  @override
  State<SunoValidateSection> createState() => _SunoValidateSectionState();
}

class _SunoValidateSectionState extends State<SunoValidateSection> {
  final TextEditingController textController = TextEditingController();
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);

  int currentIndex = 0;
  final int totalValidations = 25;

  final List<Map<String, String>> mockValidationData = List.generate(
      25,
      (index) => {
            'audioUrl': 'validation_audio_${index + 1}',
            'text':
                'This is sample transcription text for validation ${index + 1}. Please verify if this matches the audio.',
          });

  @override
  void initState() {
    super.initState();
    _loadCurrentValidation();
  }

  void _loadCurrentValidation() {
    textController.text = mockValidationData[currentIndex]['text']!;
    isEditing.value = false;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (currentIndex + 1) / totalValidations;

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
                  _progressHeader(progress: progress, total: totalValidations),
                  SizedBox(height: 24.w),
                  _instructionText(),
                  SizedBox(height: 30.w),
                  _textInputField(),
                  SizedBox(height: 20.w),
                  CustomAudioPlayer(
                    filePath: mockValidationData[currentIndex]['audioUrl']!,
                  ),
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
          "Is the translation correct?",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 16.sp,
            color: AppColors.greys87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _textInputField() => ValueListenableBuilder<bool>(
        valueListenable: isEditing,
        builder: (context, editing, child) => Container(
          padding: EdgeInsets.all(16).r,
          decoration: BoxDecoration(
            color: editing ? Colors.white : Colors.grey[50],
            borderRadius: BorderRadius.circular(8).r,
            border: Border.all(
              color: editing ? AppColors.orange : AppColors.grey16,
              width: editing ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: textController,
            enabled: editing,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: editing
                  ? "Edit the text to match the audio..."
                  : "Text to validate (read-only)",
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColors.grey16,
                fontSize: 14.sp,
              ),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: editing ? AppColors.greys87 : AppColors.grey84,
              fontWeight: editing ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ),
      );

  Widget _actionButtons() {
    final bool isSessionComplete = currentIndex >= totalValidations - 1;

    if (isSessionComplete) {
      return _completeButton();
    } else {
      return ValueListenableBuilder<bool>(
        valueListenable: isEditing,
        builder: (context, editing, child) {
          if (editing) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _cancelButton(),
                SizedBox(width: 24.w),
                _saveButton(),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _skipButton(),
                SizedBox(width: 16.w),
                _needsChangeButton(),
                SizedBox(width: 16.w),
                _correctButton(),
              ],
            );
          }
        },
      );
    }
  }

  Widget _skipButton() => SizedBox(
        width: 80.w,
        child: PrimaryButtonWidget(
          title: "Skip",
          textFontSize: 14.sp,
          onTap: () => _onSkip(),
          textColor: AppColors.grey84,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.grey84),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _needsChangeButton() => SizedBox(
        width: 120.w,
        child: PrimaryButtonWidget(
          title: "Edit",
          textFontSize: 14.sp,
          onTap: () {
            isEditing.value = true;
          },
          textColor: AppColors.orange,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _correctButton() => SizedBox(
        width: 100.w,
        child: PrimaryButtonWidget(
          isLoading: submitLoading,
          title: "Correct",
          textFontSize: 14.sp,
          onTap: () => _onCorrect(),
          textColor: AppColors.backgroundColor,
          decoration: BoxDecoration(
            color: AppColors.orange,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _cancelButton() => SizedBox(
        width: 120.w,
        child: PrimaryButtonWidget(
          title: "Cancel",
          textFontSize: 16.sp,
          onTap: () {
            textController.text = mockValidationData[currentIndex]['text']!;
            isEditing.value = false;
          },
          textColor: AppColors.grey84,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.grey84),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _saveButton() => SizedBox(
        width: 120.w,
        child: PrimaryButtonWidget(
          isLoading: submitLoading,
          title: "Save",
          textFontSize: 16.sp,
          onTap: () => _onSave(),
          textColor: AppColors.backgroundColor,
          decoration: BoxDecoration(
            color: AppColors.orange,
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.all(Radius.circular(6.0).r),
          ),
        ),
      );

  Widget _completeButton() => SizedBox(
        width: 200.w,
        child: PrimaryButtonWidget(
          title: "Complete Validation",
          textFontSize: 16.sp,
          onTap: () {
            widget.onComplete();
            Helper.showSnackBarMessage(
              context: context,
              text: "Validation completed successfully!",
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

  void _onCorrect() async {
    submitLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    submitLoading.value = false;
    _moveToNext();
    Helper.showSnackBarMessage(
      context: context,
      text: "Validation marked as correct",
    );
  }

  void _onSave() async {
    if (textController.text.trim().isEmpty) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please enter some text before saving",
      );
      return;
    }

    submitLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    mockValidationData[currentIndex]['text'] = textController.text;

    submitLoading.value = false;
    isEditing.value = false;
    _moveToNext();
    Helper.showSnackBarMessage(
      context: context,
      text: "Changes saved successfully",
    );
  }

  void _onSkip() {
    _moveToNext();
    Helper.showSnackBarMessage(
      context: context,
      text: "Validation skipped",
    );
  }

  void _moveToNext() {
    if (currentIndex < totalValidations - 1) {
      setState(() {
        currentIndex++;
        _loadCurrentValidation();
      });
    }
  }
}
