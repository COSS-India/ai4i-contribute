import 'package:VoiceGive/common_widgets/branding_alignment_widget.dart';
import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_contribute/bolo_contribute.dart';
import 'package:VoiceGive/screens/bolo_india/bolo_validation_screen/bolo_validation_screen.dart';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/branding_config.dart';

class CongratulationsScreen extends StatefulWidget {
  const CongratulationsScreen({
    super.key,
  });

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _navigateBackToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final branding = BrandingConfig.instance;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _navigateBackToHome();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(16).r,
                decoration: BoxDecoration(color: AppColors.bannerColor),
                child: Row(
                  children: [
                    InkWell(
                      onTap: _navigateBackToHome,
                      child: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: Colors.white,
                        size: 36.sp,
                      ),
                    ),
                    SizedBox(width: 24.w),
                    branding.bannerImage.isNotEmpty
                        ? ImageWidget(
                            imageUrl: branding.bannerImage,
                            height: 40.w,
                            width: 40.w,
                          )
                        : SizedBox(width: 40.w, height: 40.w),
                  ],
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(16.0).r,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Congratulations Section
                    _buildCongratulationsSection(),
                    SizedBox(height: 32.w),
                    // Certificate Preview
                    _buildCertificatePreview(),
                    SizedBox(height: 24.w),
                    // Download Certificate Button
                    _buildDownloadButton(),
                    SizedBox(height: 16.w),
                    // Certificate Details
                    _buildCertificateDetails(),
                    SizedBox(height: 32.w),
                    // Action Buttons
                    _buildActionButtons(),
                    // Add extra bottom padding to ensure buttons are above navigation bar
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 20.w),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCongratulationsSection() {
    final branding = BrandingConfig.instance;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            children: [
              // Badge
              branding.badgeImage.isNotEmpty
                  ? ImageWidget(
                      imageUrl: branding.badgeImage,
                      height: 120.w,
                      width: 120.w,
                      boxFit: BoxFit.contain,
                    )
                  : ImageWidget(
                      imageUrl: 'assets/images/bolo_logo.png',
                      height: 120.w,
                      width: 120.w,
                      boxFit: BoxFit.contain,
                    ),
              SizedBox(height: 24.w),
              // Congratulations Text
              Text(
                '${AppLocalizations.of(context)!.congratulations}!',
                style: GoogleFonts.notoSans(
                  fontSize: 28.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.w),
              // Achievement Text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.notoSans(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: "You've "),
                    TextSpan(
                      text: "contributed 5 sentences",
                      style: GoogleFonts.notoSans(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: "validated 25",
                      style: GoogleFonts.notoSans(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: " in your language"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCertificatePreview() {
    return GestureDetector(
      onTap: () {
        _showCertificatePreview();
      },
      child: Container(
        width: double.infinity,
        height: 200.w,
        padding: EdgeInsets.symmetric(vertical: 12).r,
        decoration: BoxDecoration(
          color: AppColors.lightGreen3,
          borderRadius: BorderRadius.circular(12).r,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Certificate Header
            Text(
              AppLocalizations.of(context)!.tapToPreviewCertificate,
              style: GoogleFonts.notoSans(
                  color: AppColors.greys,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500),
            ),
            // Certificate Preview Content (Blurred)
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12).r,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8).r,
                        border:
                            Border.all(color: AppColors.darkGreen, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8).r,
                        child: BrandingConfig
                                .instance.certificateImage.isNotEmpty
                            ? ImageWidget(
                                imageUrl:
                                    BrandingConfig.instance.certificateImage,
                              )
                            : Image.asset(
                                'assets/images/certificate.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return SizedBox(
      height: 48.w,
      child: IntrinsicWidth(
        child: PrimaryButtonWidget(
          title: AppLocalizations.of(context)!.downloadCertificate,
          textFontSize: 16.sp,
          horizontalPadding: 32.r,
          fontWeight: FontWeight.w600,
          onTap: () {
            // Download certificate as PDF
            // _downloadCertificate();
          },
          textColor: AppColors.appBarBackground,
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.circular(8).r,
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGreen.withValues(alpha: 0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateDetails() {
    return Column(
      children: [
        Text(
          "PDF (print-ready, includes your name & achievement)",
          style: GoogleFonts.notoSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.disabledTextGrey),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.w),
        Text(
          "Issued on: 17 Sep 2025. Certificate ID: DIC-20250917-0123",
          style: GoogleFonts.notoSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.disabledTextGrey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40.w,
            child: PrimaryButtonWidget(
              title: AppLocalizations.of(context)!.validateMore,
              textFontSize: 14.sp,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoloValidationScreen()),
                );
              },
              textColor: AppColors.orange,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.orange, width: 1.5),
                borderRadius: BorderRadius.circular(6).r,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SizedBox(
            height: 40.w,
            child: PrimaryButtonWidget(
              title: AppLocalizations.of(context)!.contributeMore,
              textFontSize: 14.sp,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BoloContribute()),
                );
              },
              textColor: Colors.white,
              decoration: BoxDecoration(
                color: AppColors.orange,
                border: Border.all(color: AppColors.orange, width: 1.5),
                borderRadius: BorderRadius.circular(6).r,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCertificatePreview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12).r,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16).r,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12).r,
                      topRight: Radius.circular(12).r,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Certificate Preview",
                        style: GoogleFonts.notoSans(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                // Certificate Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24).r,
                    child: _buildFullCertificate(),
                  ),
                ),
                // Download Button
                Padding(
                  padding: EdgeInsets.all(16).r,
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.w,
                    child: PrimaryButtonWidget(
                      title: AppLocalizations.of(context)!.downloadPdf,
                      textFontSize: 16.sp,
                      onTap: () {
                        Navigator.of(context).pop();
                        //  _downloadCertificate();
                      },
                      textColor: Colors.white,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(8).r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullCertificate() {
    return Container(
      padding: EdgeInsets.all(32).r,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(8).r,
      ),
      child: Column(
        children: [
          // Government Logo and Ministry

          // Certificate Title
          Text(
            "CERTIFICATE",
            style: GoogleFonts.notoSans(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          Text(
            "OF APPRECIATION",
            style: GoogleFonts.notoSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.orange,
            ),
          ),
          SizedBox(height: 24.w),

          // Presentation Text
          Text(
            "PROUDLY PRESENTED TO",
            style: GoogleFonts.notoSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.w),

          // Recipient Name
          Text(
            "Animesh Patil",
            style: GoogleFonts.notoSans(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16.w),

          // Decorative Line
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2.w,
                  color: Colors.amber[600],
                ),
              ),
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  height: 2.w,
                  color: Colors.amber[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.w),

          // Recognition Text
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.notoSans(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
              children: [
                const TextSpan(text: "Recognized as a "),
                TextSpan(
                  text: "Contributor",
                  style: GoogleFonts.notoSans(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.w),

          // Description
          Column(
            children: [
              Text(
                "For contributing to",
                style: GoogleFonts.notoSans(
                  fontSize: 12.sp,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.w),
              Text(
                'AI4I - Contribute',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.w),
            ],
          ),
          SizedBox(height: 32.w),

          // Signatory
          // Text(
          //   "CEO, AI4I",
          //   style: GoogleFonts.notoSans(
          //     fontSize: 14.sp,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.black87,
          //   ),
          // ),
          Container(
            width: 100.w,
            height: 2.w,
            color: Colors.amber[600],
          ),
        ],
      ),
    );
  }
}
