import 'package:VoiceGive/config/branding_config.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemsList extends StatelessWidget {
  final ValueNotifier<List<String>> filteredItems;
  final bool isLoading;
  final ScrollController scrollController;
  final Function(String) onItemSelected;

  const ItemsList({
    super.key,
    required this.filteredItems,
    required this.isLoading,
    required this.scrollController,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: filteredItems,
      builder: (context, filtered, _) {
        if (filtered.isEmpty && !isLoading) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.mStaticNoSearchResultFound,
              style: BrandingConfig.instance.getSecondaryTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greys87,
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
              title: Text(filtered[index],
                  style: BrandingConfig.instance.getSecondaryTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greys87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
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
