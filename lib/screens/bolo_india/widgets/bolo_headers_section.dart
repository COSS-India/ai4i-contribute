import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';

class BoloHeadersSection extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final String? logoAsset;
  final String? title;
  final String? subtitle;
  const BoloHeadersSection({
    super.key, 
    this.onBackPressed,
    this.logoAsset,
    this.title,
    this.subtitle,
  });

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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (logoAsset != null) ...[
                  Image.asset(
                    logoAsset!,
                    height: 40.w,
                    width: 40.w,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: (subtitle == null || subtitle!.isEmpty) 
                        ? MainAxisAlignment.center 
                        : MainAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: (subtitle == null || subtitle!.isEmpty) ? 18.sp : 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      if (subtitle != null && subtitle!.isNotEmpty)
                        Text(
                          subtitle!,
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ] else ...[
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
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
