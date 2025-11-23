import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import '../../config/branding_config.dart';

class LikhoValidationContentSkeleton extends StatelessWidget {
  const LikhoValidationContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Progress header skeleton
                _buildProgressSkeleton(),
                SizedBox(height: 24.w),
                // Instruction text skeleton
                _buildInstructionSkeleton(),
                SizedBox(height: 22.w),
                // Text display section skeleton
                _buildTextDisplaySkeleton(),
                SizedBox(height: 22.w),
                // Action buttons skeleton
                _buildActionButtonsSkeleton(),
                SizedBox(height: 20.w),
                // Skip button skeleton
                _buildSkipButtonSkeleton(),
                SizedBox(height: 50.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSkeleton() {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Container(
              width: 30.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: AppColors.lightGreen4,
                borderRadius: BorderRadius.circular(4).r,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.w),
        Container(
          height: 4.0,
          decoration: BoxDecoration(
            color: AppColors.lightGreen4,
            borderRadius: BorderRadius.circular(2).r,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32).r,
      child: Container(
        width: 200.w,
        height: 14.h,
        decoration: BoxDecoration(
          color: AppColors.lightGreen4,
          borderRadius: BorderRadius.circular(4).r,
        ),
      ),
    );
  }

  Widget _buildTextDisplaySkeleton() {
    return Column(
      children: [
        _buildTextBoxSkeleton(),
        SizedBox(height: 16.w),
        _buildTextBoxSkeleton(),
      ],
    );
  }

  Widget _buildTextBoxSkeleton() {
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen3,
                  borderRadius: BorderRadius.circular(4).r,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen3,
                  borderRadius: BorderRadius.circular(4).r,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 150.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen3,
                  borderRadius: BorderRadius.circular(4).r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonsSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: AppColors.lightGreen4,
            borderRadius: BorderRadius.circular(6).r,
          ),
        ),
        SizedBox(width: 24.w),
        Container(
          width: 140.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: AppColors.lightGreen4,
            borderRadius: BorderRadius.circular(6).r,
          ),
        ),
      ],
    );
  }

  Widget _buildSkipButtonSkeleton() {
    return Container(
      width: 120.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.lightGreen4,
        borderRadius: BorderRadius.circular(6).r,
      ),
    );
  }
}