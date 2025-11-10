import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';

class NeedMoreInfo extends StatelessWidget {
  const NeedMoreInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24).r,
      decoration: BoxDecoration(
        // color: Colors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/need_help_banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.needMoreInfo,
            style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.writeYourConcern,
            style: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 16.w),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6).r,
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.contactUs,
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.appBarBackground),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.backgroundColor,
                  )
                ],
              )),
          SizedBox(height: 16.w)
        ],
      ),
    );
  }
}
