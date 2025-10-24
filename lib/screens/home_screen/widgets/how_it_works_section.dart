import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.howItWorks,
          style: GoogleFonts.notoSans(
            color: AppColors.darkGreen,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardWidget(
                title: AppLocalizations.of(context)!.contribute,
                description:
                    AppLocalizations.of(context)!.speakClearlyAndRecord,
                iconPath: 'assets/icons/speaking.png'),
            cardWidget(
                title: AppLocalizations.of(context)!.validate,
                description: AppLocalizations.of(context)!.listenAndValidate,
                iconPath: 'assets/icons/deaf.png'),
            cardWidget(
                title: AppLocalizations.of(context)!.earnCertificate,
                description:
                    AppLocalizations.of(context)!.earnCertificateDescription,
                iconPath: 'assets/icons/certificate.png')
          ],
        ),
      ],
    );
  }

  Widget cardWidget(
      {required String title,
      required String description,
      required String iconPath}) {
    return Container(
      width: 120.w,
      height: 160.w,
      padding: EdgeInsets.all(10).r,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreen),
        color: AppColors.lightGreen2,
        borderRadius: BorderRadius.circular(12).r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.darkGreen,
              child: Image.asset(
                iconPath,
                width: 50.w,
                height: 50.w,
              )),
          SizedBox(height: 4.w),
          Text(
            title,
            style: GoogleFonts.notoSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.w),
          Text(
            description,
            style: GoogleFonts.notoSans(
              fontSize: 8.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
