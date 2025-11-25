import 'package:VoiceGive/common_widgets/container_skeleton.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ValidationAudioPlayerSkeleton extends StatefulWidget {
  const ValidationAudioPlayerSkeleton({super.key});

  @override
  State<ValidationAudioPlayerSkeleton> createState() => _ValidationAudioPlayerSkeletonState();
}

class _ValidationAudioPlayerSkeletonState extends State<ValidationAudioPlayerSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Audio progress bar skeleton
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(40).r,
            border: Border.all(color: AppColors.darkGreen),
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              ContainerSkeleton(width: 60, height: 12, radius: 2),
              SizedBox(width: 8.w),
              Expanded(
                child: ContainerSkeleton(width: double.infinity, height: 2.5, radius: 2),
              ),
              SizedBox(width: 8.w),
              ContainerSkeleton(width: 30, height: 12, radius: 2),
              SizedBox(width: 16.w),
            ],
          ),
        ),
        SizedBox(height: 30.w),
        // Text input field skeleton
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 123.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8).r,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Container(
                height: 123.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8).r,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.w),
        // Play button skeleton
        ContainerSkeleton(width: 60, height: 60, radius: 30),
      ],
    );
  }
}