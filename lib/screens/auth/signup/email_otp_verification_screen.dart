import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_widgets/custom_app_bar.dart';
import '../../../config/branding_config.dart';
import '../../../constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../profile_screen/screens/profile_screen.dart';
import '../otp_login/widgets/gradient_header.dart';
import 'widgets/captcha_widget.dart';
import 'widgets/email_otp_timer.dart';
import 'widgets/email_otp_input_field.dart';

class EmailOtpVerificationScreen extends StatefulWidget {
  final String email;

  const EmailOtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailOtpVerificationScreen> createState() =>
      _EmailOtpVerificationScreenState();
}

class _EmailOtpVerificationScreenState
    extends State<EmailOtpVerificationScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isOtpValid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isCaptchaValid = ValueNotifier<bool>(false);
  final TextEditingController _captchaController = TextEditingController();
  String? _otpErrorText;
  String _captchaText = '';
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  @override
  void dispose() {
    _captchaController.dispose();
    _isLoading.dispose();
    _isOtpValid.dispose();
    _isCaptchaValid.dispose();
    super.dispose();
  }

  void _generateCaptcha() {
    // Generate a random 4-character CAPTCHA
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    _captchaText = '';
    for (int i = 0; i < 4; i++) {
      _captchaText +=
          chars[(DateTime.now().millisecondsSinceEpoch + i) % chars.length];
    }
    setState(() {});
  }

  void _onOtpChanged(String otp) {
    setState(() {
      _otp = otp;
      _otpErrorText = null;
    });
    _isOtpValid.value = otp.length == 6;
    _checkFormValidity();
  }

  void _onCaptchaChanged(String captcha) {
    _isCaptchaValid.value = captcha.toLowerCase() == _captchaText.toLowerCase();
    _checkFormValidity();
  }

  void _checkFormValidity() {
    // This will be called when either OTP or CAPTCHA changes
    // The verify button will be enabled when both are valid
  }

  String? _validateCaptcha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the CAPTCHA';
    }
    if (value.toLowerCase() != _captchaText.toLowerCase()) {
      return 'Please enter the correct CAPTCHA';
    }
    return null;
  }

  void _verifyOtp() {
    if (_otp.length == 6 &&
        _captchaController.text.toLowerCase() == _captchaText.toLowerCase()) {
      _isLoading.value = true;
      // TODO: Implement OTP verification logic
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _isLoading.value = false;
          // Navigate to Profile Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        }
      });
    } else {
      setState(() {
        if (_otp.length != 6) {
          _otpErrorText = 'Please enter a valid 6-digit OTP';
        }
      });
    }
  }

  void _resendOtp() {
    // TODO: Implement resend OTP logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP sent successfully to ${widget.email}'),
        backgroundColor: AppColors.lightGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.verifyOtp,
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                          color: AppColors.greys87,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        AppLocalizations.of(context)!.otpSentToMail,
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                          color: AppColors.greys60,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),

                      // OTP Input Field
                      EmailOtpInputField(
                        onChanged: _onOtpChanged,
                        errorText: _otpErrorText,
                      ),

                      SizedBox(height: 16.h),

                      // OTP Timer
                      EmailOtpTimer(
                        onResend: _resendOtp,
                      ),

                      SizedBox(height: 24.h),

                      // CAPTCHA Section
                      CaptchaWidget(
                        captchaText: _captchaText,
                        onRefresh: _generateCaptcha,
                        onChanged: _onCaptchaChanged,
                        validator: _validateCaptcha,
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 40.w),
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isOtpValid,
                  builder: (context, isOtpValid, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isCaptchaValid,
                      builder: (context, isCaptchaValid, child) {
                        final isFormValid = isOtpValid && isCaptchaValid;
                        return SizedBox(
                          width: 280.w,
                          child: ElevatedButton(
                            onPressed: isFormValid ? _verifyOtp : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFormValid
                                  ? AppColors.orange
                                  : AppColors.lightGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.w),
                            ),
                            child: ValueListenableBuilder<bool>(
                              valueListenable: _isLoading,
                              builder: (context, isLoading, child) {
                                return isLoading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Verify OTP',
                                        style: BrandingConfig.instance
                                            .getPrimaryTextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
