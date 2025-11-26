import 'package:VoiceGive/common_widgets/custom_app_bar.dart';
import 'package:VoiceGive/common_widgets/image_widget.dart';
import 'package:VoiceGive/common_widgets/primary_button_widget.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/dekho/dekho_contribute.dart';
import 'package:VoiceGive/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';
import '../../config/branding_config.dart';
import '../bolo_india/widgets/bolo_headers_section.dart';
import '../module_selection_screen.dart';

class DekhoCongratulationsScreen extends StatefulWidget {
  const DekhoCongratulationsScreen({super.key});

  @override
  State<DekhoCongratulationsScreen> createState() =>
      _DekhoCongratulationsScreenState();
}

class _DekhoCongratulationsScreenState extends State<DekhoCongratulationsScreen>
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _navigateBackToHome();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          showThreeLogos: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              BoloHeadersSection(
                logoAsset: 'assets/images/dekho_header.png',
                title: 'DEKHO India',
                subtitle: 'Enrich your language by describing images',
                onBackPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ModuleSelectionScreen()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0).r,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCongratulationsSection(),
                    SizedBox(height: 32.w),
                    _buildCertificateWithMessage(),
                    SizedBox(height: 32.w),
                    _buildActionButtons(),
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
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            children: [
              ImageWidget(
                imageUrl: 'assets/images/dekho_header.png',
                height: 120.w,
                width: 120.w,
                boxFit: BoxFit.contain,
              ),
              SizedBox(height: 24.w),
              Text(
                '${AppLocalizations.of(context)!.congratulations}!',
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  fontSize: 28.sp,
                  color: AppColors.greys87,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.w),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: BrandingConfig.instance.getPrimaryTextStyle(
                    fontSize: 16.sp,
                    color: AppColors.greys87,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: "You've "),
                    TextSpan(
                      text: "validated 25 images",
                      style: BrandingConfig.instance.getPrimaryTextStyle(
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

  Widget _buildCertificateWithMessage() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 330.w,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12).r,
            child: Image.asset(
              'assets/images/certificate.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12).r,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(22).r,
              padding: EdgeInsets.all(22).r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12).r,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🎉',
                    style: TextStyle(fontSize: 32.sp),
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    'Certificates are on the way!',
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    'Your progress has been saved.\n Thank you for contributing to India\'s \n language strengthening campaign',
                    style: BrandingConfig.instance.getPrimaryTextStyle(
                      fontSize: 10.sp,
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48.w,
            child: PrimaryButtonWidget(
              title: " Continue Contributing",
              textFontSize: 14.sp,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DekhoContribute()),
                );
              },
              textColor: AppColors.backgroundColor,
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
}