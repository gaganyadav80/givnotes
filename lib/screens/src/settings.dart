import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/services/services.dart';

//TODO change icons with custom colorful icons
class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit _prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);

    String def = _prefsCubit.state.sortBy == 'created'
        ? 'Date created'
        : _prefsCubit.state.sortBy == 'modified'
            ? 'Date modified'
            : _prefsCubit.state.sortBy == 'a-z'
                ? "Alphabetical (A-Z)"
                : "Alphabetical (Z-A)";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: PreferencePage([
        PreferenceTitle('General'),

        DropdownPreference(
          'Sort notes',
          'sort_notes',
          defaultVal: def,
          values: ['Date created', 'Date modified', 'Alphabetical (A-Z)', 'Alphabetical (Z-A)'],
          titleColor: const Color(0xff32343D),
          leading: Icon(CupertinoIcons.sort_down_circle, color: Colors.white, size: 20.0),
          leadingColor: Colors.red,
          titleGap: 0.0,
          onChange: ((String value) {
            String val;

            if (value == 'Date created')
              val = 'created';
            else if (value == 'Date modified')
              val = 'modified';
            else if (value == 'Alphabetical (A-Z)')
              val = 'a-z';
            else
              val = 'z-a';

            _prefsCubit.updateSortBy(val);
          }),
        ),
        SwitchPreference(
          'Compact tags',
          'compact_tags',
          desc: 'Enable compact tags in notes view',
          defaultVal: _prefsCubit.state.compactTags,
          titleColor: const Color(0xff32343D),
          leading: Icon(CupertinoIcons.bars, color: Colors.white, size: 20.0),
          leadingColor: Colors.blue,
          titleGap: 0.0,
          onEnable: () => _prefsCubit.updateCompactTags(true),
          onDisable: () => _prefsCubit.updateCompactTags(false),
        ),

        PreferenceTitle('Personalization'),
        PreferenceTitle(
          '  !! Personalization is yet to be implemented !!',
          style: TextStyle(
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
        ),
        SwitchPreference(
          'Dark mode',
          'dark_mode',
          disabled: true,
          desc: "Switch between light and dark mode",
          titleColor: const Color(0xff32343D),
          leading: Icon(CupertinoIcons.moon, color: Colors.white, size: 20.0),
          leadingColor: Colors.purple,
          titleGap: 0.0,
          onChange: ((value) {
            print(value);
          }),
        ),
        DropdownPreference(
          'Accent color',
          'accent_color',
          disabled: true,
          desc: "Spice up your theme",
          defaultVal: 'Black',
          values: ['Black', 'Blue', 'Red'],
          titleColor: const Color(0xff32343D),
          leading: Icon(CupertinoIcons.at, color: Colors.white, size: 20.0),
          leadingColor: Colors.pink,
          titleGap: 0.0,
          onChange: ((value) {
            print(value);
          }),
        ),
        PreferenceTitle('Security'),
        AppLockSwitchPrefs(),
        PreferenceText(
          'Change Passcode',
          style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
          leading: Icon(CupertinoIcons.lock_shield, color: Colors.white, size: 20.0),
          leadingColor: Colors.lightGreen,
          titleGap: 0.0,
          onTap: () {
            // if (prefsBox.passcode != '')
            if (PrefService.getBool('app_lock') == true)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowLockscreen(changePassAuth: true),
                ),
              );
            else
              Toast.show("Please enable applock first", context);
          },
        ),

        // !! ========================================================

        PreferenceTitle('Details Section'),
        PreferencePageLink(
          'Application',
          style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
          leading: Icon(CupertinoIcons.app, color: Colors.white, size: 20.0),
          leadingColor: Colors.grey,
          trailing: Icon(Icons.keyboard_arrow_right),
          titleGap: 0.0,
          widgetScaffold: AppDetailSection(),
        ),
        //! =============================================
      ]),
    );
  }
}

class AppDetailSection extends StatefulWidget {
  AppDetailSection({Key key}) : super(key: key);

  @override
  _AppDetailSectionState createState() => _AppDetailSectionState();
}

