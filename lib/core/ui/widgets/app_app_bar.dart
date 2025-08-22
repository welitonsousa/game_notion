import 'package:fast_ui_kit/fast_ui_kit.dart';
import 'package:flutter/material.dart';

class AppAppBar extends PreferredSize {
  final void Function(String)? onSearch;
  final int? debounceTime;
  final String title;
  final String? hint;
  final bool? loading;
  final bool animated;
  final List<Widget>? actions;
  final Widget? leading;

  AppAppBar({
    super.key,
    this.actions,
    this.onSearch,
    this.debounceTime,
    this.leading,
    required this.title,
    this.hint,
    this.loading,
    this.animated = true,
  }) : super(
            child: _SearchAppBar(
              actions: [...?actions],
              onSearch: onSearch,
              animated: animated,
              debounceTime: debounceTime,
              title: title,
              hint: hint,
              loading: loading,
              leading: leading,
            ),
            preferredSize: Size(double.infinity,
                loading == true ? kToolbarHeight + 5 : kToolbarHeight));
}

class _SearchAppBar extends StatefulWidget {
  final void Function(String)? onSearch;
  final String title;
  final int? debounceTime;
  final String? hint;
  final bool? loading;
  final List<Widget>? actions;
  final Widget? leading;
  final bool animated;
  const _SearchAppBar({
    required this.actions,
    required this.onSearch,
    required this.title,
    required this.hint,
    required this.loading,
    required this.leading,
    required this.debounceTime,
    required this.animated,
  });
  @override
  State<_SearchAppBar> createState() => __SearchAppBarState();
}

class __SearchAppBarState extends State<_SearchAppBar> {
  bool searching = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(widget.title),
          leading: searching ? const SizedBox() : widget.leading,
          leadingWidth: searching ? 0 : null,
          actions: [
            if (!searching && widget.onSearch != null) ...?widget.actions,
            if (!searching && widget.onSearch != null)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => setState(() => searching = true),
              ),
            if (searching)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: FastAnimate(
                    duration: const Duration(milliseconds: 1000),
                    type: widget.animated
                        ? FastAnimateType.elasticInRight
                        : FastAnimateType.none,
                    child: TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        hintText: widget.hint,
                        contentPadding: const EdgeInsets.all(10),
                        suffix: IconButton(
                          icon: Icon(FastIcons.awesome.close),
                          onPressed: () {
                            widget.onSearch?.call('');
                            setState(() => searching = false);
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: (v) => FastDebounce.call(
                        action: () => widget.onSearch?.call(v),
                        milliseconds: widget.debounceTime,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (widget.loading ?? false)
          const Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: LinearProgressIndicator(),
          )),
      ],
    );
  }
}
