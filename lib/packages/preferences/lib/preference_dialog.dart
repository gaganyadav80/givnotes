import 'package:flutter/material.dart';

class PreferenceDialog extends StatefulWidget {
  final String? title;
  final List<Widget> preferences;
  final String? submitText;
  final String? cancelText;
  final VoidCallback? onSubmit;

  final bool onlySaveOnSubmit;

  const PreferenceDialog(
    this.preferences, {
    Key? key,
    this.title,
    this.submitText,
    this.onlySaveOnSubmit = false,
    this.cancelText,
    this.onSubmit,
  }) : super(key: key);

  @override
  PreferenceDialogState createState() => PreferenceDialogState();
}

class PreferenceDialogState extends State<PreferenceDialog> {
  @override
  void initState() {
    super.initState();

    // if (widget.onlySaveOnSubmit) {
    //   PrefService.rebuildCache();
    //   PrefService.enableCaching();
    // }
  }

  @override
  void dispose() {
    // PrefService.disableCaching();
    // PrefService.rebuildCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title!),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.preferences,
        ),
      ),
      // content: FutureBuilder(
      //   future: PrefService.init(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) return Container();

      //     return SingleChildScrollView(
      //       child: Column(
      //         children: widget.preferences,
      //       ),
      //     );
      //   },
      // ),
      actions: <Widget>[
        ...widget.cancelText == null
            ? []
            : [
                TextButton(
                  child: Text(widget.cancelText!),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
        ...widget.submitText == null
            ? []
            : [
                TextButton(
                  child: Text(widget.submitText!),
                  onPressed: () {
                    // if (widget.onlySaveOnSubmit) {
                    //   PrefService.applyCache();
                    // }
                    widget.onSubmit!();
                    Navigator.of(context).pop();
                  },
                )
              ]
      ],
    );
  }
}
