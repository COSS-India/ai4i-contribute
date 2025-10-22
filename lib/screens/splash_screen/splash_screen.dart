import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';

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
    
    // If splash_logo is specified, only show image
    if (splashLogo.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: _buildImageSplash(splashLogo),
      );
    }
    
    // Otherwise show animation
    final animationPath = BrandingConfig.instance.splashAnimation.isNotEmpty 
        ? BrandingConfig.instance.splashAnimation
        : 'assets/animations/bhashadaan_splash_screen.json';
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildAnimationSplash(animationPath),
    );
  }
  
  Widget _buildImageSplash(String logoPath) {
    // Auto-navigate after 3 seconds for image splash
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
    
    return Center(
      child: ImageWidget(
        imageUrl: logoPath,
        width: 200,
        height: 200,
        boxFit: BoxFit.contain,
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
