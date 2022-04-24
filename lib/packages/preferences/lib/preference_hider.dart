import 'package:flutter/material.dart';

class PreferenceHider extends StatelessWidget {
  final List<Widget> preferences;
  final String hidePref;
  final bool defaultVal;

  const PreferenceHider(this.preferences, this.hidePref,
      {Key? key, this.defaultVal = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (defaultVal) return Container();
    return Column(
      children: preferences,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
