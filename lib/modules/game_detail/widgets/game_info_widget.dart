import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game_notion/models/game_model.dart';
import 'package:intl/intl.dart';

class GameInfoWidget extends StatelessWidget {
  final GameModel game;
  const GameInfoWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeToBeat = game.timeToBeat;
    final hasTimeToBeat = timeToBeat != null && !timeToBeat.isEmpty;
    final rating = game.aggregatedRating ?? game.rating;

    final hasAnything = game.firstReleaseDate != null ||
        rating != null ||
        game.genres.isNotEmpty ||
        game.developers.isNotEmpty ||
        game.publishers.isNotEmpty ||
        game.gameModes.isNotEmpty ||
        hasTimeToBeat;

    if (!hasAnything) return const SizedBox.shrink();

    return ClipRRect(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _InfoGrid(
                tiles: [
                  if (game.firstReleaseDate != null)
                    _InfoTile(
                      icon: Icons.calendar_today_rounded,
                      label: 'Lançamento',
                      value: DateFormat('dd/MM/yyyy').format(game.firstReleaseDate!),
                    ),
                  if (rating != null)
                    _InfoTile(
                      icon: Icons.star_rounded,
                      label: 'Nota IGDB',
                      value: '${rating.round()}/100',
                    ),
                  if (game.developers.isNotEmpty)
                    _InfoTile(
                      icon: Icons.code_rounded,
                      label: 'Desenvolvedora',
                      value: game.developers.join(', '),
                    ),
                  if (game.publishers.isNotEmpty)
                    _InfoTile(
                      icon: Icons.business_rounded,
                      label: 'Publicadora',
                      value: game.publishers.join(', '),
                    ),
                ],
              ),
              if (hasTimeToBeat) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Duração estimada',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (timeToBeat.count != null && timeToBeat.count! > 0)
                      Text(
                        'baseado em ${timeToBeat.count} jogadores',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (timeToBeat.hastily != null)
                      Expanded(
                        child: _DurationTile(
                          label: 'História',
                          hours: timeToBeat.hastily!,
                          icon: Icons.menu_book_rounded,
                        ),
                      ),
                    if (timeToBeat.hastily != null) const SizedBox(width: 12),
                    if (timeToBeat.normally != null)
                      Expanded(
                        child: _DurationTile(
                          label: 'História + Secundárias',
                          hours: timeToBeat.normally!,
                          icon: Icons.timer_outlined,
                        ),
                      ),
                    if (timeToBeat.normally != null) const SizedBox(width: 12),
                    if (timeToBeat.completely != null)
                      Expanded(
                        child: _DurationTile(
                          label: 'Completo',
                          hours: timeToBeat.completely!,
                          icon: Icons.emoji_events_outlined,
                        ),
                      ),
                  ],
                ),
              ],
              if (game.genres.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Gêneros',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: game.genres
                      .map((e) => Chip(label: Text(e)))
                      .toList(),
                ),
              ],
              if (game.gameModes.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Modos de jogo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: game.gameModes
                      .map((e) => Chip(label: Text(e)))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<Widget> tiles;
  const _InfoGrid({required this.tiles});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      final hasPair = i + 1 < tiles.length;
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 16));
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: tiles[i]),
            const SizedBox(width: 16),
            Expanded(child: hasPair ? tiles[i + 1] : const SizedBox.shrink()),
          ],
        ),
      );
    }

    return Column(children: rows);
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }
}

class _DurationTile extends StatelessWidget {
  final String label;
  final double hours;
  final IconData icon;

  const _DurationTile({required this.label, required this.hours, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(height: 6),
          Text(
            '${hours.round()}h',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
