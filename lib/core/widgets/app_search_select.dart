import 'dart:async';

import 'package:flutter/material.dart';
import 'package:search_select/debounce.dart';

enum ItemsStyleType {
  text,
  textEllipsis,
  chip,
}

class AppSearchSelect<T> extends StatefulWidget {
  final List<T> items;
  final List<T> selectedItems;
  final String label;
  final TextStyle? labelStyle;
  final BoxDecoration? decoration;
  final double containerMinHeight;
  final ItemsStyleType itemsStyleType;
  final bool autoFocus;
  final bool useMaxWidthSpace;
  final bool showDeleteButton;
  final bool allowMultiple;
  final bool everShowLabel;
  final int? maxSelections;
  final void Function(List<T>)? onChange;
  final Widget Function(T item, bool checked)? itemBuilder;
  final Widget Function(T item)? selectedItemBuilder;
  final void Function()? onClickWhenFullItemsSelected;
  final int? maxBuildItemsIList;
  final double? maxHeight;
  final Color? labelBackgroundColor;
  final MenuController? menuController;
  final String? Function(List<T>)? validator;
  final T? selectedItem;
  final Function(T?)? onSingleChange;
  final String? emptyLabel;
  final bool showEmptyLabel;
  final String? searchHint;
  final Future<List<T>?> Function(String q)? searchAsync;
  final Duration searchAsyncDebounceDuration;
  final Widget? searchLoadingWidget;
  final bool applyLocalSearch;
  final bool loading;
  final double borderRadius;

  const AppSearchSelect({
    super.key,
    required this.items,
    this.selectedItems = const [],
    this.label = 'Select',
    this.onChange,
    this.itemBuilder,
    this.autoFocus = true,
    this.decoration,
    this.useMaxWidthSpace = true,
    this.labelStyle,
    this.selectedItemBuilder,
    this.showDeleteButton = true,
    this.everShowLabel = true,
    this.allowMultiple = true,
    this.containerMinHeight = 50,
    this.maxSelections,
    this.onClickWhenFullItemsSelected,
    this.maxBuildItemsIList,
    this.maxHeight,
    this.itemsStyleType = ItemsStyleType.chip,
    this.labelBackgroundColor,
    this.menuController,
    this.validator,
    this.selectedItem,
    this.onSingleChange,
    this.emptyLabel,
    this.searchHint,
    this.showEmptyLabel = true,
    this.searchAsync,
    this.searchLoadingWidget,
    this.searchAsyncDebounceDuration =
        const Duration(milliseconds: 500),
    this.loading = false,
    this.borderRadius = 8,
    bool? applyLocalSearch,
  }) : applyLocalSearch =
            applyLocalSearch ?? searchAsync == null;

  @override
  State<AppSearchSelect<T>> createState() => _AppSearchSelectState<T>();
}

class _AppSearchSelectState<T> extends State<AppSearchSelect<T>> {
  late final MenuController menuController;

  final searchController = TextEditingController();
  final scrollController = ScrollController();
  final selects = <T>[];
  final searchFocusNode = FocusNode();

  late final Debounce debounce =
      Debounce(duration: widget.searchAsyncDebounceDuration);

  bool loading = false;

