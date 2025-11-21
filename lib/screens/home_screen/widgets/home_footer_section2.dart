import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_colors.dart';

class HomeFooterSection2 extends StatelessWidget {
  const HomeFooterSection2({super.key});

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
            children: [
              _buildLogo('assets/images/negd_logo.png'),
              _buildLogo('assets/images/meity_logo.png'),
              _buildLogo('assets/images/npi_logo.png'),
              _buildLogo('assets/images/mygov_logo.png'),
            ],
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
                'Digital India Bhashini Division',
                style: GoogleFonts.notoSans(
                  color: AppColors.appBarBackground,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.w),
              // Address
              Text(
                AppLocalizations.of(context)!.electronicsNiketanAddress,
                style: GoogleFonts.notoSans(
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
                    style: GoogleFonts.notoSans(
                      color: AppColors.appBarBackground,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ImageWidget(
                    imageUrl: 'assets/images/digital_india_logo.png',
                    height: 20.w,
                    width: 80.w,
                  ),
                ],
              ),
              SizedBox(height: 16.w),
              // Additional information
              Text(
                AppLocalizations.of(context)!.digitalIndiaCorporation,
                style: GoogleFonts.notoSans(
                  color: AppColors.appBarBackground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                AppLocalizations.of(context)!.ministryOfElectronicsIt,
                style: GoogleFonts.notoSans(
                  color: AppColors.appBarBackground,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                AppLocalizations.of(context)!.governmentOfIndia,
                style: GoogleFonts.notoSans(
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
                  style: GoogleFonts.notoSans(
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

  Widget _buildLogo(String imagePath) {
    return SizedBox(
      height: 50.w,
      width: 60.w,
      child: ImageWidget(
        imageUrl: imagePath,
        boxFit: BoxFit.contain,
      ),
    );
  }
}
