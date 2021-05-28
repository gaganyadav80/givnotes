export 'circular_checkbox_beta.dart';
export 'circular_checkbox_stable.dart';
export 'custom_appbar.dart';
export 'custom_dialog.dart';
export 'floating_modal.dart';

import 'package:flutter/material.dart';

class TilesDivider extends StatelessWidget {
  const TilesDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      thickness: 0.5,
    );
  }
}