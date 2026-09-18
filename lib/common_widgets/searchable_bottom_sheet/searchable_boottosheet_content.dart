import 'package:ai4i_contribute/common_widgets/searchable_bottom_sheet/widgets/bottom_field_search_field.dart';
import 'package:ai4i_contribute/common_widgets/searchable_bottom_sheet/widgets/bottom_sheet_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class SearchableBottomSheetContent extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelected;
  final String? defaultItem;
  final Future<List<String>> Function(String)? onFetchMore;
  final bool hasMore;
  final String initialQuery;
  final BuildContext? parentContext;

  const SearchableBottomSheetContent({
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
  State<SearchableBottomSheetContent> createState() =>
      _SearchableBottomSheetContentState();
}

class _SearchableBottomSheetContentState
    extends State<SearchableBottomSheetContent> {
  late final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchController =
      TextEditingController(text: widget.initialQuery);
  late final ValueNotifier<List<String>> _filteredItems =
      ValueNotifier(_getProcessedItems(widget.items));

  List<String> _allItems = [];
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

  List<String> _getProcessedItems(List<String> items) {
    if (widget.defaultItem?.isNotEmpty == true) {
      final itemsWithoutDefault =
          items.where((item) => item != widget.defaultItem).toList();
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
        .where((item) => item.toLowerCase().contains(lowerQuery))
        .toList();

    _filteredItems.value = _getProcessedItems(filtered);
  }

  bool get _shouldShowSearch =>
      _allItems.length > 10 || widget.onFetchMore != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.close, color: AppColors.darkGreen),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          height: 0.7.sh,
          padding: const EdgeInsets.all(16).r,
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
              )),
            ],
          ),
        ),
      ],
    );
  }
}
