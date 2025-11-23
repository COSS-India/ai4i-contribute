import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/branding_config.dart';

class LikhoContentSkeleton extends StatelessWidget {
  const LikhoContentSkeleton({super.key});

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
                _progressHeaderSkeleton(),
                SizedBox(height: 24.w),
                _sentenceTextSkeleton(),
                SizedBox(height: 16.w),
                _instructionTextSkeleton(),
                SizedBox(height: 30.w),
                _textInputFieldSkeleton(),
                SizedBox(height: 30.w),
                _actionButtonsSkeleton(),
                SizedBox(height: 50.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressHeaderSkeleton() => Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                width: 30.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4).r,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.w),
          Container(
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2).r,
            ),
          ),
        ],
      );

  Widget _sentenceTextSkeleton() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32).r,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4).r,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: 200.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4).r,
              ),
            ),
          ],
        ),
      );

  Widget _instructionTextSkeleton() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32).r,
        child: Container(
          width: 180.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4).r,
          ),
        ),
      );

  Widget _textInputFieldSkeleton() => Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8).r,
        ),
      );

  Widget _actionButtonsSkeleton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6).r,
            ),
          ),
          SizedBox(width: 24.w),
          Container(
            width: 120.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6).r,
            ),
          ),
        ],
      );
}