  @override
  void initState() {
    super.initState();

    menuController =
        widget.menuController ?? MenuController();

    selects.clear();

    if (widget.selectedItem != null) {
      selects.add(widget.selectedItem as T);
    }

    selects.addAll(widget.selectedItems);

    searchFocusNode.addListener(searchFocusListener);
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();

    searchFocusNode.removeListener(searchFocusListener);
    searchFocusNode.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(
    covariant AppSearchSelect<T> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    selects.clear();

    if (widget.selectedItem != null) {
      selects.add(widget.selectedItem as T);
    }

    selects.addAll(widget.selectedItems);

    setState(() {});
  }

  void searchFocusListener() {
    setState(() {});

    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        setState(() {});

        if (!searchFocusNode.hasFocus) {
          timer.cancel();
        }

        if (timer.tick > 60) {
          timer.cancel();
        }
      },
    );
  }

  void runGetAsyncItems(String q) {
    if (widget.searchAsync == null) return;
    if (loading) return;

    debounce(() async {
      loading = true;
      setState(() {});

      final res = await widget.searchAsync!(q);

      widget.items.clear();

      if (res != null) {
        widget.items.addAll(res);
      }

      loading = false;
      setState(() {});
    });
  }

  List<T> get filteredItems {
    if (!widget.applyLocalSearch) {
      return widget.items;
    }

    final search =
        searchController.text.toLowerCase();

    final res = widget.items
        .where(
          (element) => element
              .toString()
              .toLowerCase()
              .contains(search),
        )
        .toList();

    if (widget.maxBuildItemsIList == null) {
      return res;
    }

    final isCutOff =
        res.length > widget.maxBuildItemsIList!;

    if (!isCutOff) {
      return res;
    }

    return res.sublist(
      0,
      widget.maxBuildItemsIList!,
    );
  }

  void tapItem(
    T item,
    FormFieldState? state,
  ) {
    if (widget.maxSelections == selects.length) {
      widget.onClickWhenFullItemsSelected?.call();
    } else {
      if (!widget.allowMultiple) {
        menuController.close();
        selects.clear();
      }

      final isSelected = selects.contains(item);

      if (isSelected) {
        selects.remove(item);
      } else {
        selects.add(item);
      }

      if (widget.maxSelections == selects.length) {
        menuController.close();
      }
    }

    widget.onChange?.call(selects);

    selectSingleItem();

    state?.validate();

    setState(() {});
  }

  void selectSingleItem() {
    if (widget.onSingleChange != null &&
        !widget.allowMultiple) {
      widget.onSingleChange!(
        selects.isNotEmpty ? selects.first : null,
      );
    }
  }

  Widget buildSelectedItems(FormFieldState state) {
    if (widget.itemsStyleType ==
        ItemsStyleType.textEllipsis) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          selects.join(', '),
          style: widget.labelStyle,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    if (widget.itemsStyleType ==
        ItemsStyleType.text) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          selects.join(', '),
          style: widget.labelStyle,
        ),
      );
    }

    return Wrap(
      runSpacing: 5,
      spacing: 5,
      children: [
        ...selects.map((e) {
          if (widget.selectedItemBuilder != null) {
            return widget.selectedItemBuilder!
                .call(e);
          }

          return RawChip(
            onDeleted: widget.showDeleteButton
                ? () {
                    selects.remove(e);

                    widget.onChange
                        ?.call(selects);

                    selectSingleItem();

                    state.validate();

                    setState(() {});
                  }
                : null,
            deleteIcon:
                widget.showDeleteButton
                    ? const Icon(Icons.close)
                    : null,
            label: Text(e.toString()),
          );
        }),
      ],
    );
  }

  InputDecoration buildInputDecoration(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    final border = OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: theme.dividerColor,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: theme.colorScheme.primary,
        width: 1.5,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
      ),
    );

    return InputDecoration(
      labelText: widget.label,
      labelStyle: widget.labelStyle,

      // Deixa o Flutter controlar automaticamente
      // quando a label fica no centro ou sobe.
      floatingLabelBehavior:
          widget.everShowLabel
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,

      contentPadding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: widget.everShowLabel ? 10 : 8,
        bottom: 8,
      ),

      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,

      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,

      // Não queremos o erro padrão do InputDecorator,
      // porque o FormField abaixo já controla isso.
      errorText: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      autovalidateMode:
          AutovalidateMode.onUserInteraction,

      validator: (value) {
        if (widget.validator == null) {
          return null;
        }

        return widget.validator!(selects);
      },

      builder: (state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return MenuAnchor(
              controller: menuController,

              style: MenuStyle(
                elevation:
                    WidgetStateProperty.all(100),

                maximumSize:
                    WidgetStateProperty.all(
                  Size(
                    constraints.maxWidth,
                    widget.maxHeight ??
                        MediaQuery.of(context)
                                .size
                                .height *
                            0.4,
                  ),
                ),
              ),

              onClose: () {
                searchController.clear();
                widget.onChange?.call(selects);
              },

              menuChildren: [
                TextField(
                  autocorrect: false,
                  focusNode: searchFocusNode,
                  autofocus: widget.autoFocus,
                  controller: searchController,

                  onChanged: (value) {
                    runGetAsyncItems(value);
                    setState(() {});
                  },

                  decoration:
                      const InputDecoration(
                    hintText: 'Pesquisar',
                    prefixIcon:
                        Icon(Icons.search),
                  ),
                ),

                if (loading)
                  Container(
                    constraints: BoxConstraints(
                      minWidth:
                          widget.useMaxWidthSpace
                              ? MediaQuery.of(context)
                                  .size
                                  .width
                              : 0,
                    ),
                    child:
                        widget.searchLoadingWidget ??
                            Align(
                              alignment:
                                  Alignment.centerLeft,
                              child: SizedBox(
                                width:
                                    constraints
                                        .maxWidth,
                                child: const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(
                                            8),
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                  )
                else
                  Container(
                    constraints:
                        BoxConstraints(
                      maxHeight:
                          MediaQuery.of(context)
                                  .size
                                  .height *
                              0.4,
                      minWidth:
                          widget.useMaxWidthSpace
                              ? MediaQuery.of(context)
                                  .size
                                  .width
                              : 0,
                    ),
                    child:
                        SingleChildScrollView(
                      controller:
                          scrollController,
                      child: Column(
                        children: [
                          ...filteredItems
                              .map((item) {
                            final checked =
                                selects.contains(item);

                            return GestureDetector(
                              onTap: () =>
                                  tapItem(
                                item,
                                state,
                              ),
                              child: Column(
                                children: [
                                  if (widget
                                          .itemBuilder !=
                                      null)
                                    widget.itemBuilder!
                                        .call(
                                      item,
                                      checked,
                                    )
                                  else if (!widget
                                      .allowMultiple)
                                    ListTile(
                                      title: Text(
                                        item.toString(),
                                      ),
                                      selected:
                                          checked,
                                      onTap: () =>
                                          tapItem(
                                        item,
                                        state,
                                      ),
                                    )
                                  else
                                    ListTile(
                                      title: Text(
                                        item.toString(),
                                      ),
                                      onTap: () =>
                                          tapItem(
                                        item,
                                        state,
                                      ),
                                      selected:
                                          checked,
                                      leading: checked
                                          ? const Icon(
                                              Icons
                                                  .check_box,
                                            )
                                          : const Icon(
                                              Icons
                                                  .check_box_outline_blank,
                                            ),
                                    ),
                                ],
                              ),
                            );
                          }),

                          if (filteredItems
                                  .isEmpty &&
                              widget.showEmptyLabel)
                            Align(
                              alignment:
                                  Alignment.centerLeft,
                              child: SizedBox(
                                width:
                                    constraints
                                        .maxWidth,
                                child: Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets
                                            .all(8),
                                    child: Text(
                                      widget.emptyLabel ??
                                          'Nenhum item encontrado',
                                      style: TextStyle(
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        color: Theme.of(
                                          context,
                                        )
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          if (filteredItems
                              .isNotEmpty)
                            const SizedBox(
                              height: 60,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],

              child: GestureDetector(
                onTap: () {
                  if (menuController.isOpen) {
                    menuController.close();
                  } else {
                    menuController.open();
                  }
                },

                child: InputDecorator(
                  decoration:
                      buildInputDecoration(
                    context,
                  ).copyWith(
                    errorText:
                        state.hasError
                            ? state.errorText
                            : null,
                  ),

                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(
                      minHeight:
                          widget.containerMinHeight -
                              16,
                      minWidth:
                          double.infinity,
                    ),

                    child: widget.decoration !=
                            null
                        ? DecoratedBox(
                            decoration:
                                widget.decoration!,
                            child:
                                buildSelectedItems(
                              state,
                            ),
                          )
                        : buildSelectedItems(
                            state,
                          ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}