import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/screens/suno/suno_validate/suno_validation_screen.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/audio_player/custom_audio_player.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
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
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final TextEditingController textController = TextEditingController();
  bool _hasValidationError = false;

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 5;
  List<SunoItemModel> sunoItems = [];
  final SunoService _sunoService = SunoService();

  @override
  void initState() {
    super.initState();
    textController.addListener(() => _onTextChanged(textController.text));
    _loadSunoData();
  }

  @override
  void didUpdateWidget(covariant SunoContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      _loadSunoData();
    }
    if (currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
      _resetAudioState();
    }
  }

  void _resetAudioState() {
    audioCompleted.value = false;
    textController.clear();
    enableSubmit.value = false;
    _hasValidationError = false;
  }

  void _onTextChanged(String value) {
    enableSubmit.value = textController.text.trim().isNotEmpty && 
        audioCompleted.value && !_hasValidationError;
  }

  void _onValidationChanged(bool hasError) {
    setState(() {
      _hasValidationError = hasError;
    });
    _onTextChanged(textController.text);
  }

  void _onAudioEnded() {
    audioCompleted.value = true;
    _onTextChanged(textController.text);
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
          return Container(
            height: 400.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.darkGreen),
            ),
          );
        }

        if (sunoItems.isEmpty) {
          return Container(
            height: 400.h,
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

        final double progress = submittedCount / totalContributions;
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
                            progress: progress, total: totalContributions),
                        SizedBox(height: 24.w),
                        _instructionText(),
                        SizedBox(height: 30.w),
                        CustomAudioPlayer(
                          key: ValueKey(sunoItems[currentIndex].itemId),
                          filePath: _sunoService.getFullAudioUrl(
                              sunoItems[currentIndex].audioUrl),
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
            );
      },
    );
  }

  Widget _progressHeader({required int total, required double progress}) =>
      Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Text(
                "$submittedCount/$totalContributions",
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
            fontSize: 16.sp,
            color: AppColors.greys87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _textInputField() => ValueListenableBuilder<bool>(
        valueListenable: audioCompleted,
        builder: (context, isEnabled, child) => UnicodeValidationTextField(
          controller: textController,
          enabled: isEnabled,
          maxLines: 4,
          languageCode: widget.language.languageCode,
          hintText: isEnabled
              ? "Start typing here..."
              : "Please listen to the complete audio first...",
          onChanged: (value) {
            final hasError = _validateUnicodeText(value);
            _onValidationChanged(hasError);
          },
        ),
      );

  bool _validateUnicodeText(String text) {
    if (text.isEmpty) return false;
    
    final ranges = _getLanguageUnicodeRanges(widget.language.languageCode);
    if (ranges == null) return false;

    for (final rune in text.runes) {
      if (!_isValidCharacter(rune, ranges)) {
        return true; // Has error
      }
    }
    return false; // No error
  }

  List<List<int>>? _getLanguageUnicodeRanges(String languageCode) {
    const ranges = {
      'hi': [[0x0900, 0x097F], [0xA8E0, 0xA8FF]],
      'bn': [[0x0980, 0x09FF]],
      'te': [[0x0C00, 0x0C7F]],
      'mr': [[0x0900, 0x097F], [0xA8E0, 0xA8FF]],
      'ta': [[0x0B80, 0x0BFF]],
      'gu': [[0x0A80, 0x0AFF]],
      'kn': [[0x0C80, 0x0CFF]],
      'ml': [[0x0D00, 0x0D7F]],
      'pa': [[0x0A00, 0x0A7F]],
      'or': [[0x0B00, 0x0B7F]],
      'as': [[0x0980, 0x09FF]],
      'ur': [[0x0600, 0x06FF], [0x0750, 0x077F]],
      'en': [[0x0041, 0x005A], [0x0061, 0x007A]],
    };
    return ranges[languageCode];
  }

  bool _isValidCharacter(int codePoint, List<List<int>> ranges) {
    // Allow common characters
    if (codePoint == 0x0020 || // Space
        (codePoint >= 0x0030 && codePoint <= 0x0039) || // Numbers
        codePoint == 0x002E || codePoint == 0x002C || // Period, comma
        codePoint == 0x003F || codePoint == 0x0021) { // Question, exclamation
      return true;
    }

    for (final range in ranges) {
      if (codePoint >= range[0] && codePoint <= range[1]) {
        return true;
      }
    }
    return false;
  }

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
            _loadSunoData();
            widget.indexUpdate(0);
            submittedCount = 0;
            _resetAudioState();
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
        setState(() {});
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
          audioCompleted.value = false;
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
