import 'package:ai4i_contribute/constants/app_constants.dart';
import 'package:ai4i_contribute/constants/app_theme.dart';
import 'package:ai4i_contribute/screens/splash_screen/splash_screen.dart';
import 'package:ai4i_contribute/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai4i_contribute/config/app_config.dart';
import 'package:ai4i_contribute/config/branding_config.dart';
import 'package:ai4i_contribute/services/auth_manager.dart';
import 'package:provider/provider.dart';
import 'package:ai4i_contribute/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  await AppConfig.initialize(environment: Environment.development);

  // Initialize branding configuration
  await BrandingConfig.initialize();

  // Validate configuration
  AppConfig.instance.validateConfig();

  // Initialize AuthManager
  await AuthManager.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(
          AppConstants.defaultScreenWidth,
          AppConstants.defaultScreenHeight,
        ),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              home: CustomSplashScreen(),
              onGenerateRoute: Routes.generateRoute,
            ),
          );
        });
  }
}
