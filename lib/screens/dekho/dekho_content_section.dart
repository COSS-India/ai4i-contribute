import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:VoiceGive/screens/dekho/image_viewer_widget.dart';
import 'package:VoiceGive/screens/dekho/dekho_item_model.dart';
import 'package:VoiceGive/screens/dekho/dekho_service.dart';
import 'package:VoiceGive/screens/dekho/dekho_validation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/branding_config.dart';

typedef IntCallback = void Function(int value);

class DekhoContentSection extends StatefulWidget {
  final LanguageModel selectedLanguage;
  final IntCallback indexUpdate;
  final int currentIndex;

  const DekhoContentSection({
    super.key,
    required this.selectedLanguage,
    required this.indexUpdate,
    required this.currentIndex,
  });

  @override
  State<DekhoContentSection> createState() => _DekhoContentSectionState();
}

class _DekhoContentSectionState extends State<DekhoContentSection> {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final TextEditingController textController = TextEditingController();
  bool _hasValidationError = false;

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 5;
  List<DekhoItemModel> dekhoItems = [];
  int displayIndex = 0;
  final DekhoService _dekhoService = DekhoService();

  @override
  void initState() {
    super.initState();
    textController.addListener(() => _onTextChanged(textController.text));
    _loadDekhoData();
  }

  @override
  void didUpdateWidget(covariant DekhoContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLanguage.languageCode !=
        widget.selectedLanguage.languageCode) {
      currentIndex = 0;
      submittedCount = 0;
      displayIndex = 0;
      totalContributions = 5;
      textController.clear();
      enableSubmit.value = false;
      _hasValidationError = false;
      _loadDekhoData();
      setState(() {});
    }
    if (currentIndex != widget.currentIndex) {
      currentIndex = widget.currentIndex;
    }
  }

  void _resetState() {
    textController.clear();
    enableSubmit.value = false;
    submittedCount = 0;
    currentIndex = 0;
    displayIndex = 0;
  }

  Future<void> _loadDekhoData() async {
    try {
      isLoading.value = true;
      final response = await _dekhoService.getDekhoQueue(
        language: widget.selectedLanguage.languageCode,
        batchSize: 5,
      );

      if (response.success && response.data.isNotEmpty) {
        dekhoItems = response.data;
        totalContributions = dekhoItems.length;
        setState(() {});
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Failed to load image data: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _onTextChanged(String value) {
    enableSubmit.value =
        textController.text.trim().isNotEmpty && !_hasValidationError;
  }

  void _onValidationChanged(bool hasError) {
    _hasValidationError = hasError;
    _onTextChanged(textController.text);
  }

  @override
  void dispose() {
    textController.dispose();
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

        if (dekhoItems.isEmpty) {
          return _buildEmptyState();
        }

        final int currentItemNumber =
            (submittedCount + 1).clamp(1, totalContributions);
        final double progress = submittedCount / totalContributions;
        final String currentImageUrl =
            _dekhoService.getFullImageUrl(dekhoItems[displayIndex].imageUrl);
        print('DEBUG: Image URL: $currentImageUrl');

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8).r,
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8).r,
            child: Padding(
              padding: EdgeInsets.all(12).r,
              child: Column(
                children: [
                  _progressHeader(
                    progress: progress,
                    total: totalContributions,
                    currentItem: currentItemNumber,
                  ),
                  SizedBox(height: 24.w),
                  Text(
                    "Type the text from the image",
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 12.sp,
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.w),
                  ImageViewerWidget(imageUrl: currentImageUrl),
                  SizedBox(height: 16.w),
                  _textInputField(),
                  SizedBox(height: 30.w),
                  _actionButtons(),
                  SizedBox(height: 50.w),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).r,
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.darkGreen,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).r,
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Center(
        child: Text(
          "No image data available",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 16.sp,
            color: AppColors.greys87,
          ),
        ),
      ),
    );
  }

  Widget _progressHeader({
    required int total,
    required double progress,
    required int currentItem,
  }) =>
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

  Widget _textInputField() {
    final bool isSessionComplete = submittedCount >= totalContributions;
    return UnicodeValidationTextField(
      controller: textController,
      enabled: !isSessionComplete,
      maxLines: 4,
      languageCode: widget.selectedLanguage.languageCode,
      hintText: "Start typing here...",
      onChanged: (value) {
        _onTextChanged(value);
      },
      onValidationChanged: (hasError) {
        _onValidationChanged(hasError);
      },
    );
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
            _loadDekhoData();
            widget.indexUpdate(0);
            submittedCount = 0;
            _resetState();
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
                builder: (context) => DekhoValidationScreen(),
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
    textController.clear();
    enableSubmit.value = false;
    _hasValidationError = false;

    displayIndex = (displayIndex + 1) % dekhoItems.length;
    setState(() {});

    Helper.showSnackBarMessage(
      context: context,
      text: "Image skipped.",
    );
  }

  void _onSubmit(bool submitEnabled) async {
    if (!submitEnabled || textController.text.trim().isEmpty) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please enter description before submitting.",
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
      final success = await _dekhoService.submitLabel(
        itemId: dekhoItems[displayIndex].itemId,
        language: widget.selectedLanguage.languageCode,
        label: textController.text.trim(),
      );

      if (success) {
        submittedCount++;
        Helper.showSnackBarMessage(
          context: context,
          text: "Your Contribution Submitted Successfully",
        );

        if (submittedCount < totalContributions) {
          textController.clear();
          enableSubmit.value = false;
          _hasValidationError = false;
          currentIndex++;
          displayIndex = currentIndex;
          widget.indexUpdate(currentIndex);
        } else {
          setState(() {});
        }
      } else {
        Helper.showSnackBarMessage(
          context: context,
          text: "Failed to submit description. Please try again.",
        );
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Error submitting description: $e",
      );
    } finally {
      submitLoading.value = false;
    }
  }

  void _moveToNext() {
    if (dekhoItems.isNotEmpty) {
      final nextIndex = (currentIndex + 1) % dekhoItems.length;
      widget.indexUpdate(nextIndex);
    }
  }
}
