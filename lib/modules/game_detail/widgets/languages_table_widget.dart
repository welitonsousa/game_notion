import 'package:flutter/material.dart';
import 'package:game_notion/models/language_support_model.dart';

class LanguagesTableWidget extends StatefulWidget {
  final List<LanguageSupportModel> languageSupports;
  const LanguagesTableWidget({super.key, required this.languageSupports});

  @override
  State<LanguagesTableWidget> createState() => _LanguagesTableWidgetState();
}

class _LanguagesTableWidgetState extends State<LanguagesTableWidget> {
  static const _collapsedCount = 5;
  static const _columnOrder = ['Audio', 'Subtitles', 'Interface'];
  static const _columnLabels = {
    'Audio': 'Áudio',
    'Subtitles': 'Legendas',
    'Interface': 'Interface',
  };

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final byLanguage = <String, Set<String>>{};
    for (final item in widget.languageSupports) {
      byLanguage.putIfAbsent(item.language, () => {}).add(item.supportType);
    }
    if (byLanguage.isEmpty) return const SizedBox.shrink();

    final languages = byLanguage.keys.toList()..sort();
    final allTypes = <String>{for (final types in byLanguage.values) ...types};
    final columns = [
      ..._columnOrder.where(allTypes.contains),
      ...allTypes.where((t) => !_columnOrder.contains(t)).toList()..sort(),
    ];

    final visibleLanguages =
        _expanded ? languages : languages.take(_collapsedCount).toList();
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: {
            0: const FlexColumnWidth(2),
            for (var i = 0; i < columns.length; i++) i + 1: const FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                const SizedBox(),
                for (final column in columns)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      _columnLabels[column] ?? column,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
              ],
            ),
            for (final language in visibleLanguages)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(language, style: const TextStyle(fontSize: 13)),
                  ),
                  for (final column in columns)
                    Center(
                      child: byLanguage[language]!.contains(column)
                          ? Icon(Icons.check_rounded, size: 18, color: primaryColor)
                          : const SizedBox(),
                    ),
                ],
              ),
          ],
        ),
        if (languages.length > _collapsedCount)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded
                    ? 'Mostrar menos'
                    : 'Mostrar todos os ${languages.length} idiomas suportados',
              ),
            ),
          ),
      ],
    );
  }
}
