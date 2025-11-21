import 'package:VoiceGive/common_widgets/language_searchable_bottom_sheet/widgets/bottom_field_search_field.dart';
import 'package:VoiceGive/common_widgets/language_searchable_bottom_sheet/widgets/bottom_sheet_items.dart';
import 'package:VoiceGive/constants/app_colors.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSearchableBottomSheetContent extends StatefulWidget {
  final List<LanguageModel> items;
  final Function(LanguageModel) onItemSelected;
  final LanguageModel? defaultItem;
  final Future<List<LanguageModel>> Function(String)? onFetchMore;
  final bool hasMore;
  final String initialQuery;
  final BuildContext? parentContext;

  const LanguageSearchableBottomSheetContent({
    required this.items,
    required this.onItemSelected,
    required this.hasMore,
    required this.initialQuery,
    this.defaultItem,
    this.onFetchMore,
    this.parentContext,
    super.key,
  });

  @override
  State<LanguageSearchableBottomSheetContent> createState() =>
      _SearchableBottomSheetContentState();
}

class _SearchableBottomSheetContentState
    extends State<LanguageSearchableBottomSheetContent> {
  late final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchController =
      TextEditingController(text: widget.initialQuery);
  late final ValueNotifier<List<LanguageModel>> _filteredItems =
      ValueNotifier(_getProcessedItems(widget.items));

  List<LanguageModel> _allItems = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _allItems = List.from(widget.items);
    _hasMore = widget.hasMore;
    _currentQuery = widget.initialQuery;

    if (widget.onFetchMore != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _filteredItems.dispose();
    super.dispose();
  }

  List<LanguageModel> _getProcessedItems(List<LanguageModel> items) {
    if (widget.defaultItem != null) {
      final itemsWithoutDefault = items
          .where(
              (item) => item.languageCode != widget.defaultItem!.languageCode)
          .toList();
      return [...itemsWithoutDefault, widget.defaultItem!];
    }
    return items;
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        _hasMore &&
        !_isLoading &&
        widget.onFetchMore != null) {
      await _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() => _isLoading = true);
    try {
      final newItems = await widget.onFetchMore!(_currentQuery);
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        _allItems.addAll(newItems);
        _filteredItems.value = _getProcessedItems(_allItems);
      }
    } catch (_) {
      _hasMore = false;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onSearchChanged(String value) async {
    _currentQuery = value;
    if (widget.onFetchMore != null) {
      setState(() => _isLoading = true);
      try {
        final newItems = await widget.onFetchMore!(value);
        _allItems = newItems;
        _hasMore = newItems.isNotEmpty;
        _filteredItems.value = _getProcessedItems(_allItems);
      } catch (_) {
        _hasMore = false;
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      _performLocalSearch(value);
    }
  }

  void _performLocalSearch(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = widget.items
        .where((item) =>
            item.languageName.toLowerCase().contains(lowerQuery) ||
            item.nativeName.toLowerCase().contains(lowerQuery) ||
            item.languageCode.toLowerCase().contains(lowerQuery))
        .toList();

    _filteredItems.value = _getProcessedItems(filtered);
  }

  bool get _shouldShowSearch =>
      _allItems.length > 10 || widget.onFetchMore != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.7.sh,
      color: AppColors.backgroundColor,
      padding: EdgeInsets.all(16).r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_shouldShowSearch) ...[
            BottomSheetSearchField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              parentContext: widget.parentContext ?? context,
            ),
            SizedBox(height: 8.w),
          ],
          Flexible(
            child: ItemsList(
              filteredItems: _filteredItems,
              isLoading: _isLoading,
              scrollController: _scrollController,
              onItemSelected: widget.onItemSelected,
            ),
          ),
        ],
      ),
    );
  }
}
