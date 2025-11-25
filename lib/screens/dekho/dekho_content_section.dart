import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:VoiceGive/screens/dekho/image_viewer_widget.dart';
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
  final TextEditingController textController = TextEditingController();
  bool _hasValidationError = false;

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 5;
  
  // Mock image URLs for demonstration
  List<String> imageUrls = [
    'https://picsum.photos/400/300?random=1',
    'https://picsum.photos/400/300?random=2',
    'https://picsum.photos/400/300?random=3',
    'https://picsum.photos/400/300?random=4',
    'https://picsum.photos/400/300?random=5',
  ];

  @override
  void initState() {
    super.initState();
    textController.addListener(() => _onTextChanged(textController.text));
  }

  @override
  void didUpdateWidget(covariant DekhoContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLanguage.languageCode != widget.selectedLanguage.languageCode) {
      currentIndex = 0;
      submittedCount = 0;
      totalContributions = 5;
      textController.clear();
      enableSubmit.value = false;
      _hasValidationError = false;
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
  }

  void _onTextChanged(String value) {
    enableSubmit.value = textController.text.trim().isNotEmpty && !_hasValidationError;
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
    final int currentItemNumber = currentIndex + 1;
    final double progress = currentItemNumber / totalContributions;
    final String currentImageUrl = imageUrls[currentIndex % imageUrls.length];

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
                  fontSize: 16.sp,
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
            _resetState();
            setState(() {});
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
            Helper.showSnackBarMessage(
              context: context,
              text: "Validation feature coming soon!",
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

    currentIndex = (currentIndex + 1) % totalContributions;
    setState(() {});

    Helper.showSnackBarMessage(
      context: context,
      text: "Image skipped. Please type text from the new image.",
    );
  }

  void _onSubmit(bool submitEnabled) async {
    if (!submitEnabled || textController.text.trim().isEmpty) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Please enter text before submitting.",
      );
      return;
    }

    submitLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      submittedCount++;
      Helper.showSnackBarMessage(
        context: context,
        text: "Your text submitted successfully",
      );

      if (submittedCount < totalContributions) {
        textController.clear();
        enableSubmit.value = false;
        currentIndex++;
        widget.indexUpdate(currentIndex);
      } else {
        setState(() {});
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Error submitting text: $e",
      );
    } finally {
      submitLoading.value = false;
    }
  }
}