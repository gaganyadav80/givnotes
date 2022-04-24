import 'package:flutter/material.dart';

import 'preference_service.dart';

class CheckboxPreference extends StatefulWidget {
  final String title;
  final String? desc;
  final bool defaultVal;
  final bool ignoreTileTap;

  final bool disabled;

  final bool resetOnException;

  final Function? onEnable;
  final Function? onDisable;
  final Function? onChange;

  const CheckboxPreference(
    this.title, {
    Key? key,
    this.desc,
    this.defaultVal = false,
    this.ignoreTileTap = false,
    this.resetOnException = true,
    this.onEnable,
    this.onDisable,
    this.onChange,
    this.disabled = false,
  }) : super(key: key);

  @override
  _CheckboxPreferenceState createState() => _CheckboxPreferenceState();
}

class _CheckboxPreferenceState extends State<CheckboxPreference> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    // if (PrefService.getBool(widget.localKey) == null) {
    //   PrefService.setBool(widget.localKey, widget.defaultVal);
    // }
    _value = widget.defaultVal;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc!),
      trailing: Checkbox(
        value: _value,
        onChanged:
            widget.disabled ? null : (val) => val! ? onEnable() : onDisable(),
      ),
      onTap: (widget.ignoreTileTap || widget.disabled)
          ? null
          : () => (_value) ? onDisable() : onEnable(),
    );
  }

  onEnable() async {
    setState(() => _value = true);
    if (widget.onChange != null) widget.onChange!();
    if (widget.onEnable != null) {
      try {
        await widget.onEnable!();
      } catch (e) {
        if (widget.resetOnException) {
          _value = false;
          if (mounted) setState(() {});
        }
        if (mounted) PrefService.showError(context, e.toString());
      }
    }
  }

  onDisable() async {
    setState(() => _value = false);
    if (widget.onChange != null) widget.onChange!();
    if (widget.onDisable != null) {
      try {
        await widget.onDisable!();
      } catch (e) {
        if (widget.resetOnException) {
          _value = true;
          if (mounted) setState(() {});
        }
        if (mounted) PrefService.showError(context, e.toString());
      }
    }
  }
}
