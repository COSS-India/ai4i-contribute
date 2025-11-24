import 'package:VoiceGive/common_widgets/language_searchable_bottom_sheet/searchable_boottosheet_content.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/service/bolo_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/branding_config.dart';

class DualLanguageSelectionWidget extends StatefulWidget {
  final String description;
  final Function(LanguageModel sourceLanguage, LanguageModel targetLanguage) onLanguageChanged;
  
  const DualLanguageSelectionWidget({
    super.key, 
    required this.description, 
    required this.onLanguageChanged
  });

  @override
  State<DualLanguageSelectionWidget> createState() => _DualLanguageSelectionWidgetState();
}

class _DualLanguageSelectionWidgetState extends State<DualLanguageSelectionWidget> {
  LanguageModel selectedSourceLanguage = LanguageModel(
      languageName: "Hindi",
      nativeName: "हिन्दी",
      isActive: true,
      languageCode: "hi",
      region: "India",
      speakers: "");
      
  LanguageModel selectedTargetLanguage = LanguageModel(
      languageName: "Marathi",
      nativeName: "मराठी",
      isActive: true,
      languageCode: "mr",
      region: "India",
      speakers: "");
      
  Future<List<LanguageModel>>? languagesFuture;

  @override
  void initState() {
    languagesFuture = BoloService().getLanguages();
    super.initState();
    // Notify initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLanguageChanged(selectedSourceLanguage, selectedTargetLanguage);
    });
  }

  List<LanguageModel> _getAvailableTargetLanguages(List<LanguageModel> allLanguages) {
    return allLanguages.where((lang) => lang.languageCode != selectedSourceLanguage.languageCode).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LanguageModel>>(
        future: languagesFuture,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.description,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 12.sp,
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From",
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                              fontSize: 10.sp,
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 8.h),
                        InkWell(
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                backgroundColor: AppColors.backgroundColor,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: Icon(Icons.close,
                                              color: AppColors.darkGreen),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      LanguageSearchableBottomSheetContent(
                                        items: snapshot.data ?? [],
                                        onItemSelected: (value) {
                                          setState(() {
                                            selectedSourceLanguage = value;
                                            // If target language is same as source, change target
                                            if (selectedTargetLanguage.languageCode == value.languageCode) {
                                              final availableTargets = _getAvailableTargetLanguages(snapshot.data ?? []);
                                              if (availableTargets.isNotEmpty) {
                                                selectedTargetLanguage = availableTargets.first;
                                              }
                                            }
                                          });
                                          widget.onLanguageChanged(selectedSourceLanguage, selectedTargetLanguage);
                                          Navigator.pop(context);
                                        },
                                        hasMore: false,
                                        initialQuery: "",
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8).r,
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(5).r,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedSourceLanguage.languageName,
                                    style: BrandingConfig.instance.getPrimaryTextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.backgroundColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.backgroundColor,
                                  size: 16.sp,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.darkGreen,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To",
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                              fontSize: 10.sp,
                              color: AppColors.greys87,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 8.h),
                        InkWell(
                          onTap: () {
                            final availableTargets = _getAvailableTargetLanguages(snapshot.data ?? []);
                            showBottomSheet(
                                context: context,
                                backgroundColor: AppColors.backgroundColor,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: Icon(Icons.close,
                                              color: AppColors.darkGreen),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      LanguageSearchableBottomSheetContent(
                                        items: availableTargets,
                                        onItemSelected: (value) {
                                          selectedTargetLanguage = value;
                                          widget.onLanguageChanged(selectedSourceLanguage, selectedTargetLanguage);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        hasMore: false,
                                        initialQuery: "",
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8).r,
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(5).r,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedTargetLanguage.languageName,
                                    style: BrandingConfig.instance.getPrimaryTextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.backgroundColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.backgroundColor,
                                  size: 16.sp,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}