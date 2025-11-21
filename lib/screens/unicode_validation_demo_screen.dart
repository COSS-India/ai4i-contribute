import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/unicode_validation_text_field.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/config/branding_config.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';

class UnicodeValidationDemoScreen extends StatefulWidget {
  const UnicodeValidationDemoScreen({super.key});

  @override
  State<UnicodeValidationDemoScreen> createState() => _UnicodeValidationDemoScreenState();
}

class _UnicodeValidationDemoScreenState extends State<UnicodeValidationDemoScreen> {
  final TextEditingController _textController = TextEditingController();
  
  // All 22 Indian languages from bolo module
  final List<LanguageModel> _languages = [
    LanguageModel(languageCode: 'hi', languageName: 'Hindi', nativeName: 'हिन्दी', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'bn', languageName: 'Bengali', nativeName: 'বাংলা', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'te', languageName: 'Telugu', nativeName: 'తెలుగు', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'mr', languageName: 'Marathi', nativeName: 'मराठी', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'ta', languageName: 'Tamil', nativeName: 'தமிழ்', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'gu', languageName: 'Gujarati', nativeName: 'ગુજરાતી', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'kn', languageName: 'Kannada', nativeName: 'ಕನ್ನಡ', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'ml', languageName: 'Malayalam', nativeName: 'മലയാളം', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'pa', languageName: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'or', languageName: 'Odia', nativeName: 'ଓଡ଼ିଆ', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'as', languageName: 'Assamese', nativeName: 'অসমীয়া', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'ur', languageName: 'Urdu', nativeName: 'اردو', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'sa', languageName: 'Sanskrit', nativeName: 'संस्कृतम्', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'ne', languageName: 'Nepali', nativeName: 'नेपाली', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'si', languageName: 'Sinhala', nativeName: 'සිංහල', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'my', languageName: 'Myanmar', nativeName: 'မြန်မာ', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'bo', languageName: 'Tibetan', nativeName: 'བོད་ཡིག', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'dz', languageName: 'Dzongkha', nativeName: 'རྫོང་ཁ', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'ks', languageName: 'Kashmiri', nativeName: 'کٲشُر', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'sd', languageName: 'Sindhi', nativeName: 'سنڌي', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'mai', languageName: 'Maithili', nativeName: 'मैथिली', isActive: true, region: 'India', speakers: ''),
    LanguageModel(languageCode: 'sat', languageName: 'Santali', nativeName: 'ᱥᱟᱱᱛᱟᱲᱤ', isActive: true, region: 'India', speakers: ''),
  ];

  LanguageModel _selectedLanguage = LanguageModel(
    languageCode: 'hi',
    languageName: 'Hindi',
    nativeName: 'हिन्दी',
    isActive: true,
    region: 'India',
    speakers: '',
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Language',
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColors.darkGreen),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    return ListTile(
                      title: Text(
                        language.languageName,
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      subtitle: Text(
                        language.nativeName,
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                          fontSize: 12.sp,
                          color: AppColors.darkGreen.withOpacity(0.7),
                        ),
                      ),
                      trailing: _selectedLanguage.languageCode == language.languageCode
                          ? Icon(Icons.check, color: AppColors.orange)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedLanguage = language;
                          _textController.clear();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unicode Validation Demo',
              style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
              ),
            ),
            SizedBox(height: 24.h),
            
            // Language Selector
            Row(
              children: [
                Text(
                  'Selected Language:',
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGreen,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: _showLanguageSelector,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_selectedLanguage.languageName} (${_selectedLanguage.nativeName})',
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 12.sp,
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.backgroundColor,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            
            // Unicode Validation Text Field
            UnicodeValidationTextField(
              controller: _textController,
              languageCode: _selectedLanguage.languageCode,
              labelText: 'Enter text in ${_selectedLanguage.languageName}',
              hintText: 'Type here...',
              maxLines: 3,
              onChanged: (value) {
                // Handle text changes if needed
              },
            ),
            
            SizedBox(height: 24.h),
            
            // Instructions
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.darkGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• Select a language from the dropdown\n• Type text in the selected language\n• Invalid characters will show error message\n• Numbers and basic punctuation are allowed',
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 12.sp,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}