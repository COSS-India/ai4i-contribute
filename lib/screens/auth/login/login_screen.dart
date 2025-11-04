import 'package:VoiceGive/screens/bolo_india/bolo_contribute/bolo_contribute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/custom_app_bar.dart';
import '../../../constants/app_colors.dart';
import '../../home_screen/home_screen.dart';
import '../otp_login/widgets/gradient_header.dart';
import 'widgets/captcha_widget.dart';
import 'widgets/custom_text_field.dart';
import '../signup/signup_screen.dart';
import '../../../models/auth/login_request.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  VoidCallback? _refreshCaptchaCallback;

  String _captchaId = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    _isLoading.dispose();
    _isPasswordVisible.dispose();
    super.dispose();
  }

  void _onCaptchaIdChanged(String captchaId) {
    setState(() {
      _captchaId = captchaId;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMinLength;
    }
    return null;
  }

  String? _validateCaptcha(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterCaptcha;
    }
    if (_captchaId.isEmpty) {
      return AppLocalizations.of(context)!.captchaNotLoaded;
    }
    return null;
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        final loginRequest = LoginRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          secureId: _captchaId,
          captchaText: _captchaController.text.trim(),
        );

        debugPrint('🔐 Attempting login with email: ${loginRequest.email}');
        debugPrint('🔐 Captcha ID: ${loginRequest.secureId}');
        debugPrint('🔐 Captcha Text: ${loginRequest.captchaText}');

        final success = await authProvider.login(loginRequest);

        if (mounted) {
          _isLoading.value = false;

          if (success) {
            debugPrint('✅ Login successful!');
            // Navigate to Bolo screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BoloContribute()),
            );
          } else {
            debugPrint('❌ Login failed: ${authProvider.errorMessage}');
            // Clear captcha input on failure
            _captchaController.clear();
            // Always refresh captcha on any API error (non-2xx status codes)
            _refreshCaptcha();
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.errorMessage ?? 'Login failed'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          _isLoading.value = false;
          debugPrint('❌ Login error: $e');
          // Clear captcha input on error
          _captchaController.clear();
          // Always refresh captcha on network/API errors
          _refreshCaptcha();

          // Extract clean error message
          String errorMessage = AppLocalizations.of(context)!.loginFailed;
          if (e is AuthException) {
            final message = e.message;
            if (message.startsWith('Status: ')) {
              final parts = message.split(' - ');
              if (parts.length > 1) {
                errorMessage = parts.sublist(1).join(' - ');
              } else {
                errorMessage = message;
              }
            } else {
              errorMessage = message;
            }
          } else {
            errorMessage = AppLocalizations.of(context)!.networkError;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  /// Refresh captcha when there's an API error
  void _refreshCaptcha() {
    debugPrint('🔄 Refreshing captcha due to API error...');
    // Use the callback to refresh captcha
    _refreshCaptchaCallback?.call();
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void _forgotPassword() {
    // Implement forgot password logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.forgotPassword),
        backgroundColor: AppColors.lightGreen,
      ),
    );
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
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                const GradientHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .loginIntoYourAccount,
                              style: GoogleFonts.notoSans(
                                color: AppColors.greys87,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 16.w),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.enterYour,
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.greys60,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .emailAndPassword,
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.greys60,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .toAccessYourAccount,
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.greys60,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32.w),

                            // Email Field
                            CustomTextField(
                              controller: _emailController,
                              label: '*Email ID',
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                            ),
                            SizedBox(height: 20.h),

                            // Password Field
                            ValueListenableBuilder<bool>(
                              valueListenable: _isPasswordVisible,
                              builder: (context, isPasswordVisible, child) {
                                return CustomTextField(
                                  controller: _passwordController,
                                  label: '*Password',
                                  obscureText: !isPasswordVisible,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _isPasswordVisible.value =
                                          !isPasswordVisible;
                                    },
                                    child: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.grey40,
                                      size: 20.sp,
                                    ),
                                  ),
                                  validator: _validatePassword,
                                );
                              },
                            ),
                            SizedBox(height: 20.h),

                            // CAPTCHA Section
                            CaptchaWidget(
                              controller: _captchaController,
                              onCaptchaIdChanged: _onCaptchaIdChanged,
                              validator: _validateCaptcha,
                              onRefreshCallbackRegistered: (callback) {
                                _refreshCaptchaCallback = callback;
                              },
                            ),
                            SizedBox(height: 20.h),

                            // Forgot Password and Sign Up Links
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: _forgotPassword,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .forgotPassword,
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.darkBlue,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .doesntHaveAccount,
                                      style: GoogleFonts.notoSans(
                                        color: AppColors.greys60,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _navigateToSignup,
                                      child: Text(
                                        AppLocalizations.of(context)!.signUp,
                                        style: GoogleFonts.notoSans(
                                          color: AppColors.darkBlue,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 40.w),
                  child: Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, child) {
                        return SizedBox(
                          width: 280.w,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.w),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.backgroundColor),
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!
                                        .login
                                        .toUpperCase(),
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.backgroundColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
