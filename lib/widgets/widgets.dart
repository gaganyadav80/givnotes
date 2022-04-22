export 'custom_circular_checkbox.dart';
export 'custom_appbar.dart';
export 'custom_dialog.dart';
export 'floating_modal.dart';
export 'custom_buttons.dart';
export 'circular_animation.dart';
export 'circular_loading.dart';
export 'simple_lockscreen.dart';

import 'package:flutter/material.dart';

class TilesDivider extends StatelessWidget {
  const TilesDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0.0,
      thickness: 0.5,
    );
  }
}
