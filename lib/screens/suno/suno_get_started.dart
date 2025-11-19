import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/config/branding_config.dart';

class SunoGetStarted extends StatelessWidget {
  const SunoGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headphones,
              size: 80.sp,
              color: AppColors.darkGreen,
            ),
            SizedBox(height: 24.h),
            Text(
              'Suno Module',
              style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Audio Listening & Validation',
              style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 16.sp,
                color: AppColors.grey84,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.darkGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Coming Soon!\n\nThis module will allow users to listen to audio content and validate audio recordings.',
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 14.sp,
                  color: AppColors.darkGreen,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}