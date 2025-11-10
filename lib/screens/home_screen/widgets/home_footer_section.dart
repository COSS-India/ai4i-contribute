import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/branding_config.dart';
import '../../../constants/app_colors.dart';

class HomeFooterSection extends StatelessWidget {
  const HomeFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // White logo section
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 16.w),
          color: AppColors.appBarBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          ),
        ),
        // Dark blue footer section
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 60, left: 60, right: 60, bottom: 20).r,
          color: Color.fromRGBO(15, 25, 65, 1), // Much darker navy blue
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main heading
              Text(
                '',
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: AppColors.appBarBackground,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.w),
              // Address
              Text(
                AppLocalizations.of(context)!.electronicsNiketanAddress,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: AppColors.appBarBackground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.w),
              // Powered by section
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.poweredBy,
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      color: AppColors.appBarBackground,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
              SizedBox(height: 16.w),
              // Additional information
              Text(
                AppLocalizations.of(context)!.digitalIndiaCorporation,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: AppColors.appBarBackground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                AppLocalizations.of(context)!.ministryOfElectronicsIt,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: AppColors.appBarBackground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                AppLocalizations.of(context)!.governmentOfIndia,
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: AppColors.appBarBackground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 80.w),
              // Separator line
              Container(
                height: 3.w,
                width: double.infinity,
                color: AppColors.appBarBackground,
              ),
              SizedBox(height: 20.w),
              // Copyright notice
              Center(
                child: Text(
                  AppLocalizations.of(context)!.copyrightNotice,
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    color: AppColors.appBarBackground,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
