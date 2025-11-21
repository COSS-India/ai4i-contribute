import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config/branding_config.dart';
import '../constants/app_colors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 160).w,
                  child: Icon(
                    Icons.error_outline,
                    color: AppColors.darkGreen,
                    size: 100.w,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24).w,
                child: Text(
                  AppLocalizations.of(context)!.namasteContributor,
                  style: BrandingConfig.instance.getTertiaryTextStyle(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                      height: 1.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0).w,
                child: Text(
                  AppLocalizations.of(context)!.errorDesc,
                  textAlign: TextAlign.center,
                  style: BrandingConfig.instance.getTertiaryTextStyle(
                      color: AppColors.greys87,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.w,
                      letterSpacing: 0.12,
                      height: 1.4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  AppLocalizations.of(context)!.errorSubtitle,
                  style: BrandingConfig.instance.getSecondaryTextStyle(
                    color: AppColors.greys87,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    height: 1.5,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SizedBox(
                  height: 48.w,
                  width: 272.w,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.darkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                    child: Text(
                      AppLocalizations.of(context)!.errorButton,
                      style: BrandingConfig.instance.getSecondaryTextStyle(
                          color: AppColors.appBarBackground,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          letterSpacing: 0.5,
                          height: 1.5),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
