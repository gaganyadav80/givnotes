import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/services/services.dart';

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

    return PreferencePage([
      PreferenceTitle('General'),

      DropdownPreference(
        'Sort Notes',
        'sort_notes',
        defaultVal: def,
        values: ['Date created', 'Date modified', 'Alphabetical (A-Z)', 'Alphabetical (Z-A)'],
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
          // prefsBox.sortBy = val;
          // prefsBox.save();
        }),
      ),
      SwitchPreference(
        'Compact Tags',
        'compact_tags',
        desc: 'Enable compact tags in notes view',
        defaultVal: _prefsCubit.state.compactTags,
        onEnable: () {
          _prefsCubit.updateCompactTags(true);
          // prefsBox.compactTags = true;
          // prefsBox.save();
        },
        onDisable: () {
          _prefsCubit.updateCompactTags(false);
          // prefsBox.compactTags = false;
          // prefsBox.save();
        },
      ),

      PreferenceTitle('Personalization'),
      PreferenceTitle(
        '  !! Personalization is yet to be implemented !!',
        style: TextStyle(
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      ),
      DropdownPreference(
        'Application theme',
        'app_theme',
        disabled: true,
        desc: "Light and dark theme",
        defaultVal: 'Light',
        values: ['Light', 'Dark'],
        onChange: ((value) {
          print(value);
        }),
      ),
      DropdownPreference(
        'Accent color',
        'accent_color',
        disabled: true,
        desc: "Spice up the theme",
        defaultVal: 'Black',
        values: ['Black', 'Blue', 'Red'],
        onChange: ((value) {
          print(value);
        }),
      ),
      PreferenceTitle('Security'),
      AppLockSwitchPrefs(),
      PreferenceText(
        'Change Passcode',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowLockscreen(changePassAuth: true),
            ),
          );
        },
      ),

      // !! ========================================================

      PreferenceTitle('Details Section'),
      PreferencePageLink(
        'Application',
        leading: Icon(Icons.settings_applications),
        trailing: Icon(Icons.keyboard_arrow_right),
        page: PreferencePage([
          PreferenceTitle('Device'),
          PreferenceText(
            """
App name:  ${packageInfo.appName}
Package:   ${packageInfo.packageName}
Build_no:  ${packageInfo.buildNumber}
App Release Version:   ${packageInfo.version}-beta
Development Version:   3.0.0
  """,
            overflow: TextOverflow.visible,
          ),
        ]),
      ),

      //! =============================================
    ]);
  }
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
