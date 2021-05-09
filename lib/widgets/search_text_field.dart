import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Tags View search text field
class CustomSearchTextField extends StatefulWidget {
  const CustomSearchTextField({
    Key key,
    @required this.controller,
    @required this.focusNode,
    this.onClearTap,
    this.onSubmitted,
    this.onChanged,
    this.useCapitals = false,
    this.useBorders = true,
    this.padding = const EdgeInsets.fromLTRB(3.8, 8, 5, 8),
    this.prefixSize = 20.0,
    this.placeholder = 'Search',
    this.restorationId,
    this.fillColor,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final bool useCapitals;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final VoidCallback onClearTap;
  final bool useBorders;
  final EdgeInsets padding;
  final double prefixSize;
  final String placeholder;
  final String restorationId;
  final Color fillColor;

  @override
  _CustomSearchTextFieldState createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> with RestorationMixin {
  final BorderRadius _kDefaultBorderRadius = const BorderRadius.all(Radius.circular(9.0));

  RestorableTextEditingController _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller.value;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _createLocalController();
    }
  }

  @override
  void didUpdateWidget(CustomSearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller);
      _controller.dispose();
      _controller = null;
    }
  }

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller, 'controller');
  }

  void _createLocalController([TextEditingValue value]) {
    assert(_controller == null);
    _controller = value == null ? RestorableTextEditingController() : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  String get restorationId => widget.restorationId;

  void _defaultOnSuffixTap() {
    final bool textChanged = _effectiveController.text.isNotEmpty;
    _effectiveController.clear();
    if (widget.onChanged != null && textChanged) widget.onChanged(_effectiveController.text);
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = BoxDecoration(
      color: widget.fillColor ?? Colors.white,
      borderRadius: _kDefaultBorderRadius,
    );

    return CupertinoTextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      cursorColor: Colors.black,
      // cursorHeight: 22,
      cursorWidth: 1.5,
      inputFormatters: widget.useCapitals
          ? [
              TextInputFormatter.withFunction(
                (oldValue, newValue) => TextEditingValue(
                  text: newValue.text?.toUpperCase(),
                  selection: newValue.selection,
                ),
              ),
            ]
          : null,
      onSubmitted: widget.onSubmitted ??
          (_) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
      onChanged: widget.onChanged,
      padding: widget.padding,
      placeholder: widget.placeholder,
      placeholderStyle: const TextStyle(color: CupertinoColors.systemGrey),
      prefix: Padding(
        child: IconTheme(
          child: const Icon(CupertinoIcons.search),
          data: IconThemeData(
            color: CupertinoDynamicColor.resolve(CupertinoColors.secondaryLabel, context),
            size: MediaQuery.textScaleFactorOf(context) * widget.prefixSize,
          ),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(6, 3, 0, 4),
      ),
      suffixMode: OverlayVisibilityMode.editing,
      suffix: Padding(
        child: CupertinoButton(
          child: IconTheme(
            child: const Icon(CupertinoIcons.xmark_circle_fill),
            data: IconThemeData(
              color: CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context),
              size: MediaQuery.textScaleFactorOf(context) * 20.0,
            ),
          ),
          onPressed: widget.onClearTap ?? _defaultOnSuffixTap,
          minSize: 0,
          padding: EdgeInsets.zero,
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 2),
      ),
      decoration: widget.useBorders
          ? BoxDecoration(
              borderRadius: _kDefaultBorderRadius,
              border: Border.all(width: 1.0),
              color: widget.fillColor ?? Colors.white,
            )
          : decoration,
    );
  }
}
