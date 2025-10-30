import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';

class BoloHeadersSection extends StatelessWidget {
  final VoidCallback? onBackPressed;
  const BoloHeadersSection({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final branding = BrandingConfig.instance;

    return Container(
      padding: EdgeInsets.all(16).r,
      decoration: BoxDecoration(color: AppColors.bannerColor),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (onBackPressed != null) {
                onBackPressed!();
                return;
              }
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_circle_left_outlined,
              color: Colors.white,
              size: 36.sp,
            ),
          ),
          SizedBox(width: 24.w),
          branding.bannerImage.isNotEmpty
              ? ImageWidget(
                  imageUrl: branding.bannerImage,
                  height: 40.w,
                  width: 40.w,
                )
              : SizedBox(
                  height: 40.w,
                  width: 40.w,
                ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }
}
