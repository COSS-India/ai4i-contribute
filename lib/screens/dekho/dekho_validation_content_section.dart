import 'dart:convert';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:VoiceGive/screens/dekho/image_viewer_widget.dart';
import 'package:VoiceGive/screens/dekho/dekho_validation_model.dart';
import 'package:VoiceGive/screens/dekho/dekho_service.dart';
import 'package:VoiceGive/screens/dekho/dekho_validation_constants.dart';
import 'package:VoiceGive/screens/dekho/dekho_congratulations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/branding_config.dart';

typedef IntCallback = void Function(int value);
typedef VoidCallback = void Function();

class DekhoValidationContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;
  final VoidCallback? onComplete;

  const DekhoValidationContentSection({
    super.key,
    required this.language,
    required this.indexUpdate,
    required this.currentIndex,
    this.onComplete,
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
  int totalContributions = DekhoValidationConstants.totalValidationItems;
  List<DekhoValidationModel> validationItems = [];
  final DekhoService _dekhoService = DekhoService();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Helper.showSnackBarMessage(
      context: context,
      text: message,
    );
  }

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
      totalContributions = DekhoValidationConstants.totalValidationItems;
      validationItems.clear();
      _resetState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.indexUpdate(0);
        }
      });
      _loadValidationData();
      if (mounted) {
        setState(() {});
      }
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
      final originalText =
          validationItems.isNotEmpty ? validationItems[currentIndex].label : '';
      enableSubmit.value =
          correctedTextController.text.trim() != originalText.trim() &&
              correctedTextController.text.trim().isNotEmpty &&
              !_hasValidationError;
    } else {
      enableSubmit.value = true;
    }
  }

  void _onValidationChanged(bool hasError) {
    if (mounted) {
      setState(() {
        _hasValidationError = hasError;
      });
    }
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
        batchSize: DekhoValidationConstants.totalValidationItems,
      );

      if (response.success && response.data.isNotEmpty) {
        validationItems = [];
        final apiData = response.data;

        // Loop the API response to reach totalValidationItems
        for (int i = 0;
            i < DekhoValidationConstants.totalValidationItems;
            i++) {
          validationItems.add(apiData[i % apiData.length]);
        }

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar("Failed to load validation data: $e");
      }
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

        final int currentItemNumber =
            (submittedCount + 1).clamp(1, totalContributions);
        final double progress = currentItemNumber / totalContributions;
        final String currentImageUrl = currentIndex < validationItems.length
            ? _dekhoService
                .getFullImageUrl(validationItems[currentIndex].imageUrl)
            : '';

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
                  _progressHeader(
                      progress: 0.0,
                      total: DekhoValidationConstants.totalValidationItems,
                      currentItem: 1),
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
    if (currentIndex >= validationItems.length) return SizedBox.shrink();
    final currentItem = validationItems[currentIndex];
    final labelText = _decodeText(currentItem.label);

    if (_needsChange) {
      return Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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

  bool _validateText(String text) {
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

  String _decodeText(String text) {
    try {
      // Check if text contains Unicode escape sequences
      if (text.contains('\\u')) {
        return text.replaceAllMapped(
          RegExp(r'\\u([0-9a-fA-F]{4})'),
          (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
        );
      }
      // If text contains Latin-1 encoded UTF-8, decode it
      if (text.runes.any((rune) => rune > 127 && rune < 256)) {
        final bytes = text.codeUnits.map((unit) => unit & 0xFF).toList();
        return utf8.decode(bytes, allowMalformed: true);
      }
      // Return text as-is if it's already properly encoded
      return text;
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
              if (mounted) {
                setState(() {
                  _needsChange = true;
                  correctedTextController.text =
                      currentIndex < validationItems.length
                          ? _decodeText(validationItems[currentIndex].label)
                          : '';
                });
              }
              _onTextChanged(correctedTextController.text);
            } else {
              if (mounted) {
                setState(() {
                  _needsChange = false;
                  correctedTextController.clear();
                });
              }
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
    _resetState();

    _moveToNext();
    
    _showSnackBar("Item skipped.");
  }

  void _onSubmit(bool submitEnabled, bool isCorrect) async {
    if (!submitEnabled) {
      _showSnackBar("Please check the validation first.");
      return;
    }

    if (_needsChange && correctedTextController.text.trim().isEmpty) {
      _showSnackBar("Please enter the corrected description.");
      return;
    }

    if (_hasValidationError) {
      _showSnackBar("Please fix the validation errors before submitting.");
      return;
    }

    submitLoading.value = true;

    try {
      bool success;

      if (currentIndex >= validationItems.length) {
        print('DEBUG: No validation item available at index $currentIndex');
        _showSnackBar("No validation item available.");
        return;
      }

      print(
          'DEBUG: Submitting validation for item ${validationItems[currentIndex].itemId}');
      print('DEBUG: Needs change: $_needsChange');

      if (_needsChange) {
        print(
            'DEBUG: Submitting corrected label: ${correctedTextController.text.trim()}');
        success = await _dekhoService.submitValidationCorrection(
          itemId: validationItems[currentIndex].itemId,
          correctedLabel: correctedTextController.text.trim(),
        );
      } else {
        print('DEBUG: Submitting validation decision: correct');
        success = await _dekhoService.submitValidationDecision(
          itemId: validationItems[currentIndex].itemId,
          decision: 'correct',
        );
      }

      print('DEBUG: Submit validation result: $success');

      if (success) {
        submittedCount++;
        _showSnackBar("Validation submitted successfully");

        if (submittedCount < totalContributions) {
          correctedTextController.clear();
          enableSubmit.value = true;
          _hasValidationError = false;
          _needsChange = false;
          _moveToNext();
        } else {
          if (widget.onComplete != null) {
            widget.onComplete!();
          }

          await Future.delayed(const Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DekhoCongratulationsScreen(),
            ),
          );
        }
      } else {
        print('DEBUG: Submit validation failed');
        _showSnackBar("Failed to submit validation. Please try again.");
      }
    } catch (e) {
      print('DEBUG: Exception during submit validation: $e');
      _showSnackBar("Error submitting validation: $e");
    } finally {
      submitLoading.value = false;
    }
  }

  void _moveToNext() {
    if (validationItems.isNotEmpty) {
      final nextIndex = (currentIndex + 1) % validationItems.length;
      widget.indexUpdate(nextIndex);
    }
  }
}
