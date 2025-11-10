import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/config/branding_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12).r,
      decoration: BoxDecoration(
        color: AppColors.lightGreen2,
        border: Border.all(color: AppColors.lightGreen),
        borderRadius: BorderRadius.circular(12).r,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: actionButton(
                onTap: () {},
                title: AppLocalizations.of(context)!.quickTips,
                icon: Icons.lightbulb_outline),
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: actionButton(
                onTap: () {},
                title: AppLocalizations.of(context)!.report,
                icon: Icons.report_outlined),
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: actionButton(
                onTap: () {},
                title: AppLocalizations.of(context)!.testSpeakers,
                icon: Icons.volume_up_outlined),
          ),
        ],
      ),
    );
  }

  Widget actionButton(
      {required VoidCallback? onTap,
      required String title,
      required IconData icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8).r,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border.all(color: AppColors.darkGreen),
          borderRadius: BorderRadius.circular(8).r,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.darkGreen,
              size: 16.sp,
              weight: 600,
            ),
            SizedBox(width: 4.w),
            Text(title,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
