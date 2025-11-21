import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/app_colors.dart';

class EmailOtpInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool enabled;

  const EmailOtpInputField({
    super.key,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  State<EmailOtpInputField> createState() => _EmailOtpInputFieldState();
}

class _EmailOtpInputFieldState extends State<EmailOtpInputField> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  String _otp = '';

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    _updateOtp();
  }

  void _updateOtp() {
    String newOtp = '';
    for (var controller in _controllers) {
      newOtp += controller.text;
    }
    
    if (newOtp != _otp) {
      _otp = newOtp;
      widget.onChanged(_otp);
    }
  }

  // void _onPaste(String value) {
  //   if (value.length == 6) {
  //     for (int i = 0; i < 6; i++) {
  //       _controllers[i].text = value[i];
  //     }
  //     _focusNodes[5].unfocus();
  //     _updateOtp();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.errorText != null 
                    ? AppColors.negativeLight 
                    : _focusNodes[index].hasFocus 
                      ? AppColors.lightGreen 
                      : AppColors.lightGrey,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6.r),
                color: Colors.white,
              ),
              child: Center(
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.enabled,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: GoogleFonts.notoSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greys87,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => _onTextChanged(value, index),
                  onTap: () {
                    if (_controllers[index].text.isEmpty) {
                      _controllers[index].selection = TextSelection.fromPosition(
                        TextPosition(offset: _controllers[index].text.length),
                      );
                    }
                  },
                ),
              ),
            );
          }),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 8.h),
          Text(
            widget.errorText!,
            style: GoogleFonts.notoSans(
              color: AppColors.negativeLight,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
