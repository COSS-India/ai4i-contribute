import 'dart:convert';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:VoiceGive/screens/dekho/image_viewer_widget.dart';
import 'package:VoiceGive/screens/dekho/dekho_validation_model.dart';
import 'package:VoiceGive/screens/dekho/dekho_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/branding_config.dart';

typedef IntCallback = void Function(int value);

class DekhoValidationContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;

  const DekhoValidationContentSection({
    super.key,
    required this.language,
    required this.indexUpdate,
    required this.currentIndex,
  });

  @override
  State<DekhoValidationContentSection> createState() =>
      _DekhoValidationContentSectionState();
}

class _DekhoValidationContentSectionState
    extends State<DekhoValidationContentSection> {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(true);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final TextEditingController correctedTextController = TextEditingController();
  bool _hasValidationError = false;
  bool _needsChange = false;

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 25;
  List<DekhoValidationModel> validationItems = [];
  final DekhoService _dekhoService = DekhoService();

  @override
  void initState() {
    super.initState();
    correctedTextController
        .addListener(() => _onTextChanged(correctedTextController.text));
    _loadValidationData();
  }

  @override
  void didUpdateWidget(covariant DekhoValidationContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      currentIndex = 0;
      submittedCount = 0;
      totalContributions = 25;
      validationItems.clear();
      _resetState();
      _loadValidationData();
      setState(() {});
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
      final originalText = validationItems.isNotEmpty
          ? validationItems[currentIndex].label
          : '';
      enableSubmit.value = correctedTextController.text.trim() != originalText.trim() &&
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

  @override
  void dispose() {
    correctedTextController.dispose();
    super.dispose();
  }

  Future<void> _loadValidationData() async {
    try {
      isLoading.value = true;
      final response = await _dekhoService.getValidationQueue(
        batchSize: 25,
      );

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

        final int currentItemNumber = (submittedCount + 1).clamp(1, totalContributions);
        final double progress = currentItemNumber / totalContributions;
        final String currentImageUrl = _dekhoService.getFullImageUrl(validationItems[currentIndex].imageUrl);

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
                    ImageViewerWidget(imageUrl: currentImageUrl),
                    SizedBox(height: 22.w),
                    _textDisplaySection(),
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
                  _progressHeader(progress: 0.0, total: 25, currentItem: 1),
                  SizedBox(height: 24.w),
                  _instructionText(),
                  SizedBox(height: 22.w),
                  Container(
                    height: 135.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12).r,
                    ),
                  ),
                  SizedBox(height: 22.w),
                  Container(
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8).r,
                    ),
                  ),
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
                  SizedBox(height: 50.w),
                ],
              ),
            ),
          ],
        ),
      ),
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
          "Is the text captured from image correctly?",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGreen,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _textDisplaySection() {
    final currentItem = validationItems[currentIndex];
    final labelText = _decodeText(currentItem.label);

    if (_needsChange) {
      return Row(
        children: [
          Expanded(
            child: _buildTextBox(
              text: labelText,
              isEditable: false,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: UnicodeValidationTextField(
              controller: correctedTextController,
              enabled: true,
              maxLines: 4,
              languageCode: widget.language.languageCode,
              hintText: "Start typing here...",
              onChanged: (value) {
                _onTextChanged(value);
              },
              onValidationChanged: (hasError) {
                _onValidationChanged(hasError);
              },
            ),
          ),
        ],
      );
    } else {
      return _buildTextBox(
        text: labelText,
        isEditable: false,
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
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8).r,
          child: TextField(
            controller: TextEditingController(text: text),
            enabled: false,
            maxLines: 4,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: BrandingConfig.instance.getPrimaryTextStyle(
              fontSize: 16.sp,
              color: AppColors.darkGreen,
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
        languageCode: widget.language.languageCode,
        hintText: "Start typing here...",
        onChanged: (value) {
          _onTextChanged(value);
        },
        onValidationChanged: (hasError) {
          _onValidationChanged(hasError);
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
                correctedTextController.text = validationItems[currentIndex].label;
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

    try {
      final response = await _dekhoService.getValidationQueue(
        batchSize: 1,
      );

      if (response.success && response.data.isNotEmpty) {
        validationItems[currentIndex] = response.data.first;
        setState(() {});
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
        text: "Please check the validation first.",
      );
      return;
    }

    if (_needsChange && correctedTextController.text.trim().isEmpty) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please enter the corrected description.",
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
        success = await _dekhoService.submitLabel(
          itemId: validationItems[currentIndex].itemId,
          language: widget.language.languageCode,
          label: correctedTextController.text.trim(),
        );
      } else {
        success = await _dekhoService.submitLabel(
          itemId: validationItems[currentIndex].itemId,
          language: validationItems[currentIndex].language,
          label: validationItems[currentIndex].label,
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
          _moveToNext();
        } else {
          setState(() {});
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

  void _moveToNext() {
    if (currentIndex < totalContributions - 1) {
      widget.indexUpdate(currentIndex + 1);
    }
  }
}