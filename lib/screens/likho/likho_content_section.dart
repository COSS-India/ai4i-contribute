import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/branding_config.dart';
import 'likho_item_model.dart';
import 'likho_service.dart';
import 'likho_content_skeleton.dart';
import 'likho_validation_screen.dart';
import 'dart:convert';

typedef IntCallback = void Function(int value);

class LikhoContentSection extends StatefulWidget {
  final LanguageModel language;
  final IntCallback indexUpdate;
  final int currentIndex;

  const LikhoContentSection(
      {super.key,
      required this.language,
      required this.indexUpdate,
      required this.currentIndex});

  @override
  State<LikhoContentSection> createState() => _LikhoContentSectionState();
}

class _LikhoContentSectionState extends State<LikhoContentSection> {
  final ValueNotifier<bool> enableSubmit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> submitLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final TextEditingController textController = TextEditingController();
  final LikhoService _likhoService = LikhoService();

  int currentIndex = 0;
  int submittedCount = 0;
  int totalContributions = 5;
  List<LikhoItemModel> likhoItems = [];
  int displayIndex = 0;

  @override
  void initState() {
    super.initState();
    textController.addListener(() => _onTextChanged(textController.text));
    _loadLikhoData();
  }

  @override
  void didUpdateWidget(covariant LikhoContentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language.languageCode != widget.language.languageCode) {
      _loadLikhoData();
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

  Future<void> _loadLikhoData() async {
    try {
      isLoading.value = true;
      final response = await _likhoService.getLikhoQueue(
        srcLanguage: widget.language.languageCode,
        batchSize: 5,
      );

      if (response.success && response.data.isNotEmpty) {
        likhoItems = response.data;
        totalContributions = likhoItems.length;
        setState(() {});
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Failed to load translation data: $e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _onTextChanged(String value) {
    enableSubmit.value = textController.text.trim().isNotEmpty;
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

        if (likhoItems.isEmpty) {
          return _buildEmptyState();
        }

        final int currentItemNumber = currentIndex + 1;
        final double progress = currentItemNumber / totalContributions;
        // Ensure proper UTF-8 text display
        final String currentSentence = _decodeText(likhoItems[displayIndex].text);
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8).r,
            border: Border.all(
              color: Colors.grey[700]!,
            ),
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
                          progress: progress, total: totalContributions, currentItem: currentItemNumber),
                      SizedBox(height: 24.w),
                      _sentenceText(currentSentence),
                      SizedBox(height: 16.w),
                      _instructionText(),
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

  Widget _sentenceText(String text) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32).r,
        child: Text(
          text,
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 16.sp,
            color: AppColors.greys87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _instructionText() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32).r,
        child: Text(
          "Type the translation of given text",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 14.sp,
            color: AppColors.darkGreen,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Widget _textInputField() {
    final bool isSessionComplete = submittedCount >= totalContributions;
    return UnicodeValidationTextField(
      controller: textController,
      enabled: !isSessionComplete,
      maxLines: 4,
      languageCode: 'en', // Users translate TO English
      hintText: "Start typing here...",
      onChanged: (value) {
        // UnicodeValidationTextField handles its own validation and error display
        _onTextChanged(value);
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

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).r,
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: const LikhoContentSkeleton(),
    );
  }

  String _decodeText(String text) {
    try {
      // Handle potential encoding issues
      final bytes = text.codeUnits;
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      // If decoding fails, return original text
      return text;
    }
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
          "No translation data available",
          style: BrandingConfig.instance.getPrimaryTextStyle(
            fontSize: 16.sp,
            color: AppColors.greys87,
          ),
        ),
      ),
    );
  }

  Widget _contributeMoreButton() => SizedBox(
        width: 180.w,
        child: PrimaryButtonWidget(
          title: "Contribute More",
          textFontSize: 16.sp,
          onTap: () {
            _resetState();
            _loadLikhoData();
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
                builder: (context) => LikhoValidationScreen(),
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
    
    displayIndex = (displayIndex + 1) % likhoItems.length;
    
    if (displayIndex == 0 && likhoItems.length < 10) {
      await _loadMoreSentences();
    }
    
    setState(() {});

    Helper.showSnackBarMessage(
      context: context,
      text: "Sentence skipped. Please translate the new sentence.",
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
      final success = await _likhoService.submitTranslation(
        itemId: likhoItems[currentIndex].itemId,
        srcLanguage: widget.language.languageCode,
        translation: textController.text.trim(),
      );

      if (success) {
        submittedCount++;
        Helper.showSnackBarMessage(
          context: context,
          text: "Your translation submitted successfully",
        );

        if (submittedCount < totalContributions) {
          textController.clear();
          enableSubmit.value = false;
          currentIndex++;
          displayIndex = currentIndex;
          widget.indexUpdate(currentIndex);
        } else {
          setState(() {});
        }
      } else {
        Helper.showSnackBarMessage(
          context: context,
          text: "Failed to submit translation. Please try again.",
        );
      }
    } catch (e) {
      Helper.showSnackBarMessage(
        context: context,
        text: "Error submitting translation: $e",
      );
    } finally {
      submitLoading.value = false;
    }
  }

  Future<void> _loadMoreSentences() async {
    try {
      final response = await _likhoService.getLikhoQueue(
        srcLanguage: widget.language.languageCode,
        batchSize: 5,
      );
      
      if (response.success && response.data.isNotEmpty) {
        likhoItems.addAll(response.data);
      }
    } catch (e) {
      print('Error loading more sentences: $e');
    }
  }
}