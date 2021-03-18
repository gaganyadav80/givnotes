import 'package:flutter/material.dart';

import 'preference_service.dart';

class PreferenceDialog extends StatefulWidget {
  final String title;
  final List<Widget> preferences;
  final String submitText;
  final String cancelText;

  final bool onlySaveOnSubmit;

  PreferenceDialog(this.preferences, {this.title, this.submitText, this.onlySaveOnSubmit = false, this.cancelText});

  PreferenceDialogState createState() => PreferenceDialogState();
}

class PreferenceDialogState extends State<PreferenceDialog> {
  @override
  void initState() {
    super.initState();

    if (widget.onlySaveOnSubmit) {
      PrefService.rebuildCache();
      PrefService.enableCaching();
    }
  }

  @override
  void dispose() {
    PrefService.disableCaching();
    PrefService.rebuildCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title),
      content: FutureBuilder(
        future: PrefService.init(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          return SingleChildScrollView(
            child: Column(
              children: widget.preferences,
            ),
          );
        },
      ),
      actions: <Widget>[]
        ..addAll(widget.cancelText == null
            ? []
            : [
                TextButton(
                  child: Text(widget.cancelText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ])
        ..addAll(widget.submitText == null
            ? []
            : [
                TextButton(
                  child: Text(widget.submitText),
                  onPressed: () {
                    if (widget.onlySaveOnSubmit) {
                      PrefService.applyCache();
                    }
                    Navigator.of(context).pop();
                  },
                )
              ]),
    );
  }
}
