import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../config/branding_config.dart';
import '../../common_widgets/image_widget.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.home,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashLogo = BrandingConfig.instance.splashLogo;
    final splashName = BrandingConfig.instance.splashName;
    final splashAnimation = BrandingConfig.instance.splashAnimation;

    // Priority 1: Animation (highest priority)
    if (splashAnimation.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: _buildAnimationSplash(splashAnimation),
      );
    }

    // Priority 2: Both logo and name
    if (splashLogo.isNotEmpty && splashName.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: _buildImageSplash(splashLogo, splashName),
      );
    }

    // Priority 3: Logo only (show logo without name)
    if (splashLogo.isNotEmpty && splashName.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: _buildImageSplash(splashLogo, ''),
      );
    }

    // Priority 4: Name only (show name without logo)
    if (splashName.isNotEmpty && splashLogo.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: _buildImageSplash('', splashName),
      );
    }

    // Fallback: Default (logo and "Contribute" text)
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _buildImageSplash('assets/launcher/ai4i_logo.png', 'Contribute'),
    );
  }

  Widget _buildImageSplash(String logoPath, String splashName) {
    // Auto-navigate after 3 seconds for image splash
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (logoPath.isNotEmpty)
            ImageWidget(
              imageUrl: logoPath,
              width: 200,
              height: 200,
              boxFit: BoxFit.contain,
            ),
          if (logoPath.isNotEmpty && splashName.isNotEmpty)
            const SizedBox(height: 16),
          if (splashName.isNotEmpty)
            Text(
              splashName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.greys87,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimationSplash(String animationPath) {
    return Lottie.asset(
      animationPath,
      controller: _controller,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _controller.forward();
      },
    );
  }
}
