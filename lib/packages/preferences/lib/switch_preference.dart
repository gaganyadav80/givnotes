import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'preference_service.dart';

class SwitchPreference extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final bool defaultVal;
  final bool ignoreTileTap;
  final bool resetOnException;
  final Function onEnable;
  final Function onDisable;
  final Function onChange;
  final bool disabled;
  final Color switchActiveColor;

  final Color titleColor;
  final Widget leading;
  final double titleGap;
  final Color leadingColor;
  final Color backgroundColor;

  final VoidCallback ondisableTap;
  final bool isWaitSwitch;

  SwitchPreference(
    this.title,
    this.localKey, {
    this.desc,
    this.defaultVal = false,
    this.ignoreTileTap = false,
    this.resetOnException = true,
    this.onEnable,
    this.onDisable,
    this.onChange,
    this.disabled = false,
    this.switchActiveColor,
    this.leading,
    this.titleColor = Colors.black,
    this.titleGap,
    this.leadingColor,
    this.backgroundColor = Colors.white,
    this.ondisableTap,
    this.isWaitSwitch = false,
  });

  _SwitchPreferenceState createState() => _SwitchPreferenceState();
}

class _SwitchPreferenceState extends State<SwitchPreference> {
  @override
  void initState() {
    super.initState();
    if (PrefService.getBool(widget.localKey) == null) {
      PrefService.setBool(widget.localKey, widget.defaultVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        // enableFeedback: true,
        tileColor: widget.backgroundColor,
        // leading: widget.leading,
        leading: Container(
          decoration: BoxDecoration(
            color: widget.leadingColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 30.0,
          width: 30.0,
          child: Center(child: widget.leading),
        ),
        horizontalTitleGap: widget.titleGap,
        title: Text(widget.title, style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.w500)),
        subtitle: widget.desc == null
            ? null
            : Text(
                widget.desc,
                style:
                    TextStyle(color: widget.titleColor?.withOpacity(0.6), fontWeight: FontWeight.w300, fontSize: 12.0),
              ),
        trailing: CupertinoSwitch(
          value: PrefService.getBool(widget.localKey) ?? widget.defaultVal,
          activeColor: widget.switchActiveColor ?? Color(0xFFDD4C4F),
          onChanged: widget.disabled ? (_) => widget.ondisableTap : (val) => val ? onEnable() : onDisable(),
        ),
        onTap: (widget.disabled || widget.ignoreTileTap)
            ? widget.ondisableTap
            : () => (PrefService.getBool(widget.localKey) ?? widget.defaultVal) ? onDisable() : onEnable(),
      ),
    );
  }

  onEnable() async {
    if (!widget.isWaitSwitch) setState(() => PrefService.setBool(widget.localKey, true));
    if (widget.onChange != null) widget.onChange();
    if (widget.onEnable != null) {
      try {
        await widget.onEnable();
      } catch (e) {
        if (widget.resetOnException) {
          PrefService.setBool(widget.localKey, false);
          if (mounted) setState(() {});
        }
        if (mounted) PrefService.showError(context, e.message);
      }
    }
  }

  onDisable() async {
   if (!widget.isWaitSwitch) setState(() => PrefService.setBool(widget.localKey, false));
    if (widget.onChange != null) widget.onChange();
    if (widget.onDisable != null) {
      try {
        await widget.onDisable();
      } catch (e) {
        if (widget.resetOnException) {
          PrefService.setBool(widget.localKey, true);
          if (mounted) setState(() {});
        }
        if (mounted) PrefService.showError(context, e.message);
      }
    }
  }
}
