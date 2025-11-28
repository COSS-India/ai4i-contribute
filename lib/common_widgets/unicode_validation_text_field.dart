import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/config/branding_config.dart';

class UnicodeValidationTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String languageCode;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(bool)? onValidationChanged;
  final int? maxLines;
  final bool enabled;

  const UnicodeValidationTextField({
    super.key,
    this.hintText,
    this.labelText,
    required this.languageCode,
    this.controller,
    this.onChanged,
    this.onValidationChanged,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  State<UnicodeValidationTextField> createState() =>
      _UnicodeValidationTextFieldState();
}

class _UnicodeValidationTextFieldState
    extends State<UnicodeValidationTextField> {
  late TextEditingController _controller;
  String? _errorMessage;

  // Language code to name mapping
  static const Map<String, String> _languageNames = {
    'hi': 'Hindi',
    'bn': 'Bengali',
    'te': 'Telugu',
    'mr': 'Marathi',
    'ta': 'Tamil',
    'gu': 'Gujarati',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'pa': 'Punjabi',
    'or': 'Odia',
    'as': 'Assamese',
    'ur': 'Urdu',
    'sa': 'Sanskrit',
    'ne': 'Nepali',
    'si': 'Sinhala',
    'my': 'Myanmar',
    'bo': 'Tibetan',
    'dz': 'Dzongkha',
    'ks': 'Kashmiri',
    'sd': 'Sindhi',
    'mai': 'Maithili',
    'sat': 'Santali',
    'en': 'English',
  };

  // Unicode ranges for Indian languages with comprehensive coverage
  static const Map<String, List<List<int>>> _languageUnicodeRanges = {
    'hi': [
      [0x0900, 0x097F],
      [0xA8E0, 0xA8FF]
    ], // Hindi (Devanagari + Extended)
    'bn': [
      [0x0980, 0x09FF]
    ], // Bengali
    'te': [
      [0x0C00, 0x0C7F]
    ], // Telugu
    'mr': [
      [0x0900, 0x097F],
      [0xA8E0, 0xA8FF]
    ], // Marathi (Devanagari + Extended)
    'ta': [
      [0x0B80, 0x0BFF]
    ], // Tamil
    'gu': [
      [0x0A80, 0x0AFF]
    ], // Gujarati
    'kn': [
      [0x0C80, 0x0CFF]
    ], // Kannada
    'ml': [
      [0x0D00, 0x0D7F]
    ], // Malayalam
    'pa': [
      [0x0A00, 0x0A7F]
    ], // Punjabi (Gurmukhi)
    'or': [
      [0x0B00, 0x0B7F]
    ], // Odia
    'as': [
      [0x0980, 0x09FF]
    ], // Assamese (Bengali script)
    'ur': [
      [0x0600, 0x06FF],
      [0x0750, 0x077F],
      [0xFB50, 0xFDFF],
      [0xFE70, 0xFEFF]
    ], // Urdu (Arabic + supplements)
    'sa': [
      [0x0900, 0x097F],
      [0xA8E0, 0xA8FF]
    ], // Sanskrit (Devanagari + Extended)
    'ne': [
      [0x0900, 0x097F],
      [0xA8E0, 0xA8FF]
    ], // Nepali (Devanagari + Extended)
    'si': [
      [0x0D80, 0x0DFF]
    ], // Sinhala
    'my': [
      [0x1000, 0x109F],
      [0xAA60, 0xAA7F]
    ], // Myanmar + Extended
    'bo': [
      [0x0F00, 0x0FFF]
    ], // Tibetan
    'dz': [
      [0x0F00, 0x0FFF]
    ], // Dzongkha (Tibetan script)
    'ks': [
      [0x0600, 0x06FF],
      [0x0750, 0x077F]
    ], // Kashmiri (Arabic + supplement)
    'sd': [
      [0x0600, 0x06FF],
      [0x0750, 0x077F]
    ], // Sindhi (Arabic + supplement)
    'mai': [
      [0x0900, 0x097F],
      [0xA8E0, 0xA8FF]
    ], // Maithili (Devanagari + Extended)
    'sat': [
      [0x1C50, 0x1C7F]
    ], // Santali (Ol Chiki)
    'en': [
      [0x0041, 0x005A],
      [0x0061, 0x007A]
    ], // English (A-Z, a-z only)
  };

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool _isCharacterValid(String character, String languageCode) {
    if (character.isEmpty) return true;

    final codePoint = character.runes.first;

    // Always allow whitespace and basic punctuation
    if (_isCommonCharacter(codePoint)) {
      return true;
    }

    final ranges = _languageUnicodeRanges[languageCode];
    if (ranges == null) return true;

    for (final range in ranges) {
      if (codePoint >= range[0] && codePoint <= range[1]) {
        return true;
      }
    }
    return false;
  }

  bool _isCommonCharacter(int codePoint) {
    return (
            // Whitespace characters (excluding newlines for sentence input)
            codePoint == 0x0020 || // Space
                // Numbers
                (codePoint >= 0x0030 && codePoint <= 0x0039) || // 0-9
                // Common punctuation
                codePoint == 0x002E || // Period
                codePoint == 0x002C || // Comma
                codePoint == 0x003F || // Question mark
                codePoint == 0x0021 || // Exclamation mark
                codePoint == 0x003A || // Colon
                codePoint == 0x003B || // Semicolon
                codePoint == 0x0027 || // Apostrophe
                codePoint == 0x0022 || // Quotation mark
                codePoint == 0x0028 || // Left parenthesis
                codePoint == 0x0029 || // Right parenthesis
                codePoint == 0x002D // Hyphen-minus
        );
  }

  String? _validateText(String text) {
    if (text.isEmpty) return null;

    final invalidChars = <String>[];
    final runes = text.runes.toList();
    bool hasControlChars = false;
    bool hasOtherLanguage = false;

    for (final rune in runes) {
      final char = String.fromCharCode(rune);
      if (!_isCharacterValid(char, widget.languageCode)) {
        if (!invalidChars.contains(char)) {
          invalidChars.add(char);
        }

        // Check if it's a control character (like Enter, Tab, etc.)
        if (rune < 0x0020 &&
            rune != 0x0009 &&
            rune != 0x000A &&
            rune != 0x000D) {
          hasControlChars = true;
        } else if (rune >= 0x0020) {
          hasOtherLanguage = true;
        }
      }
    }

    if (invalidChars.isNotEmpty) {
      if (hasControlChars) {
        return 'Special characters not allowed';
      } else if (hasOtherLanguage) {
        return 'Please type in your chosen language';
      } else {
        return 'Invalid characters entered';
      }
    }
    return null;
  }

  void _onTextChanged(String value) {
    final newErrorMessage = _validateText(value);
    final hasError = newErrorMessage != null;

    setState(() {
      _errorMessage = newErrorMessage;
    });

    widget.onChanged?.call(value);
    widget.onValidationChanged?.call(hasError);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8).r,
            color: Colors.white,
          ),
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            onChanged: _onTextChanged,
            style: BrandingConfig.instance.getPrimaryTextStyle(
              fontSize: 16.sp,
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              hintStyle: BrandingConfig.instance.getPrimaryTextStyle(
                fontSize: 14.sp,
                color: AppColors.darkGreen,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: AppColors.lightGreen1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.lightGreen5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.lightGreen5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.lightGreen5,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        if (_errorMessage != null) ...[
          SizedBox(height: 4.h),
          Text(
            _errorMessage!,
            style: BrandingConfig.instance.getPrimaryTextStyle(
              fontSize: 12.sp,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
