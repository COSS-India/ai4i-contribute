import 'package:VoiceGive/common_widgets/page_loader.dart';
import 'package:VoiceGive/constants/helper.dart';
import 'package:VoiceGive/models/auth/consent_response.dart';
import 'package:VoiceGive/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../config/branding_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class InformedConsentModal extends StatefulWidget {
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const InformedConsentModal({
    super.key,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  State<InformedConsentModal> createState() => _InformedConsentModalState();
}

class _InformedConsentModalState extends State<InformedConsentModal> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _copyrightAccepted = false;
  final ValueNotifier<bool> isAcceptingConsent = ValueNotifier<bool>(false);

  bool get _allAccepted =>
      _termsAccepted && _privacyAccepted && _copyrightAccepted;

  Future<void> _acceptConsent() async {
    try {
      isAcceptingConsent.value = true;
      ConsentResponse? response = await AuthService.acceptConsent(
          termsAccepted: true, privacyAccepted: true, copyrightAccepted: true);
      if (response.success) {
        widget.onApprove();
      } else {
        Helper.showSnackBarMessage(
            context: context,
            bgColor: AppColors.negativeLight,
            text: response.message ?? AppLocalizations.of(context)!.errorDesc);
      }
      isAcceptingConsent.value = false;
    } catch (e) {
      isAcceptingConsent.value = false;
      Helper.showSnackBarMessage(
          context: context,
          bgColor: AppColors.negativeLight,
          text: AppLocalizations.of(context)!.errorDesc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 24.w, 16.w, 20.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onDeny,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20.w,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.weRespectYourPrivacy,
                        style: GoogleFonts.notoSans(
                          color: AppColors.darkGreen,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w), // To balance the back button
                ],
              ),
            ),

            // Fixed Content
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.namasteContributor,
                        style: GoogleFonts.notoSans(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        AppLocalizations.of(context)!.namasteEmoji,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.w),

                  // Introduction paragraph
                  Text(
                    AppLocalizations.of(context)!.consentMessage,
                    style: GoogleFonts.notoSans(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20.w),
                ],
              ),
            ),

            // Scrollable Content - Only the green container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.lightGreen2,
                      Colors.white,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.consentConfirm(
                            AppLocalizations.of(context)!.iAgree),
                        style: GoogleFonts.notoSans(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.w),

                      // Numbered list
                      _buildNumberedItem(
                        "1.",
                        AppLocalizations.of(context)!.consentPoint1,
                      ),
                      SizedBox(height: 12.w),

                      _buildNumberedItem(
                        "2.",
                        AppLocalizations.of(context)!.consentPoint2,
                      ),
                      SizedBox(height: 12.w),

                      _buildNumberedItem(
                        "3.",
                        AppLocalizations.of(context)!.consentPoint3,
                      ),
                      SizedBox(height: 12.w),

                      _buildNumberedItem(
                        "4.",
                        AppLocalizations.of(context)!.consentPoint4,
                      ),
                      SizedBox(height: 12.w),

                      _buildNumberedItem(
                        "5.",
                        AppLocalizations.of(context)!.consentPoint5,
                      ),
                      SizedBox(height: 16.w),

                      // Checkboxes for documents
                      _buildCheckboxItem(
                        AppLocalizations.of(context)!.termsOfUse,
                        _termsAccepted,
                        (value) => setState(() => _termsAccepted = value!),
                        url: BrandingConfig.instance.termsOfUseUrl,
                      ),
                      SizedBox(height: 8.w),

                      _buildCheckboxItem(
                        AppLocalizations.of(context)!.privacyPolicy,
                        _privacyAccepted,
                        (value) => setState(() => _privacyAccepted = value!),
                        url: BrandingConfig.instance.privacyPolicyUrl,
                      ),
                      SizedBox(height: 8.w),

                      _buildCheckboxItem(
                        AppLocalizations.of(context)!.copyrightPolicy,
                        _copyrightAccepted,
                        (value) => setState(() => _copyrightAccepted = value!),
                        url: BrandingConfig.instance.copyrightPolicyUrl,
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
              child: Row(
                children: [
                  Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: isAcceptingConsent,
                          builder: (BuildContext context, bool loading,
                              Widget? child) {
                            return GestureDetector(
                              onTap: () {
                                if (_allAccepted && !loading) _acceptConsent();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.w),
                                decoration: BoxDecoration(
                                  color: _allAccepted
                                      ? AppColors.orange
                                      : AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (loading)
                                      SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: PageLoader(
                                          strokeWidth: 2,
                                          isLightTheme: false,
                                        ),
                                      ),
                                    if (!loading) ...[
                                      Icon(
                                        Icons.check,
                                        color: _allAccepted
                                            ? Colors.white
                                            : AppColors.grey84,
                                        size: 18.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        AppLocalizations.of(context)!.iAgree,
                                        style: GoogleFonts.notoSans(
                                          color: _allAccepted
                                              ? Colors.white
                                              : AppColors.grey84,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          })),
                  SizedBox(width: 20.h),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onDeny,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.lightGrey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              color: AppColors.grey84,
                              size: 18.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              AppLocalizations.of(context)!.deny,
                              style: GoogleFonts.notoSans(
                                color: AppColors.grey84,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberedItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.notoSans(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxItem(
      String text, bool value, ValueChanged<bool?> onChanged, {String? url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          InkWell(
            onTap: () => onChanged(!value),
            borderRadius: BorderRadius.circular(4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value ? AppColors.darkGreen : AppColors.lightBackground,
                border: Border.all(
                  color: AppColors.darkGreen,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: url != null && url.isNotEmpty ? () => _launchUrl(url) : null,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGreen,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Fallback: try without canLaunchUrl check
      try {
        final Uri uri = Uri.parse(url);
        await launchUrl(uri);
      } catch (e) {
        // Silent fail - URL couldn't be opened
      }
    }
  }
}
