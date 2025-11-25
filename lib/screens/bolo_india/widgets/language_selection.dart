import 'package:VoiceGive/common_widgets/language_searchable_bottom_sheet/searchable_boottosheet_content.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/screens/bolo_india/service/bolo_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';

class LanguageSelection extends StatefulWidget {
  final String description;
  final Function(LanguageModel) onLanguageChanged;
  final LanguageModel? initialLanguage;
  const LanguageSelection(
      {super.key, required this.description, required this.onLanguageChanged, this.initialLanguage});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  late LanguageModel selectedLanguage;
  Future<List<LanguageModel>>? languagesFuture;

  @override
  void initState() {
    selectedLanguage = widget.initialLanguage ?? LanguageModel(
      languageName: "Hindi",
      nativeName: "हिन्दी",
      isActive: true,
      languageCode: "hi",
      region: "India",
      speakers: "",
    );
    languagesFuture = BoloService().getLanguages();
    super.initState();
    // Notify initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLanguageChanged(selectedLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LanguageModel>>(
        future: languagesFuture,
        builder: (context, snapshot) {
          return Row(
            children: [
              Text(
                widget.description,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 12.sp,
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w500),
              ),
              Spacer(),
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
                                selectedLanguage = value;
                                widget.onLanguageChanged(value);
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
                      Text(
                        selectedLanguage.languageName,
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 12.sp,
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.w500),
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
          );
        });
  }
}
