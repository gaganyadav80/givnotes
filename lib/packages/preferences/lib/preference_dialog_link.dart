import 'package:flutter/material.dart';

import 'preference_dialog.dart';

class PreferenceDialogLink extends StatelessWidget {
  final String title;
  final String? desc;
  final PreferenceDialog dialog;
  final Widget? leading;
  final Widget? trailing;
  final bool barrierDismissible;

  final Function? onPop;

  const PreferenceDialogLink(this.title,
      {Key? key,
      required this.dialog,
      this.desc,
      this.leading,
      this.trailing,
      this.onPop,
      this.barrierDismissible = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => dialog,
            barrierDismissible: barrierDismissible);
        if (onPop != null) onPop!();
      },
      title: Text(title),
      subtitle: desc == null ? null : Text(desc!),
      leading: leading,
      trailing: trailing,
    );
  }
}
