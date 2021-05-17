import 'package:flutter/material.dart';
import 'preference_page.dart';

class PreferencePageLink extends StatelessWidget {
  final String title;
  final String pageTitle;
  final String desc;
  final PreferencePage page;
  final Widget widgetScaffold;
  final Widget leading;
  final Widget trailing;
  final double titleGap;
  final TextStyle style;
  final Color leadingColor;
  final bool disabled;
  final Color titleColor;
  PreferencePageLink(
    this.title, {
    this.page,
    this.desc,
    this.pageTitle,
    this.leading,
    this.trailing,
    this.titleGap,
    this.style,
    this.leadingColor,
    this.widgetScaffold,
    this.disabled = false,
    this.titleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        horizontalTitleGap: titleGap,
        enabled: !disabled,
        onTap: () => disabled
            ? null
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      widgetScaffold ??
                      Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          title: Text(pageTitle ?? title),
                        ),
                        body: page,
                      ),
                ),
              ),
        title: Text(title, style: style),
        subtitle: desc == null
            ? null
            : Text(
                desc,
                style: TextStyle(color: titleColor?.withOpacity(0.6), fontWeight: FontWeight.w300, fontSize: 12.0),
              ),
        // leading: leading,
        leading: Container(
          decoration: BoxDecoration(
            color: leadingColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 30.0,
          width: 30.0,
          child: Center(child: leading),
        ),
        trailing: trailing,
      ),
    );
  }
}
