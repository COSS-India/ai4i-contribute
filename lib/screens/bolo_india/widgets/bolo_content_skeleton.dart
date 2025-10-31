import 'package:VoiceGive/common_widgets/container_skeleton.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/branding_config.dart';

class BoloContentSkeleton extends StatelessWidget {
  const BoloContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8).r,
          border: Border.all(
            color: Colors.grey[700]!,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8).r,
          child: Stack(
            children: [
              Image.asset(
                "assets/images/contribute_bg.png",
                fit: BoxFit.cover,
                width: double.infinity,
                color: BrandingConfig.instance.primaryColor,
              ),
              Padding(
                padding: EdgeInsets.all(12).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        ContainerSkeleton(
                          width: 30.w,
                          height: 30.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ContainerSkeleton(
                      width: 1.sw,
                      height: 8.h,
                    ),
                    SizedBox(height: 24.h),
                    ContainerSkeleton(
                      width: 0.7.sw,
                      height: 30.h,
                    ),
                    SizedBox(height: 16.h),
                    ContainerSkeleton(
                      width: 0.5.sw,
                      height: 30.h,
                    ),
                    SizedBox(height: 70.h),
                    ContainerSkeleton(
                      width: 90.w,
                      height: 90.h,
                      radius: 40,
                    ),
                    SizedBox(height: 70.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ContainerSkeleton(
                          width: 0.4.sw,
                          height: 45.h,
                        ),
                        ContainerSkeleton(
                          width: 0.4.sw,
                          height: 45.h,
                        ),
                      ],
                    ),
                    SizedBox(height: 70.h),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
