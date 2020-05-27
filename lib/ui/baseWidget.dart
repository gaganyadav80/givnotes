import 'package:flutter/material.dart';
import 'package:givnotes/ui/sizingInfo.dart';

class BaseWidget extends StatefulWidget {
  final Widget Function(BuildContext context, SizingInformation sizingInformation) builder;
  const BaseWidget({Key key, this.builder}) : super(key: key);

  @override
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, boxSizing) {
        var sizingInformation = SizingInformation(
          orientation: mediaQuery.orientation,
          deviceType: getDeviceType(mediaQuery),
          screenSize: mediaQuery.size,
          localWidgetSize: Size(boxSizing.maxWidth, boxSizing.maxHeight),
        );

        return widget.builder(context, sizingInformation);
      },
    );
  }
}
