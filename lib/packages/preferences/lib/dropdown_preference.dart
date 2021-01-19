import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'preference_service.dart';

class DropdownPreference<T> extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final T defaultVal;
  // final String defaultVal;
  final List<T> values;
  final List<String> displayValues;
  final Function onChange;
  final bool disabled;

  final Color titleColor;
  final Widget leading;
  final double titleGap;
  final Color leadingColor;

  DropdownPreference(
    this.title,
    this.localKey, {
    this.desc,
    @required this.defaultVal,
    @required this.values,
    this.displayValues,
    this.onChange,
    this.disabled = false,
    this.leading,
    this.titleColor = Colors.black,
    this.titleGap,
    this.leadingColor,
  });

  _DropdownPreferenceState<T> createState() => _DropdownPreferenceState<T>();
}

class _DropdownPreferenceState<T> extends State<DropdownPreference<T>> {
  @override
  void initState() {
    super.initState();
    if (PrefService.get(widget.localKey) == null) {
      PrefService.setDefaultValues({widget.localKey: widget.defaultVal});
    }
  }

  @override
  Widget build(BuildContext context) {
    T value;
    try {
      value = PrefService.get(widget.localKey) ?? widget.defaultVal;
    } on TypeError catch (e) {
      value = widget.defaultVal;
      assert(() {
        throw FlutterError('''$e
The PrefService value for "${widget.localKey}" is not the right type (${PrefService.get(widget.localKey)}).
In release mode, the default value ($value) will silently be used.
''');
      }());
    }

    return GestureDetector(
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: ListTile(
          enabled: !widget.disabled,
          // leading: widget.leading,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.leadingColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                height: 30.0,
                width: 30.0,
                child: Center(child: widget.leading),
              ),
            ],
          ),
          horizontalTitleGap: widget.titleGap,
          title: Text(widget.title, style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.w600)),
          subtitle: widget.desc == null
              ? null
              : Text(
                  widget.desc,
                  style: TextStyle(
                    color: widget.titleColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 12.0,
                  ),
                ),
          // trailing: DropdownButton<T>(
          //   items: widget.values.map((var val) {
          //     return DropdownMenuItem<T>(
          //       value: val,
          //       child: Text(
          //         widget.displayValues == null ? val.toString() : widget.displayValues[widget.values.indexOf(val)],
          //         textAlign: TextAlign.end,
          //       ),
          //     );
          //   }).toList(),
          //   onChanged: widget.disabled
          //       ? null
          //       : (newVal) async {
          //           onChange(newVal);
          //         },
          //   value: value,
          // ),
          trailing: Container(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    "$value",
                    style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
                  ),
                ),
                Icon(
                  CupertinoIcons.forward,
                  size: 21.0,
                  color: widget.titleColor.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => widget.disabled
          ? null
          : showCupertinoModalPopup(
              context: context,
              builder: (ctx) => CupertinoActionSheet(
                actions: widget.values.map((val) {
                  return CupertinoActionSheetAction(
                    onPressed: () {
                      onChange(val);
                      Navigator.of(context, rootNavigator: true).pop(val);
                    },
                    child: Text(
                      widget.displayValues == null ? val.toString() : widget.displayValues[widget.values.indexOf(val)],
                      textAlign: TextAlign.end,
                    ),
                  );
                }).toList(),
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancle'),
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop("cancle"),
                  isDestructiveAction: true,
                ),
              ),
            ),
    );
  }

  onChange(T val) {
    if (val is String) {
      this.setState(() => PrefService.setString(widget.localKey, val));
    } else if (val is int) {
      this.setState(() => PrefService.setInt(widget.localKey, val));
    } else if (val is double) {
      this.setState(() => PrefService.setDouble(widget.localKey, val));
    } else if (val is bool) {
      this.setState(() => PrefService.setBool(widget.localKey, val));
    }
    if (widget.onChange != null) widget.onChange(val);
  }
}
