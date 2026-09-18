import 'package:ai4i_contribute/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomSheetSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final BuildContext parentContext;

  const BottomSheetSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(parentContext)!.mStaticSearch,
        hintStyle: Theme.of(context).textTheme.labelLarge,
        prefixIcon: Icon(Icons.search, color: AppColors.darkGreen),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(63).r,
          borderSide: BorderSide(color: AppColors.darkGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(63).r,
          borderSide: BorderSide(color: AppColors.darkGreen),
        ),
      ),
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: AppColors.greys),
      onChanged: onChanged,
    );
  }
}
