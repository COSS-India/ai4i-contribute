import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/screens/suno/suno_validate/suno_validation_screen.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/audio_player/suno_audio_player.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:VoiceGive/common_widgets/audio_player/widgets/audio_player_skeleton.dart';
import '../models/suno_item_model.dart';
import '../service/suno_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../config/branding_config.dart';

typedef IntCallback = void Function(int value);

class SunoContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;

  const SunoContentSection(
      {super.key,
      required this.language,
      required this.indexUpdate,
      required this.currentIndex});

  @override
  State<SunoContentSection> createState() => _SunoContentSectionState();
}

class _SunoContentSectionState extends State<SunoContentSection> {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> audioCompleted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> audioStarted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final TextEditingController textController = TextEditingController();
  bool _hasValidationError = false;

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 5;
  List<SunoItemModel> sunoItems = [];
  final SunoService _sunoService = SunoService();
  int _audioPlayerKey = 0;

  @override
  void initState() {
    super.initState();
    // Reset all state when widget is created
    currentIndex = 0;
    submittedCount = 0;
    totalContributions = 5;
    _resetAudioState();
    textController.addListener(() => _onTextChanged(textController.text));
    _loadSunoData();
  }

  @override
  void didUpdateWidget(covariant SunoContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      currentIndex = 0;
      submittedCount = 0;
      totalContributions = 5;
      _resetAudioState();
      _loadSunoData();
      setState(() {});
    }
    if (currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
      _resetAudioState();
    }
  }

  void _resetAudioState() {
    audioCompleted.value = false;
    audioStarted.value = false;
    textController.clear();
    enableSubmit.value = false;
    _hasValidationError = false;
    _audioPlayerKey++; // Force audio player rebuild
  }

  void _onTextChanged(String value) {
    enableSubmit.value =
        textController.text.trim().isNotEmpty && !_hasValidationError;
  }

  void _onValidationChanged(bool hasError) {
    _hasValidationError = hasError;
    _onTextChanged(textController.text);
  }

  void _onAudioEnded() {
    audioCompleted.value = true;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _loadSunoData() async {
    try {
      isLoading.value = true;
      final response = await _sunoService.getSunoQueue(
        language: widget.language.languageCode,
        batchSize: 5,
      );

      if (response.success && response.data.isNotEmpty) {
        sunoItems = response.data;
        totalContributions = sunoItems.length;
        setState(() {});
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Failed to load audio data: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        if (loading) {
          return ClipRRect(
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
                      _progressHeader(
                          progress: 0.0, total: 5, currentItem: 1),
                      SizedBox(height: 24.w),
                      _instructionText(),
                      SizedBox(height: 30.w),
                      const AudioPlayerSkeleton(),
                      SizedBox(height: 30.w),
                      Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8).r,
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6).r,
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Container(
                            width: 120.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6).r,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.w),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (sunoItems.isEmpty) {
          return Container(
            height: 500.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Center(
              child: Text(
                "No audio data available",
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 16.sp,
                  color: AppColors.greys87,
                ),
              ),
            ),
          );
        }

        final int currentItemNumber = currentIndex + 1;
        final double progress = currentItemNumber / totalContributions;
        return ClipRRect(
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
                    _progressHeader(
                        progress: progress, total: totalContributions, currentItem: currentItemNumber),
                    SizedBox(height: 24.w),
                    _instructionText(),
                    SizedBox(height: 30.w),
                    SunoAudioPlayer(
                      key: ValueKey(
                          '${sunoItems[currentIndex].itemId}_$_audioPlayerKey'),
                      filePath: _sunoService
                          .getFullAudioUrl(sunoItems[currentIndex].audioUrl),
                      onAudioEnded: _onAudioEnded,
                      onAudioStarted: () => audioStarted.value = true,
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
        );
      },
    );
  }

  Widget _progressHeader({required int total, required double progress, required int currentItem}) =>
      Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                "$currentItem/$total",
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
          "Transcribe the provided audio to text.",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGreen,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _textInputField() => ValueListenableBuilder<bool>(
        valueListenable: audioStarted,
        builder: (context, hasStarted, child) {
          final bool isSessionComplete = submittedCount >= totalContributions;
          return UnicodeValidationTextField(
            controller: textController,
            enabled: hasStarted && !isSessionComplete,
            maxLines: 4,
            languageCode: widget.language.languageCode,
            hintText: "Start typing here...",
            onChanged: (value) {
              _onTextChanged(value);
            },
            onValidationChanged: (hasError) {
              _onValidationChanged(hasError);
            },
          );
        },
      );



  Widget _actionButtons() {
    final bool isSessionComplete = submittedCount >= totalContributions;

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
            // Reset all state for new session
            currentIndex = 0;
            submittedCount = 0;
            totalContributions = 5;
            _resetAudioState();
            widget.indexUpdate(0);
            _loadSunoData();
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

  void _onSkip() async {
    _resetAudioState();

    // Load new audio instead of moving to next
    try {
      final response = await _sunoService.getSunoQueue(
        language: widget.language.languageCode,
        batchSize: 1,
      );

      if (response.success && response.data.isNotEmpty) {
        sunoItems[currentIndex] = response.data.first;
        _audioPlayerKey++; // Force audio player rebuild
        setState(() {});

        // Small delay to ensure widget rebuilds properly
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Failed to load new audio: $e",
      );
    }

    Helper.showSnackBarMessage(
      context: context,
      text: "Audio skipped, new audio loaded.",
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

    if (_hasValidationError) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please fix the validation errors before submitting.",
      );
      return;
    }

    submitLoading.value = true;

    try {
      final success = await _sunoService.submitTranscript(
        itemId: sunoItems[currentIndex].itemId,
        language: widget.language.languageCode,
        transcript: textController.text.trim(),
      );

      if (success) {
        submittedCount++;
        Helper.showSnackBarMessage(
          context: context,
          text: "Your contribution submitted successfully",
        );

        if (submittedCount < totalContributions) {
          textController.clear();
          enableSubmit.value = false;
          _hasValidationError = false;
          _moveToNext();
        } else {
          // Session complete, trigger UI update
          setState(() {});
        }
      } else {
        Helper.showSnackBarMessage(
          context: context,
          text: "Failed to submit contribution. Please try again.",
        );
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Error submitting contribution: $e",
      );
    } finally {
      submitLoading.value = false;
    }
  }

  void _moveToNext() {
    if (currentIndex < totalContributions - 1) {
      widget.indexUpdate(currentIndex + 1);
    }
  }
}
