import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common_widgets/custom_app_bar.dart';
import '../../../constants/app_colors.dart';
import '../../home_screen/home_screen.dart';
import '../otp_login/widgets/gradient_header.dart';
import '../login/widgets/custom_text_field.dart';
import '../login/login_screen.dart';
import 'email_otp_verification_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isTermsAccepted = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _isLoading.dispose();
    _isPasswordVisible.dispose();
    _isTermsAccepted.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!
          .emailRequired; // Using emailRequired as generic required field
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
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
    if (value.length < 8) {
      return AppLocalizations.of(context)!.passwordMinLength;
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return AppLocalizations.of(context)!.passwordComplexity;
    }
    return null;
  }

  void _createAccount() {
    if (_formKey.currentState!.validate() && _isTermsAccepted.value) {
      _isLoading.value = true;
      // TODO: Implement account creation logic
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _isLoading.value = false;
          // Navigate to OTP verification screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmailOtpVerificationScreen(
                email: _emailController.text,
              ),
            ),
          );
        }
      });
    } else if (!_isTermsAccepted.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.acceptTermsAndConditions),
          backgroundColor: AppColors.negativeLight,
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _openTermsAndConditions() {
    // TODO: Implement terms and conditions page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(AppLocalizations.of(context)!.termsAndConditionsComingSoon),
        backgroundColor: AppColors.lightGreen,
      ),
    );
  }

  void _openPrivacyPolicy() {
    // TODO: Implement privacy policy page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.privacyPolicyComingSoon),
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
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: Column(
              children: [
                GradientHeader(title: AppLocalizations.of(context)!.signUp),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with close button and sign in link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .alreadyHaveAccount,
                                  style: GoogleFonts.notoSans(
                                    color: AppColors.greys60,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _navigateToLogin,
                                  child: Text(
                                    AppLocalizations.of(context)!.signIn,
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.darkBlue,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            // Title
                            Text(
                              AppLocalizations.of(context)!
                                  .createBhashaDaanAccount,
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
                                    text: AppLocalizations.of(context)!
                                        .fillInYour,
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.greys60,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .personalDetails,
                                    style: GoogleFonts.notoSans(
                                      color: AppColors.greys60,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .toCreateYourAccount,
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

                            // Name Field
                            CustomTextField(
                              controller: _nameController,
                              label: '*Name',
                              validator: _validateName,
                            ),
                            SizedBox(height: 20.h),

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

                            // Terms and Conditions Checkbox
                            ValueListenableBuilder<bool>(
                              valueListenable: _isTermsAccepted,
                              builder: (context, isTermsAccepted, child) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _isTermsAccepted.value =
                                            !isTermsAccepted;
                                      },
                                      child: Container(
                                        width: 20.w,
                                        height: 20.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isTermsAccepted
                                                ? AppColors.darkBlue
                                                : AppColors.lightGrey,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: isTermsAccepted
                                              ? AppColors.darkBlue
                                              : Colors.white,
                                        ),
                                        child: isTermsAccepted
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 14.sp,
                                              )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'I agree with the ',
                                              style: GoogleFonts.notoSans(
                                                color: AppColors.greys60,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: GestureDetector(
                                                onTap: _openTermsAndConditions,
                                                child: Text(
                                                  'Terms & Conditions',
                                                  style: GoogleFonts.notoSans(
                                                    color: AppColors.darkBlue,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' and the ',
                                              style: GoogleFonts.notoSans(
                                                color: AppColors.greys60,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: GestureDetector(
                                                onTap: _openPrivacyPolicy,
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .privacyPolicyComingSoon,
                                                  style: GoogleFonts.notoSans(
                                                    color: AppColors.darkBlue,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 40.h),
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
                            onPressed: isLoading ? null : _createAccount,
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
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.signUp,
                                    style: GoogleFonts.notoSans(
                                      color: Colors.white,
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
