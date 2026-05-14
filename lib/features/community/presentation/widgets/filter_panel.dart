import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/models/community_model.dart';

class FilterPanel extends StatelessWidget {
  final CommunityFilters filters;
  final List<String> locations;
  final List<String> difficulties;
  final List<String> contentTypes;
  final List<String> sortOptions;
  final ValueChanged<CommunityFilters> onChanged;
  final VoidCallback onReset;

  const FilterPanel({
    super.key,
    required this.filters,
    required this.locations,
    required this.difficulties,
    required this.contentTypes,
    required this.sortOptions,
    required this.onChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Location',
            value: filters.location,
            items: locations,
            onChanged: (value) =>
                onChanged(filters.copyWith(location: value)),
          ),
          const SizedBox(height: 12),
          _DropdownField(
            label: 'Difficulty',
            value: filters.difficulty,
            items: difficulties,
            onChanged: (value) =>
                onChanged(filters.copyWith(difficulty: value)),
          ),
          const SizedBox(height: 12),
          _DropdownField(
            label: 'Content Type',
            value: filters.contentType,
            items: contentTypes,
            onChanged: (value) =>
                onChanged(filters.copyWith(contentType: value)),
          ),
          const SizedBox(height: 12),
          _DropdownField(
            label: 'Sort By',
            value: filters.sortBy,
            items: sortOptions,
            onChanged: (value) => onChanged(filters.copyWith(sortBy: value)),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onReset,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.divider),
              ),
              child: Center(
                child: Text(
                  'Reset Filters',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final allItems = ['All', ...items];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSub,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value ?? 'All',
          items: allItems
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            if (newValue == 'All') {
              onChanged(null);
            } else {
              onChanged(newValue);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.glacierWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
