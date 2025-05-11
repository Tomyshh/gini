import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/people_provider.dart';
import '../constants/theme.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDarkMode ? AppTheme.tatooineGold : AppTheme.imperialBlue;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade900 : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _focusNode.hasFocus ? primaryColor : Colors.transparent,
            width: _focusNode.hasFocus ? 1.5 : 0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: _focusNode.hasFocus
                      ? primaryColor
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search for a character...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDarkMode
                          ? primaryColor
                          : theme.colorScheme.onSurface,
                    ),
                    onChanged: (query) {
                      if (query.length > 2 || query.isEmpty) {
                        peopleProvider.searchPeople(query);
                      }
                    },
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        HapticFeedback.lightImpact();
                        peopleProvider.searchPeople(query);
                      }
                    },
                    textInputAction: TextInputAction.search,
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: isDarkMode
                          ? primaryColor.withOpacity(0.7)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      peopleProvider.searchPeople('');
                      _focusNode.unfocus();
                    },
                    iconSize: 18,
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    tooltip: 'Clear',
                  ),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 200.ms),
    );
  }
}
