import 'package:ai4i_contribute/constants/app_colors.dart';
import 'package:ai4i_contribute/config/branding_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAboutSection extends StatefulWidget {
  const HomeAboutSection({super.key});

  @override
  State<HomeAboutSection> createState() => _HomeAboutSectionState();
}

class _HomeAboutSectionState extends State<HomeAboutSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whatIsAi4iContribute,
          style: BrandingConfig.instance.getPrimaryTextStyle(
            color: AppColors.darkGreen,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.w),
        Text(
          AppLocalizations.of(context)!.ai4iContributeDescription,
          style: BrandingConfig.instance.getPrimaryTextStyle(
            color: AppColors.greys87,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
