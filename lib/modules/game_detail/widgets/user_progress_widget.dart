import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:game_notion/modules/game_detail/game_detail_controller.dart';
import 'package:game_notion/modules/game_detail/widgets/star_rating_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserProgressWidget extends StatefulWidget {
  final GameDetailController controller;

  const UserProgressWidget({super.key, required this.controller});

  @override
  State<UserProgressWidget> createState() => _UserProgressWidgetState();
}

class _UserProgressWidgetState extends State<UserProgressWidget> {
  final reviewController = new TextEditingController();
  late double _rating;

  @override
  initState() {
    reviewController.text = widget.controller.getSavedModel().userReview ?? '';
    _rating = widget.controller.getSavedModel().userRating ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final savedModel = widget.controller.getSavedModel();
      final isDark = Theme.of(context).brightness == Brightness.dark;

      final dateStarted = savedModel.dateStarted;
      final dateFinished = savedModel.dateFinished;
      final dateFormat = DateFormat('dd/MM/yyyy');

      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .cardColor
                  .withValues(alpha: isDark ? 0.4 : 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Meu Progresso',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber.withValues(alpha: 0.8),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                // Rating
                const Text(
                  'Minha Nota',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),
                StarRatingWidget(
                  rating: _rating,
                  onRatingChanged: (rating) {
                    setState(() => _rating = rating);
                    widget.controller.saveUserRating(rating);
                  },
                ),
                const SizedBox(height: 24),

                // Platform
                if (widget.controller.game.value?.platforms != null &&
                    widget.controller.game.value!.platforms.isNotEmpty) ...[
                  const Text(
                    'Jogado em',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        widget.controller.game.value!.platforms.map((platform) {
                      final isSelected =
                          savedModel.platformPlayed == platform.name;
                      return ChoiceChip(
                        label: Text(platform.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          widget.controller.savePlatformPlayed(
                              selected ? platform.name : null);
                        },
                        backgroundColor: Colors.transparent,
                        selectedColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Dates
                Row(
                  children: [
                    Expanded(
                      child: _DateButton(
                        label: 'Iniciado em',
                        date: dateStarted != null
                            ? dateFormat.format(dateStarted)
                            : 'Não definido',
                        icon: Icons.play_circle_outline,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            locale: Get.locale,
                            initialDate: dateStarted ?? DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            widget.controller.saveDateStarted(date);
                          }
                        },
                        onClear: dateStarted != null
                            ? () => widget.controller.saveDateStarted(null)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateButton(
                        label: 'Zerado em',
                        date: dateFinished != null
                            ? dateFormat.format(dateFinished)
                            : 'Não definido',
                        icon: Icons.check_circle_outline,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            locale: Get.locale,
                            initialDate:
                                dateFinished ?? dateStarted ?? DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            widget.controller.saveDateFinished(date);
                          }
                        },
                        onClear: dateFinished != null
                            ? () => widget.controller.saveDateFinished(null)
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Review
                const Text(
                  'Análise Pessoal',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: 8,
                  controller: reviewController,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'O que achou do jogo?',
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  child: const Text('Salvar'),
                  onPressed: () =>
                      widget.controller.saveUserReview(reviewController.text),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final String date;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateButton({
    required this.label,
    required this.date,
    required this.icon,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
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
                Icon(icon, size: 16, color: Theme.of(context).primaryColor),
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
                Text(
                  date,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
                if (onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    child:
                        const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