class _AppDetailSectionState extends State<AppDetailSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Application"),
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 80.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl(
              children: {
                0: Text("App Info"),
                1: Text("Logs"),
                2: Text("Contact"),
              },
              groupValue: selectedIndex,
              onValueChanged: (value) => setState(() => selectedIndex = value),
            ),
          ),
        ),
      ),
      body: _bodyWidgets[selectedIndex],
    );
  }

  List<Widget> _bodyWidgets = [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("App name: "), Text("${packageInfo.appName}")]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Package: "), Text("${packageInfo.packageName}")]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Build_no: "), Text("${packageInfo.buildNumber}")]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Release version: "), Text("v${packageInfo.version}-beta")]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Development version: "), Text("v2.0.0")]),
        ],
      ),
    ),
    Center(child: Text("Logs", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))),
    Center(child: Text("Contact us", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))),
  ];
}

class AppLockSwitchPrefs extends StatefulWidget {
  AppLockSwitchPrefs({Key key}) : super(key: key);

  @override
  _AppLockSwitchPrefsState createState() => _AppLockSwitchPrefsState();
}

class _AppLockSwitchPrefsState extends State<AppLockSwitchPrefs> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchPreference(
          'Enable app lock',
          'app_lock',
          desc: 'Add 4 digit pin',
          defaultVal: false,
          ignoreTileTap: false,
          leading: Icon(CupertinoIcons.lock, color: Colors.white, size: 20.0),
          leadingColor: Colors.orangeAccent,
          titleGap: 0.0,
          onEnable: () {
            if (prefsBox.passcode == '') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLockscreen(),
                ),
              ).then((value) {
                if (!value) {
                  PrefService.setBool('app_lock', false);
                  setState(() {});
                }
              });
            } else {
              AppLock.of(context).enable();
              prefsBox.applock = true;
              prefsBox.save();
              setState(() {});
            }
          },
          onDisable: () {
            if (prefsBox.passcode != '') {
              AppLock.of(context).disable();
              prefsBox.applock = false;
              prefsBox.save();
            }
            setState(() {});
          },
        ),
        SwitchPreference(
          'Biometric authentication',
          'biometric',
          desc: 'Enable Fingerprint/Face unlock',
          defaultVal: false,
          disabled: !prefsBox.applock,
          leading: Icon(Icons.fingerprint_outlined, color: Colors.white, size: 20.0),
          leadingColor: Colors.teal,
          titleGap: 0.0,
          onEnable: () {
            prefsBox.biometric = true;
            prefsBox.save();
          },
          onDisable: () {
            prefsBox.biometric = false;
            prefsBox.save();
          },
        ),
      ],
    );
  }
}

//TODO add iosInfo
//       PreferencePageLink(
//         'Device',
//         leading: Icon(Icons.phone_iphone),
//         trailing: Icon(Icons.keyboard_arrow_right),
//         page: PreferencePage([
//           PreferenceTitle('Device'),
//           PreferenceText(
//             """
// Brand:   ${_pluginInitializer.androidInfo.manufacturer}
// Device:  ${_pluginInitializer.androidInfo.device}
// Model:   ${_pluginInitializer.androidInfo.model}
//   """,
//             overflow: TextOverflow.visible,
//           ),
//           PreferenceTitle('Software'),
//           PreferenceText(
//             """
// Host distro:  ${_pluginInitializer.androidInfo.host}
// Android ID:  ${_pluginInitializer.androidInfo.androidId}
// Fingerprint:  ${_pluginInitializer.androidInfo.fingerprint}
//   """,
//             overflow: TextOverflow.visible,
//           ),
//           PreferenceTitle('Hardware'),
//           PreferenceText(
//             """
// Architecture:  ${_pluginInitializer.androidInfo.supported64BitAbis}
// Hardware:  ${_pluginInitializer.androidInfo.hardware}
// Device ID:  ${_pluginInitializer.androidInfo.id}
// Display:  ${_pluginInitializer.androidInfo.display}
// HM - WM:  $hm - $wm
//   """,
//             overflow: TextOverflow.visible,
//           ),
//         ]),
//       ),
