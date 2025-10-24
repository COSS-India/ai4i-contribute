import 'package:VoiceGive/common_widgets/consent_modal.dart';
import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/constants/app_routes.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_get_started/bolo_get_started.dart';
import 'package:VoiceGive/screens/bolo_india/service/bolo_service.dart';
import 'package:VoiceGive/screens/home_screen/widgets/home_about_section.dart';
import 'package:VoiceGive/screens/home_screen/widgets/home_header_section.dart';
import 'package:VoiceGive/screens/home_screen/widgets/home_footer_section.dart';
import 'package:VoiceGive/screens/home_screen/widgets/how_it_works_section.dart';
import 'package:VoiceGive/screens/home_screen/widgets/need_more_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/branding_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showConsentModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InformedConsentModal(
          onApprove: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(
              context,
              AppRoutes.otpVerification,
            );
          },
          onDeny: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _handleGetStartedAction() async {
    String sessionId = await BoloService.sessionId;
    if (sessionId.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const BoloGetStarted(),
        ),
      );
    } else {
      _showConsentModal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = BrandingConfig.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (branding.homeScreenBodyImage.isEmpty) ...[
                      HomeHeaderSection(),
                      SizedBox(height: 16.w),
                    ],
                    branding.homeScreenBodyImage.isNotEmpty
                        ? GestureDetector(
                            onTap: _handleGetStartedAction,
                            child: ImageWidget(
                                imageUrl: branding.homeScreenBodyImage),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0).r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HomeAboutSection(),
                                SizedBox(height: 24.w),
                                HowItWorksSection(),
                                SizedBox(height: 36.w),
                              ],
                            ),
                          ),
                    if (branding.homeScreenFooterImage.isEmpty) NeedMoreInfo(),
                    branding.homeScreenBodyImage.isNotEmpty
                        ? ImageWidget(imageUrl: branding.homeScreenBodyImage)
                        : HomeFooterSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
