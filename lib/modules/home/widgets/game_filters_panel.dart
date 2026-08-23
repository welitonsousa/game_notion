import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_notion/modules/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GameFiltersPanel extends StatelessWidget {
  final HomeController controller;
  const GameFiltersPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: isDark ? 0.4 : 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Obx(() {
              final filters = controller.filters.value;
              final genres = controller.availableGenres;
              final platforms = controller.availablePlatforms;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros avançados',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (!filters.isEmpty)
                        TextButton(
                          onPressed: controller.clearFilters,
                          child: const Text('Limpar'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (genres.isNotEmpty) ...[
                    const Text('Gêneros', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: genres.map((genre) {
                        final selected = filters.genres.contains(genre);
                        return FilterChip(
                          label: Text(genre),
                          selected: selected,
                          onSelected: (v) {
                            final updated = {...filters.genres};
                            v ? updated.add(genre) : updated.remove(genre);
                            controller.filters.value = filters.copyWith(genres: updated);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (platforms.isNotEmpty) ...[
                    const Text('Plataforma', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: platforms.map((platform) {
                        final selected = filters.platforms.contains(platform);
                        return FilterChip(
                          label: Text(platform),
                          selected: selected,
                          onSelected: (v) {
                            final updated = {...filters.platforms};
                            v ? updated.add(platform) : updated.remove(platform);
                            controller.filters.value = filters.copyWith(platforms: updated);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Minha nota', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        filters.ratingRange == null
                            ? 'Todas'
                            : '${filters.ratingRange!.start.toStringAsFixed(1)} - ${filters.ratingRange!.end.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  RangeSlider(
                    min: 0,
                    max: 5,
                    divisions: 10,
                    labels: RangeLabels(
                      (filters.ratingRange?.start ?? 0).toStringAsFixed(1),
                      (filters.ratingRange?.end ?? 5).toStringAsFixed(1),
                    ),
                    values: filters.ratingRange ?? const RangeValues(0, 5),
                    onChanged: (v) {
                      controller.filters.value = filters.copyWith(ratingRange: v);
                    },
                    onChangeEnd: (v) {
                      final isFull = v.start == 0 && v.end == 5;
                      controller.filters.value = filters.copyWith(
                        ratingRange: isFull ? null : v,
                        clearRatingRange: isFull,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _DateRangeButton(
                          label: 'Iniciado entre',
                          range: filters.dateStartedRange,
                          dateFormat: dateFormat,
                          onTap: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              locale: Get.locale,
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now(),
                              initialDateRange: filters.dateStartedRange,
                            );
                            if (picked != null) {
                              controller.filters.value =
                                  filters.copyWith(dateStartedRange: picked);
                            }
                          },
                          onClear: filters.dateStartedRange != null
                              ? () => controller.filters.value = filters.copyWith(
                                  clearDateStartedRange: true)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateRangeButton(
                          label: 'Zerado entre',
                          range: filters.dateFinishedRange,
                          dateFormat: dateFormat,
                          onTap: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              locale: Get.locale,
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now(),
                              initialDateRange: filters.dateFinishedRange,
                            );
                            if (picked != null) {
                              controller.filters.value =
                                  filters.copyWith(dateFinishedRange: picked);
                            }
                          },
                          onClear: filters.dateFinishedRange != null
                              ? () => controller.filters.value = filters.copyWith(
                                  clearDateFinishedRange: true)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _DateRangeButton extends StatelessWidget {
  final String label;
  final DateTimeRange? range;
  final DateFormat dateFormat;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateRangeButton({
    required this.label,
    required this.range,
    required this.dateFormat,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final text = range == null
        ? 'Qualquer data'
        : '${dateFormat.format(range!.start)} - ${dateFormat.format(range!.end)}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.date_range_rounded,
                    size: 16, color: Theme.of(context).primaryColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    child: const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
