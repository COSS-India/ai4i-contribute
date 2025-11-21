import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../config/branding_config.dart';

class ItemsList extends StatelessWidget {
  final ValueNotifier<List<LanguageModel>> filteredItems;
  final bool isLoading;
  final ScrollController scrollController;
  final Function(LanguageModel) onItemSelected;

  const ItemsList({
    super.key,
    required this.filteredItems,
    required this.isLoading,
    required this.scrollController,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<LanguageModel>>(
      valueListenable: filteredItems,
      builder: (context, filtered, _) {
        if (filtered.isEmpty && !isLoading) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.mStaticNoSearchResultFound,
              style: BrandingConfig.instance.getSecondaryTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: filtered.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == filtered.length && isLoading) {
              return Padding(
                padding: EdgeInsets.all(16.0).r,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -2),
              title: Text(filtered[index].languageName),
              textColor: AppColors.greys87,
              onTap: () {
                onItemSelected(filtered[index]);
                // Do not pop here; parent handles closing to avoid popping main route
              },
            );
          },
        );
      },
    );
  }
}
