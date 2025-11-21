import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/branding_config.dart';
import '../../../../constants/app_colors.dart';

class EmailOtpTimer extends StatefulWidget {
  final VoidCallback? onResend;
  final int initialSeconds;

  const EmailOtpTimer({
    super.key,
    this.onResend,
    this.initialSeconds = 120, // 2 minutes default for email OTP
  });

  @override
  State<EmailOtpTimer> createState() => _EmailOtpTimerState();
}

class _EmailOtpTimerState extends State<EmailOtpTimer> {
  Timer? _timer;
  late int _seconds;
  bool _canResend = false;
  bool _isResendCooldown = false;
  late int _resendCooldownSeconds;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
    _resendCooldownSeconds = 30; // 30 seconds cooldown for resend
    _startOtpTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startOtpTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _startResendCooldown() {
    setState(() {
      _isResendCooldown = true;
      _resendCooldownSeconds = 30;
      // Reset the OTP expiry timer when resending
      _seconds = widget.initialSeconds;
      _canResend = false;
    });

    // Start a combined timer that handles both countdowns
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Handle resend cooldown
        if (_isResendCooldown && _resendCooldownSeconds > 0) {
          _resendCooldownSeconds--;
        } else if (_isResendCooldown && _resendCooldownSeconds == 0) {
          _isResendCooldown = false;
        }

        // Handle OTP expiry timer
        if (_seconds > 0) {
          _seconds--;
        } else {
          _canResend = true;
        }
      });

      // Stop timer if both are done
      if (_canResend && !_isResendCooldown) {
        _timer?.cancel();
      }
    });
  }

  // void _resetTimer() {
  //   setState(() {
  //     _seconds = widget.initialSeconds;
  //     _canResend = false;
  //   });
  //   _startOtpTimer();
  // }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // OTP Expiry Timer
        if (!_canResend) ...[
          Text(
            "OTP expires in: ${_formatTime(_seconds)}",
            style: BrandingConfig.instance.getPrimaryTextStyle(
              color: AppColors.greys60,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],

        // Resend OTP Section - Always visible
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Didn't receive OTP? ",
              style: BrandingConfig.instance.getPrimaryTextStyle(
                color: AppColors.greys60,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: _isResendCooldown
                  ? null
                  : () {
                      widget.onResend?.call();
                      _startResendCooldown();
                    },
              child: Text(
                _isResendCooldown
                    ? "Resend OTP in ${_resendCooldownSeconds}s"
                    : "Resend OTP",
                style: BrandingConfig.instance.getPrimaryTextStyle(
                  color: _isResendCooldown
                      ? AppColors.greys60
                      : AppColors.darkBlue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
