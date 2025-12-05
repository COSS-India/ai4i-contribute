import 'package:VoiceGive/screens/profile_screen/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common_widgets/custom_app_bar.dart';
import '../../../config/branding_config.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/storage_constants.dart';
import '../../../services/secure_storage_service.dart';
import '../repository/login_auth_repository.dart';
import 'widgets/gradient_header.dart';
import 'widgets/otp_input_field.dart';
// OtpTimer will be inlined below

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const OtpVerificationScreen(
      {super.key, required this.phoneNumber, required this.countryCode});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // ---- OtpTimer widget code inlined below ----
  late Timer _otpTimer;
  late int _otpSeconds;
  bool _canResendOtp = false;

  final int _otpInitialSeconds = 180;

  @override
  void initState() {
    super.initState();
    _otpSeconds = _otpInitialSeconds;
    _startOtpTimer();
  }

  void _startOtpTimer() {
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpSeconds > 0) {
        setState(() {
          _otpSeconds--;
        });
      } else {
        setState(() {
          _canResendOtp = true;
        });
        _otpTimer.cancel();
      }
    });
  }

  void _resetOtpTimer() {
    setState(() {
      _otpSeconds = _otpInitialSeconds;
      _canResendOtp = false;
    });
    _startOtpTimer();
  }

  String _formatOtpTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Removed duplicate dispose method
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isOtpValid = ValueNotifier<bool>(false);
  String _otp = '';
  String? _errorText;

  @override
  void dispose() {
    _isLoading.dispose();
    _isOtpValid.dispose();
    try {
      _otpTimer.cancel();
    } catch (_) {}
    super.dispose();
  }

  void _onOtpChanged(String otp) {
    setState(() {
      _otp = otp;
      _errorText = null;
    });
    _isOtpValid.value = otp.length == 6;
  }

  Future<void> _verifyOtp() async {
    if (_otp.length == 6) {
      _isLoading.value = true;
      final sessionId = await SecureStorageService.instance.storage
              .read(key: StorageConstants.sessionId) ??
          '';
      dynamic userAuthData = await LoginAuthRepository()
          .verifyOtp(otp: _otp, sessionId: sessionId);
      _isLoading.value = false;
      // Navigate to Profile Screen
      if (userAuthData is String) {
        // An error occurred, show a snackbar with the error message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userAuthData),
          ),
        );
        return;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
                phoneNumber: widget.phoneNumber,
                countryCode: widget.countryCode),
          ),
        );
      }
    } else {
      setState(() {
        _errorText = AppLocalizations.of(context)!.invalidOtp;
      });
    }
  }

  Future<void> _resendOtp() async {
    final String? response = await LoginAuthRepository().resendOtp(
        mobileNo: widget.phoneNumber, countryCode: widget.countryCode);

    if (!mounted) return;

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.otpSentSuccessfullyMessage),
          backgroundColor: AppColors.lightGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while resending OTP'),
        ),
      );
    }
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
            const GradientHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      Text(
                        AppLocalizations.of(context)!.otpVerification,
                        style: BrandingConfig.instance.getPrimaryTextStyle(
                          color: AppColors.greys87,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Enter the OTP from the sms we sent\n to ",
                              style:
                                  BrandingConfig.instance.getPrimaryTextStyle(
                                color: AppColors.greys60,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "+91 ",
                              style:
                                  BrandingConfig.instance.getPrimaryTextStyle(
                                color: AppColors.greys60,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: widget.phoneNumber,
                              style:
                                  BrandingConfig.instance.getPrimaryTextStyle(
                                color: AppColors.greys60,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // OTP Timer and resend UI
                      if (!_canResendOtp) ...[
                        Text(
                          _formatOtpTime(_otpSeconds),
                          style: BrandingConfig.instance.getPrimaryTextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      SizedBox(height: 24.h),
                      OtpInputField(
                        onChanged: _onOtpChanged,
                        errorText: _errorText,
                      ),
                      SizedBox(height: 24.h),
                      if (_canResendOtp) ...[
                        GestureDetector(
                          onTap: () {
                            _resendOtp();
                            _resetOtpTimer();
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "I didn't receive any OTP. ",
                                  style: BrandingConfig.instance
                                      .getPrimaryTextStyle(
                                    color: AppColors.greys60,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: "RESEND",
                                  style: BrandingConfig.instance
                                      .getPrimaryTextStyle(
                                    color: AppColors.darkGreen,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
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
                    return SizedBox(
                      width: 280.w,
                      child: ElevatedButton(
                        onPressed: isOtpValid ? _verifyOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOtpValid
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
                            if (isLoading) {
                              return SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              );
                            }
                            return Text(
                              AppLocalizations.of(context)!.submit,
                              style:
                                  BrandingConfig.instance.getPrimaryTextStyle(
                                color: isOtpValid
                                    ? AppColors.backgroundColor
                                    : AppColors.grey40,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          },
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
    );
  }
}
