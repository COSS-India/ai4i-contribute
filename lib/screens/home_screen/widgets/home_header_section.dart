import 'package:VoiceGive/common_widgets/consent_modal.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/constants/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bolo_india/bolo_get_started/bolo_get_started.dart';
import '../../bolo_india/service/bolo_service.dart';

class HomeHeaderSection extends StatefulWidget {
  const HomeHeaderSection({super.key});

  @override
  State<HomeHeaderSection> createState() => _HomeHeaderSectionState();
}

class _HomeHeaderSectionState extends State<HomeHeaderSection> {
  void _showConsentModal(BuildContext context) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => BoloContribute()));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InformedConsentModal(
          onApprove: () {
            Navigator.of(context).pop(); // Close the modal
            Navigator.pushNamed(
              context,
              AppRoutes.otpVerification,
            );
          },
          onDeny: () {
            Navigator.of(context).pop(); // Close the modal
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16).r,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/home_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70.0).w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                AppColors.darkGreen,
                                AppColors.lightGreen
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(Rect.fromLTWH(
                                0, 0, bounds.width, bounds.height)),
                            child: Text(
                              AppLocalizations.of(context)!.agriDaan,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .empowerIndiasLinguisticDiversity,
                            style: GoogleFonts.notoSans(
                                color: AppColors.darkBlue,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: -20,
                child: ImageWidget(
                  imageUrl: "assets/images/home_header_image.png",
                  width: 180.w,
                  height: 180.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.w),
          Text(
            AppLocalizations.of(context)!.joinTheMovementDescription,
            style: GoogleFonts.notoSans(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12.w),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () async {
                String sessionId = await BoloService.sessionId;
                if(sessionId.isNotEmpty){
                  Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const BoloGetStarted(),
                                  ),
                                );
                }
                else{
                  _showConsentModal(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6).r,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.letsGetStarted,
                style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          SizedBox(height: 8.w),
        ],
      ),
    );
  }
}
