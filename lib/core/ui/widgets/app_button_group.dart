import 'package:flutter/material.dart';
import 'package:get/utils.dart';

/// AppButtonGroup
///
/// example:
///
/// ```dart
/// AppButtonGroup<String>(
///   callback: (v) {},
///   values: const ['Test 1', 'Test 2', 'Test 3', 'Test 4'],
///   initial: const [],
/// ),
///
class AppButtonGroup<T> extends StatefulWidget {
  final void Function(List<T>) callback;
  final List<T> values;
  final List<T> initial;
  final bool multiple;
  final bool updateSelectionOnInitialChange;
  final bool allowEmpty;
  final Widget Function(T)? itemBuilder;

  /// AppButtonGroup
  ///
  /// example:
  ///
  /// ```dart
  /// AppButtonGroup<String>(
  ///   callback: (v) {},
  ///   values: const ['Test 1', 'Test 2', 'Test 3', 'Test 4'],
  ///   initial: const [],
  /// ),
  ///
  /// ```
  const AppButtonGroup({
    super.key,
    required this.callback,
    required this.values,
    required this.initial,
    this.multiple = true,
    this.itemBuilder,
    this.updateSelectionOnInitialChange = true,
    this.allowEmpty = true,
  });

  @override
  State<AppButtonGroup<T>> createState() => _AppButtonGroupState<T>();
}

class _AppButtonGroupState<T> extends State<AppButtonGroup<T>> {
  final selectees = <T>[];

  @override
  void initState() {
    selectees.clear();
    selectees.addAll(widget.initial);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButtonGroup<T> oldWidget) {
    if (widget.updateSelectionOnInitialChange) {
      selectees.clear();
      selectees.addAll(widget.initial);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _toggleSelect(T item) {
    if (selectees.contains(item)) {
      if ((selectees.length > 1 && !widget.allowEmpty) || widget.allowEmpty) {
        selectees.remove(item);
      }
    } else {
      if (widget.multiple) {
        selectees.add(item);
      } else {
        selectees.clear();
        selectees.addAll([item]);
      }
    }
    setState(() {
      widget.callback.call(selectees);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        runSpacing: 20,
        spacing: 8,
        children: widget.values.map((item) {
          final isSelected = selectees.contains(item);
          return InkWell(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: context.theme.textButtonTheme.style?.foregroundColor?.resolve({}) ?? Colors.black),
                  borderRadius: BorderRadius.circular(50),
                  color: isSelected
                      ?context.theme.textButtonTheme.style?.foregroundColor?.resolve({})?.withOpacity(0.3) ?? Colors.black.withOpacity(0.3)
                      : context.theme.primaryColor.withOpacity(0.3),
                ),
                child: widget.itemBuilder?.call(item) ??
                    Text(
                      item.toString(),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isSelected ? context.theme.textButtonTheme.style?.foregroundColor?.resolve({}) ?? Colors.black : null,
                      ),
                      
                    ),
              ),
              onTap: () => _toggleSelect(item));
        }).toList(),
      ),
    );
  }
}
