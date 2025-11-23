import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/branding_config.dart';
import 'likho_validation_model.dart';
import 'likho_service.dart';
import 'likho_congratulations_screen.dart';
import 'likho_validation_content_skeleton.dart';
import 'dart:convert';

typedef IntCallback = void Function(int value);
typedef VoidCallback = void Function();

class LikhoValidationContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;
  final VoidCallback? onComplete;

  const LikhoValidationContentSection({
    super.key,
    required this.language,
    required this.indexUpdate,
    required this.currentIndex,
    this.onComplete,
  });

  @override
  State<LikhoValidationContentSection> createState() =>
      _LikhoValidationContentSectionState();
}

class _LikhoValidationContentSectionState
    extends State<LikhoValidationContentSection> {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final TextEditingController correctedTextController = TextEditingController();
  bool _hasValidationError = false;
  bool _needsChange = false;

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 3;
  List<LikhoValidationModel> validationItems = [];
  int displayIndex = 0;
  final LikhoService _likhoService = LikhoService();

  @override
  void initState() {
    super.initState();
    correctedTextController
        .addListener(() => _onTextChanged(correctedTextController.text));
    _loadValidationData();
  }

  @override
  void didUpdateWidget(covariant LikhoValidationContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      _loadValidationData();
    }
    if (currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
      _resetState();
    }
  }

  void _resetState() {
    correctedTextController.clear();
    enableSubmit.value = true;
    _hasValidationError = false;
    _needsChange = false;
  }

  void _onTextChanged(String value) {
    if (_needsChange) {
      final originalText = validationItems[displayIndex].translation;
      enableSubmit.value =
          correctedTextController.text.trim() != originalText.trim() &&
              correctedTextController.text.trim().isNotEmpty &&
              !_hasValidationError;
    } else {
      enableSubmit.value = true;
    }
  }

  void _onValidationChanged(bool hasError) {
    setState(() {
      _hasValidationError = hasError;
    });
    _onTextChanged(correctedTextController.text);
  }

  Future<void> _loadValidationData() async {
    try {
      isLoading.value = true;
      final response = await _likhoService.getValidationQueue(batchSize: 25);

      if (response.success && response.data.isNotEmpty) {
        validationItems = response.data;
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
  void dispose() {
    correctedTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        if (loading) {
          return _buildLoadingState();
        }

        if (validationItems.isEmpty) {
          return _buildEmptyState();
        }

        final int currentItemNumber = submittedCount + 1;
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
                        progress: progress,
                        total: totalContributions,
                        currentItem: currentItemNumber),
                    SizedBox(height: 24.w),
                    _instructionText(),
                    SizedBox(height: 22.w),
                    _textDisplaySection(),
                    if (_needsChange) ...[
                      SizedBox(height: 22.w),
                      _correctionTextField(),
                    ],
                    SizedBox(height: 22.w),
                    _actionButtons(),
                    SizedBox(height: 20.w),
                    if (submittedCount < totalContributions) _skipButton(),
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

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).r,
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: const LikhoValidationContentSkeleton(),
    );
  }

  Widget _buildEmptyState() {
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

  Widget _textDisplaySection() {
    final currentItem = validationItems[displayIndex];
    final hindiText = _decodeText(currentItem.text);
    final englishText = currentItem.translation;

    if (_needsChange) {
      return Row(
        children: [
          Expanded(
            child: _buildTextBox(
              text: englishText,
              isEditable: false,
              isEnglish: true,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildTextBox(
              text: hindiText,
              isEditable: false,
              isEnglish: false,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildTextBox(
            text: englishText,
            isEditable: false,
            isEnglish: true,
          ),
          SizedBox(height: 16.w),
          _buildTextBox(
            text: hindiText,
            isEditable: false,
            isEnglish: false,
          ),
        ],
      );
    }
  }

  String _decodeText(String text) {
    try {
      final bytes = text.codeUnits;
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return text;
    }
  }

  Widget _buildTextBox({
    required String text,
    required bool isEditable,
    bool isEnglish = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).r,
        color: Colors.white,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGreen4,
          borderRadius: BorderRadius.circular(8).r,
          border: Border.all(
            color: AppColors.darkGreen,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12).r,
          child: TextField(
            controller: TextEditingController(text: text),
            enabled: false,
            maxLines: 4,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: BrandingConfig.instance.getPrimaryTextStyle(
              fontSize: 20.sp,
              color: isEnglish ? Colors.black : AppColors.darkGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _correctionTextField() => UnicodeValidationTextField(
        controller: correctedTextController,
        enabled: true,
        maxLines: 4,
        languageCode: 'en',
        hintText: "Start typing here...",
        onChanged: (value) {
          _onValidationChanged(false);
        },
      );

  Widget _actionButtons() {
    final bool isSessionComplete = submittedCount >= totalContributions;

    if (isSessionComplete) {
      return SizedBox.shrink();
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
              color: _needsChange
                  ? (enableSubmitValue ? AppColors.orange : AppColors.grey16)
                  : AppColors.orange,
              border: Border.all(
                color: _needsChange
                    ? (enableSubmitValue ? AppColors.orange : AppColors.grey16)
                    : AppColors.orange,
              ),
              borderRadius: BorderRadius.all(Radius.circular(6.0).r),
            ),
          ),
        ),
      );

  Widget _needsChangeButton() => SizedBox(
        width: 180.w,
        child: PrimaryButtonWidget(
          title: _needsChange ? "Cancel" : "Needs Changes",
          textFontSize: 16.sp,
          onTap: () {
            if (!_needsChange) {
              setState(() {
                _needsChange = true;
                correctedTextController.clear();
              });
              _onTextChanged(correctedTextController.text);
            } else {
              setState(() {
                _needsChange = false;
                correctedTextController.clear();
              });
              _onTextChanged(correctedTextController.text);
            }
          },
          textColor: AppColors.orange,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
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

  void _onSkip() async {
    correctedTextController.clear();
    enableSubmit.value = true;
    _hasValidationError = false;
    _needsChange = false;

    displayIndex = (displayIndex + 1) % validationItems.length;

    if (displayIndex == 0 && validationItems.length < 50) {
      await _loadMoreValidationItems();
    }

    setState(() {});

    Helper.showSnackBarMessage(
      context: context,
      text: "Item skipped, new item loaded.",
    );
  }

  void _onSubmit(bool submitEnabled, bool isCorrect) async {
    if (_needsChange && correctedTextController.text.trim().isEmpty) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please enter the corrected translation.",
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
      bool success = false;

      if (_needsChange) {
        success = await _likhoService.submitValidationCorrection(
          itemId: validationItems[displayIndex].itemId,
          correctedTranslation: correctedTextController.text.trim(),
        );
      } else {
        success = await _likhoService.submitValidationCorrect(
          itemId: validationItems[displayIndex].itemId,
        );
      }

      if (success) {
        submittedCount++;
        Helper.showSnackBarMessage(
          context: context,
          text: "Validation submitted successfully",
        );

        if (submittedCount < totalContributions) {
          correctedTextController.clear();
          enableSubmit.value = true;
          _hasValidationError = false;
          _needsChange = false;
          displayIndex = (displayIndex + 1) % validationItems.length;
          if (displayIndex == 0 && validationItems.length < 50) {
            await _loadMoreValidationItems();
          }
          setState(() {});
        } else {
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
          
          await Future.delayed(const Duration(seconds: 2));
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LikhoCongratulationsScreen(),
            ),
          );
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

  Future<void> _loadMoreValidationItems() async {
    try {
      final response = await _likhoService.getValidationQueue(batchSize: 25);

      if (response.success && response.data.isNotEmpty) {
        validationItems.addAll(response.data);
      }
    } catch (e) {
      print('Error loading more validation items: $e');
    }
  }
}
