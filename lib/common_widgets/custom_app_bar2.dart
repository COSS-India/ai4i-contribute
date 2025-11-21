import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../config/branding_config.dart';
import 'image_widget.dart';

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar2({super.key});

  @override
  Size get preferredSize => Size.fromHeight(58.h);

  @override
  Widget build(BuildContext context) {
    final branding = BrandingConfig.instance;
    final hasAnyHeaderImage = branding.headerPrimaryImage.isNotEmpty ||
        branding.headerSecondaryImage.isNotEmpty ||
        branding.headerTertiaryImage.isNotEmpty;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 58.h,
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Position 1: Primary image
          if (hasAnyHeaderImage ? branding.headerPrimaryImage.isNotEmpty : true)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0).r,
              child: ImageWidget(
                imageUrl: hasAnyHeaderImage
                    ? branding.headerPrimaryImage
                    : "assets/launcher/ai4i_logo.png",
                height: 36.w,
              ),
            ),
          // Separator and spacing
          if ((hasAnyHeaderImage &&
                  branding.headerPrimaryImage.isNotEmpty &&
                  branding.headerSecondaryImage.isNotEmpty) ||
              (!hasAnyHeaderImage))
            Container(
              margin: EdgeInsets.only(left: 10, right: 10).r,
              width: 1,
              height: 40,
              color: AppColors.grey24,
            )
          else if (hasAnyHeaderImage && branding.headerPrimaryImage.isNotEmpty)
            SizedBox(width: 10.w),
          // Position 2: Secondary image
          if (hasAnyHeaderImage
              ? branding.headerSecondaryImage.isNotEmpty
              : true)
            ImageWidget(
              imageUrl: hasAnyHeaderImage
                  ? branding.headerSecondaryImage
                  : "assets/images/contribute.png",
              height: 36.w,
              imageColor:
                  hasAnyHeaderImage ? null : BrandingConfig.instance.textColor,
            ),
          Spacer(),
          // Position 3: Tertiary image
          if (branding.headerTertiaryImage.isNotEmpty)
            ImageWidget(
              imageUrl: branding.headerTertiaryImage,
              height: 36.w,
            )
        ],
      ),
    );
  }
}
