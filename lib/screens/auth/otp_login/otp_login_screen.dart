import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common_widgets/custom_app_bar.dart';
import '../../../config/branding_config.dart';
import '../../../constants/app_colors.dart';
import '../repository/login_auth_repository.dart';
import 'widgets/gradient_header.dart';
import 'widgets/phone_input_field.dart';
import 'otp_verification_screen.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isPhoneValid = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _isLoading.dispose();
    _isPhoneValid.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final phone = _phoneController.text;
    _isPhoneValid.value = phone.length == 10;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.invalidPhoneNumberMessage;
    }
    if (value.length != 10) {
      return AppLocalizations.of(context)!.phoneNumberMustBe10Digits;
    }
    return null;
  }

  Future<void> _requestOtp() async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;
      final String? message =
          await LoginAuthRepository().sendOtp(_phoneController.text, "+91");
      _isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message ?? 'Error occurred while sending OTP'),
        ),
      );
      if (message != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: _phoneController.text,
              countryCode: "+91",
            ),
          ),
        );
      }
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.verifyYourPhoneNumber,
                          style: BrandingConfig.instance.getPrimaryTextStyle(
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
                                text: AppLocalizations.of(context)!.weWillSendA,
                                style:
                                    BrandingConfig.instance.getPrimaryTextStyle(
                                  color: AppColors.greys60,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .oneTimePasswordOtp,
                                style:
                                    BrandingConfig.instance.getPrimaryTextStyle(
                                  color: AppColors.greys87,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .toThisMobileNumber,
                                style:
                                    BrandingConfig.instance.getPrimaryTextStyle(
                                  color: AppColors.greys60,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.w),
                        PhoneInputField(
                          controller: _phoneController,
                          validator: _validatePhoneNumber,
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
                  valueListenable: _isPhoneValid,
                  builder: (context, isPhoneValid, child) {
                    return SizedBox(
                      width: 280.w,
                      child: ElevatedButton(
                        onPressed: isPhoneValid ? _requestOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPhoneValid
                              ? AppColors.orange
                              : AppColors.grey40,
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
                                      AppColors.backgroundColor),
                                ),
                              );
                            }
                            return Text(
                              AppLocalizations.of(context)!.getOtp,
                              style:
                                  BrandingConfig.instance.getPrimaryTextStyle(
                                color: isPhoneValid
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
