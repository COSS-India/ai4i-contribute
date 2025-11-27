import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/audio_player/custom_audio_player.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:VoiceGive/screens/suno/suno_congratulations_screen.dart';
import '../../../common_widgets/audio_player/suno_validation_audio_player.dart';
import '../../../common_widgets/audio_player/widgets/validation_audio_player_skeleton.dart';
import '../models/suno_validation_model.dart';
import '../service/suno_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../../../config/branding_config.dart';
import 'package:just_audio/just_audio.dart';

typedef IntCallback = void Function(int value);
typedef VoidCallback = void Function();

class SunoValidationContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;
  final VoidCallback? onComplete;
  final VoidCallback? onBackPressed;

  const SunoValidationContentSection({
    super.key,
    required this.language,
    required this.indexUpdate,
    required this.currentIndex,
    this.onComplete,
    this.onBackPressed,
  });

  @override
  State<SunoValidationContentSection> createState() =>
      _SunoValidationContentSectionState();
}

class _SunoValidationContentSectionState
    extends State<SunoValidationContentSection> with TickerProviderStateMixin {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> audioCompleted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final TextEditingController correctedTextController = TextEditingController();
  bool _hasValidationError = false;
  bool _needsChange = false;
  bool _showConfetti = false;
  late AnimationController _confettiController;

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 25;
  int currentBatchIndex = 0;
  int batchSize = 5;
  List<SunoValidationModel> validationItems = [];
  final SunoService _sunoService = SunoService();
  int _audioPlayerKey = 0;
  bool _isPlaying = false;
  bool _hasEnded = false;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _confettiController = AnimationController(vsync: this);
    correctedTextController
        .addListener(() => _onTextChanged(correctedTextController.text));
    _loadValidationData();
  }

  @override
  void didUpdateWidget(covariant SunoValidationContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      currentIndex = 0;
      submittedCount = 0;
      currentBatchIndex = 0;
      totalContributions = 25;
      validationItems.clear();
      _resetAudioState();
      _loadValidationData();
      setState(() {});
    }
    if (currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
      currentBatchIndex = widget.currentIndex;
      _resetAudioState();
    }
  }

  void _resetAudioState() {
    audioCompleted.value = false;
    correctedTextController.clear();
    enableSubmit.value = false;
    _hasValidationError = false;
    _needsChange = false;
    _audioPlayerKey++; // Force audio player rebuild
    _player.stop();
    setState(() {
      _isPlaying = false;
      _hasEnded = false;
    });
    _setupPlayerListeners();
  }

  void _onTextChanged(String value) {
    if (_needsChange) {
      // When needs change is active, only enable if text is different from original and valid
      final originalText = validationItems.isNotEmpty
          ? validationItems[currentBatchIndex].transcript
          : '';
      enableSubmit.value = audioCompleted.value &&
          correctedTextController.text.trim() != originalText.trim() &&
          correctedTextController.text.trim().isNotEmpty &&
          !_hasValidationError;
    } else {
      enableSubmit.value = audioCompleted.value;
    }
  }

  void _onValidationChanged(bool hasError) {
    setState(() {
      _hasValidationError = hasError;
    });
    _onTextChanged(correctedTextController.text);
  }

  void _onAudioEnded() {
    audioCompleted.value = true;
    setState(() {
      _hasEnded = true;
      _isPlaying = false;
    });
    _onTextChanged(correctedTextController.text);
  }

  @override
  void dispose() {
    _player.dispose();
    _confettiController.dispose();
    correctedTextController.dispose();
    super.dispose();
  }

  void _setupPlayerListeners() {
    _player.playerStateStream.listen((state) {
      if (mounted) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _hasEnded = true;
          });
          _onAudioEnded();
        } else {
          setState(() {
            _isPlaying = state.playing;
            if (state.playing) {
              _hasEnded = false;
            }
          });
        }
      }
    });
  }

  Future<void> _loadValidationData() async {
    try {
      isLoading.value = true;
      final response = await _sunoService.getValidationQueue(batchSize: 25);

      if (response.success && response.data.isNotEmpty) {
        validationItems = response.data;
        _setupPlayerListeners();
        setState(() {});
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Failed to load validation data: $e",
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8).r,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  // Image.asset(
                  //   'assets/images/contribute_bg.png',
                  //   fit: BoxFit.cover,
                  //   width: double.infinity,
                  //   color: BrandingConfig.instance.primaryColor,
                  // ),
                  Padding(
                    padding: EdgeInsets.all(12).r,
                    child: Column(
                      children: [
                        _progressHeader(
                            progress: 0.0, total: 3, currentItem: 1),
                        SizedBox(height: 24.w),
                        _instructionText(),
                        SizedBox(height: 22.w),
                        const ValidationAudioPlayerSkeleton(),
                        SizedBox(height: 22.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 180.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6).r,
                              ),
                            ),
                            SizedBox(width: 24.w),
                            Container(
                              width: 140.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6).r,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.w),
                        Container(
                          width: 120.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(6).r,
                          ),
                        ),
                        SizedBox(height: 50.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (validationItems.isEmpty) {
          return Container(
            height: 400.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Center(
              child: Text(
                "No validation data available",
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 16.sp,
                  color: AppColors.greys87,
                ),
              ),
            ),
          );
        }

        final int currentItemNumber =
            (submittedCount + 1).clamp(1, totalContributions);
        final double progress = currentItemNumber / totalContributions;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8).r,
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8).r,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    // Image.asset(
                    //   'assets/images/contribute_bg.png',
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    //   color: BrandingConfig.instance.primaryColor,
                    // ),
                    Padding(
                      padding: EdgeInsets.all(12).r,
                      child: Column(
                        children: [
                          _progressHeader(
                              progress: progress,
                              total: totalContributions,
                              currentItem: currentItemNumber),
                          SizedBox(height: 24.w),
                          _instructionText(),
                          SizedBox(height: 22.w),
                          SunoValidationAudioPlayer(
                            key: ValueKey(
                                '${validationItems[currentBatchIndex].itemId}_$_audioPlayerKey'),
                            filePath: _sunoService.getFullAudioUrl(
                                validationItems[currentBatchIndex].audioUrl),
                            onAudioEnded: _onAudioEnded,
                            originalText:
                                validationItems[currentBatchIndex].transcript,
                            correctedTextController: correctedTextController,
                            languageCode: widget.language.languageCode,
                            needsChange: _needsChange,
                            audioCompleted: audioCompleted.value,
                            onTextChanged: (value) {
                              final hasError = _validateUnicodeText(value);
                              _onValidationChanged(hasError);
                            },
                          ),
                          SizedBox(height: 22.w),
                          _actionButtons(),
                          SizedBox(height: 20.w),
                          if (submittedCount < totalContributions)
                            _skipButton(),
                          SizedBox(height: 50.w),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_showConfetti)
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/animations/confetti.json',
                    controller: _confettiController,
                    fit: BoxFit.fill,
                    onLoaded: (composition) {
                      _confettiController.duration = composition.duration;
                      _confettiController.forward().then((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SunoCongratulationsScreen(),
                          ),
                        );
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _progressHeader(
          {required int total,
          required double progress,
          required int currentItem}) =>
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
          "Is the translation correct?",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGreen,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );

  bool _validateUnicodeText(String text) {
    if (text.isEmpty) return false;

    final ranges = _getLanguageUnicodeRanges(widget.language.languageCode);
    if (ranges == null) return false;

    for (final rune in text.runes) {
      if (!_isValidCharacter(rune, ranges)) {
        return true;
      }
    }
    return false;
  }

  List<List<int>>? _getLanguageUnicodeRanges(String languageCode) {
    const ranges = {
      'hi': [
        [0x0900, 0x097F],
        [0xA8E0, 0xA8FF]
      ],
      'bn': [
        [0x0980, 0x09FF]
      ],
      'te': [
        [0x0C00, 0x0C7F]
      ],
      'mr': [
        [0x0900, 0x097F],
        [0xA8E0, 0xA8FF]
      ],
      'ta': [
        [0x0B80, 0x0BFF]
      ],
      'gu': [
        [0x0A80, 0x0AFF]
      ],
      'kn': [
        [0x0C80, 0x0CFF]
      ],
      'ml': [
        [0x0D00, 0x0D7F]
      ],
      'pa': [
        [0x0A00, 0x0A7F]
      ],
      'or': [
        [0x0B00, 0x0B7F]
      ],
      'as': [
        [0x0980, 0x09FF]
      ],
      'ur': [
        [0x0600, 0x06FF],
        [0x0750, 0x077F]
      ],
      'en': [
        [0x0041, 0x005A],
        [0x0061, 0x007A]
      ],
    };
    return ranges[languageCode];
  }

  bool _isValidCharacter(int codePoint, List<List<int>> ranges) {
    if (codePoint == 0x0020 ||
        (codePoint >= 0x0030 && codePoint <= 0x0039) ||
        codePoint == 0x002E ||
        codePoint == 0x002C ||
        codePoint == 0x003F ||
        codePoint == 0x0021) {
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
      return SizedBox
          .shrink(); // Hide buttons when complete, confetti will show
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _needsChangeButton(),
          SizedBox(width: 24.w),
          _correctButton(),
        ],
      );
    }
  }

  Widget _correctButton() => ValueListenableBuilder<bool>(
        valueListenable: enableSubmit,
        builder: (context, enableSubmitValue, child) => SizedBox(
          width: 140.w,
          child: PrimaryButtonWidget(
            isLoading: submitLoading,
            title: _needsChange ? "Submit" : "Correct",
            textFontSize: 16.sp,
            onTap: () => _onSubmit(enableSubmitValue, true),
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

  Widget _needsChangeButton() => ValueListenableBuilder<bool>(
        valueListenable: audioCompleted,
        builder: (context, isAudioCompleted, child) => SizedBox(
          width: 180.w,
          child: PrimaryButtonWidget(
            title: _needsChange ? "Cancel" : "Needs Changes",
            textFontSize: 16.sp,
            onTap: isAudioCompleted
                ? () {
                    if (!_needsChange) {
                      setState(() {
                        _needsChange = true;
                        correctedTextController.text =
                            validationItems[currentBatchIndex].transcript;
                      });
                      _onTextChanged(correctedTextController.text);
                    } else {
                      setState(() {
                        _needsChange = false;
                        correctedTextController.clear();
                      });
                      _onTextChanged(correctedTextController.text);
                    }
                  }
                : null,
            textColor: isAudioCompleted ? AppColors.orange : AppColors.grey16,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              border: Border.all(
                color: isAudioCompleted ? AppColors.orange : AppColors.grey16,
              ),
              borderRadius: BorderRadius.all(Radius.circular(6.0).r),
            ),
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

  Widget _validateMoreButton() => SizedBox(
        width: 180.w,
        child: PrimaryButtonWidget(
          title: "Validate More",
          textFontSize: 16.sp,
          onTap: () {
            _loadValidationData();
            widget.indexUpdate(0);
            submittedCount = 0;
            currentBatchIndex = 0;
            validationItems.clear();
            _loadValidationData();
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

  void _onSkip() async {
    _resetAudioState();

    try {
      final response = await _sunoService.getValidationQueue(batchSize: 1);

      if (response.success && response.data.isNotEmpty) {
        validationItems[currentBatchIndex] = response.data.first;
        setState(() {});

        // Small delay to ensure widget rebuilds properly
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Failed to load new validation item: $e",
      );
    }

    Helper.showSnackBarMessage(
      context: context,
      text: "Item skipped, new item loaded.",
    );
  }

  void _onSubmit(bool submitEnabled, bool isCorrect) async {
    if (!submitEnabled) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please listen to the audio first.",
      );
      return;
    }

    if (_needsChange && correctedTextController.text.trim().isEmpty) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please enter the corrected transcript.",
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
      bool success;

      if (_needsChange) {
        // Submit corrected transcript
        success = await _sunoService.submitTranscript(
          itemId: validationItems[currentBatchIndex].itemId,
          language: widget.language.languageCode,
          transcript: correctedTextController.text.trim(),
        );
      } else {
        // Submit validation decision as correct
        success = await _sunoService.submitValidationDecision(
          itemId: validationItems[currentBatchIndex].itemId,
          decision: "correct",
        );
      }

      if (success) {
        submittedCount++;
        Helper.showSnackBarMessage(
          context: context,
          text: "Validation submitted successfully",
        );

        if (submittedCount < totalContributions) {
          audioCompleted.value = false;
          correctedTextController.clear();
          enableSubmit.value = false;
          _hasValidationError = false;
          _needsChange = false;
          await _moveToNext();
        } else {
          setState(() {
            _showConfetti = true;
          });
        }
      } else {
        Helper.showSnackBarMessage(
          context: context,
          text: "Failed to submit validation. Please try again.",
        );
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Error submitting validation: $e",
      );
    } finally {
      submitLoading.value = false;
    }
  }

  Future<void> _moveToNext() async {
    currentBatchIndex++;

    // Check if we need to load next batch
    if (currentBatchIndex >= validationItems.length) {
      try {
        final response = await _sunoService.getValidationQueue(batchSize: 5);
        if (response.success && response.data.isNotEmpty) {
          validationItems.addAll(response.data);
          setState(() {});
        }
      } catch (e) {
        Helper.showSnackBarMessage(
          context: context,
          text: "Failed to load next batch: $e",
        );
      }
    }

    if (currentBatchIndex < validationItems.length) {
      widget.indexUpdate(currentBatchIndex);
    }
  }

  Future<void> _handlePlayPause() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        if (_hasEnded) {
          await _player.seek(Duration.zero);
          setState(() {
            _hasEnded = false;
          });
        }
        await _player.setUrl(_sunoService
            .getFullAudioUrl(validationItems[currentBatchIndex].audioUrl));
        await _player.play();
      }
    } catch (e) {
      debugPrint('Error in play/pause: $e');
    }
  }

  Future<void> _handleReplay() async {
    try {
      await _player.seek(Duration.zero);
      setState(() {
        _hasEnded = false;
      });
      await _player.play();
    } catch (e) {
      debugPrint('Error in replay: $e');
    }
  }

  Widget _buildPlayButton() {
    if (_hasEnded) {
      return IconButton(
        icon: Icon(
          Icons.replay_circle_filled_outlined,
          size: 60,
          color: AppColors.green,
        ),
        onPressed: _handleReplay,
        tooltip: 'Replay',
      );
    } else {
      return IconButton(
        icon: Icon(
          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
          size: 60,
          color: AppColors.green,
        ),
        onPressed: _handlePlayPause,
        tooltip: _isPlaying ? 'Pause' : 'Play',
      );
    }
  }
}
