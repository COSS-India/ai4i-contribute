import 'package:ai4i_contribute/common_widgets/fade_route.dart';
import 'package:ai4i_contribute/constants/app_routes.dart';
import 'package:ai4i_contribute/screens/bolo_india/bolo_contribute/bolo_contribute.dart';
import 'package:ai4i_contribute/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

import '../common_widgets/error_page.dart';
import '../screens/auth/otp_login/otp_login_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      return _getRoute(routeSettings);
    } catch (e) {
      return errorRoute(routeSettings);
    }
  }

  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
        settings: routeSettings, builder: (_) => ErrorPage());
  }

  static Route<dynamic> _getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.bolo:
        return MaterialPageRoute(builder: (context) => const BoloContribute());

      case AppRoutes.otpVerification:
        return MaterialPageRoute(builder: (context) => const OtpLoginScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      default:
        return FadeRoute(page: const HomeScreen());
    }
  }
}
