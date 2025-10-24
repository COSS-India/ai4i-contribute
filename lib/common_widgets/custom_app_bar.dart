import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../config/branding_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'image_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

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
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Position 1: Primary image or default logo
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0).r,
            child: branding.headerPrimaryImage.isNotEmpty
                ? ImageWidget(
                    imageUrl: branding.headerPrimaryImage,
                    height: 36.w,
                  )
                : hasAnyHeaderImage
                    ? SizedBox(height: 36.w)
                    : ImageWidget(
                        imageUrl: "assets/images/bhashini_logo.svg",
                        height: 36.w,
                      ),
          ),
          // Separator and spacing
          if (branding.headerPrimaryImage.isNotEmpty && branding.headerSecondaryImage.isNotEmpty)
            Container(
              margin: EdgeInsets.only(left: 10, right: 10).r,
              width: 1,
              height: 40,
              color: AppColors.grey24,
            )
          else if (hasAnyHeaderImage && branding.headerPrimaryImage.isNotEmpty)
            SizedBox(width: 10.w)
          else if (!hasAnyHeaderImage)
            Container(
              margin: EdgeInsets.only(left: 10, right: 10).r,
              width: 1,
              height: 40,
              color: AppColors.grey24,
            ),
          // Position 2: Secondary image or default text
          if (branding.headerSecondaryImage.isNotEmpty)
            ImageWidget(
              imageUrl: branding.headerSecondaryImage,
              height: 36.w,
            )
          else if (!hasAnyHeaderImage)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.bhasha,
                    style: GoogleFonts.notoSans(
                      color: AppColors.darkBlue,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.daan,
                    style: GoogleFonts.notoSans(
                      color: AppColors.saffron,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Spacer(),
          // Position 3: Tertiary image or default gradient text
          if (branding.headerTertiaryImage.isNotEmpty)
            ImageWidget(
              imageUrl: branding.headerTertiaryImage,
              height: 36.w,
            )
          else if (!hasAnyHeaderImage)
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [const Color(0xff157D52), const Color(0xff26E395)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                AppLocalizations.of(context)!.agriDaan,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
