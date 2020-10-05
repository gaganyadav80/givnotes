import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/utils/lockscreen.dart';
import 'package:preferences/preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool biometricActive = true;

  @override
  Widget build(BuildContext context) {
    return PreferencePage([
      PreferenceTitle(
        '  !! Below features are Coming Soon !!',
        style: TextStyle(
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      ),
      PreferenceTitle('General'),

      DropdownPreference(
        'Sort notes',
        'sort_notes',
        defaultVal: 'Date created',
        disabled: true,
        values: ['Date created', 'Date modified', 'A-Z Title', 'Z-A Title'],
        onChange: ((value) {
          print(value);
        }),
      ),
      PreferenceTitle('Personalization'),

      DropdownPreference(
        'App theme',
        'app_theme',
        disabled: true,
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
        defaultVal: 'Black',
        values: ['Black', 'Blue', 'Red'],
        onChange: ((value) {
          print(value);
        }),
      ),
      PreferenceTitle(
        '  !! Above features are Coming Soon !!',
        style: TextStyle(
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      ),
      PreferenceTitle('Security'),
      SwitchPreference(
        'Enable app lock',
        'app_lock',
        desc: 'Add 4 digit pin',
        defaultVal: false,
        ignoreTileTap: true,
        onEnable: () {
          if (!prefsBox.containsKey('passcode')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLockscreen(),
              ),
            );
          } else {
            AppLock.of(context).enable();
            prefsBox.put('applock', true);
            setState(() {
              biometricActive = true;
            });
          }
        },
        onDisable: () {
          AppLock.of(context).disable();
          prefsBox.put('applock', false);
          setState(() {
            biometricActive = false;
          });
        },
      ),
      SwitchPreference(
        'Biometric authentication',
        'biometric',
        desc: 'Enable Fingerprint/Face unlock',
        defaultVal: false,
        disabled: !prefsBox.get('applock'),
        onEnable: () {
          prefsBox.put('biometric', true);
        },
        onDisable: () {
          prefsBox.put('biometric', false);
        },
      ),
      PreferenceText(
        'Change Passcode',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Lockscreen(changePassAuth: true),
            ),
          );
        },
      ),

      // !! ========================================================

      PreferenceTitle('Details Section'),
      PreferencePageLink(
        'Device',
        leading: Icon(Icons.phone_iphone),
        trailing: Icon(Icons.keyboard_arrow_right),
        page: PreferencePage([
          PreferenceTitle('Device'),
          PreferenceText(
            """
Brand:   ${androidInfo.manufacturer}
Device:  ${androidInfo.device}
Model:   ${androidInfo.model}
  """,
            overflow: TextOverflow.visible,
          ),
          PreferenceTitle('Software'),
          PreferenceText(
            """
Host distro:  ${androidInfo.host}
Android ID:  ${androidInfo.androidId}
Fingerprint:  ${androidInfo.fingerprint}
  """,
            overflow: TextOverflow.visible,
          ),
          PreferenceTitle('Hardware'),
          PreferenceText(
            """
Architecture:  ${androidInfo.supported64BitAbis}
Hardware:  ${androidInfo.hardware}
Device ID:  ${androidInfo.id}
Display:  ${androidInfo.display}
  """,
            overflow: TextOverflow.visible,
          ),
        ]),
      ),
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
Version:   ${packageInfo.version}
Build_no:  ${packageInfo.buildNumber}
  """,
            overflow: TextOverflow.visible,
          ),
        ]),
      ),

      //! =============================================
    ]);
  }
}

// RadioPreference(
//   'Light Theme',
//   'light',
//   'ui_theme',
//   isDefault: true,
//   onSelect: () {
//     DynamicTheme.of(context).setBrightness(Brightness.light);
//   },
// ),

// PreferenceTitle('User'),
// TextFieldPreference(
//   'Display Name',
//   'user_display_name',
// ),
// TextFieldPreference('E-Mail', 'user_email', defaultVal: 'email@example.com',
//     validator: (str) {
//   if (!false) {
//     return "Invalid email";
//   }
//   return null;
// }),
// PreferenceText(
//   PrefService.getString('user_description', ignoreCache: true) ?? '',
//   style: TextStyle(color: Colors.grey),
// ),
// PreferenceDialogLink(
//   'Edit description',
//   dialog: PreferenceDialog(
//     [
//       TextFieldPreference(
//         'Description',
//         'user_description',
//         padding: const EdgeInsets.only(top: 8.0),
//         autofocus: true,
//         maxLines: 2,
//       )
//     ],
//     title: 'Edit description',
//     cancelText: 'Cancel',
//     submitText: 'Save',
//     onlySaveOnSubmit: true,
//   ),
//   onPop: () {},
// ),

//  PreferenceDialogLink(
//         'Android\'s "ListPreference"',
//         dialog: PreferenceDialog(
//           [
//             RadioPreference('Select me!', 'select_1', 'android_listpref_selected'),
//             RadioPreference('Hello World!', 'select_2', 'android_listpref_selected'),
//             RadioPreference('Test', 'select_3', 'android_listpref_selected'),
//           ],
//           title: 'Select an option',
//           cancelText: 'Cancel',
//           submitText: 'Save',
//           onlySaveOnSubmit: true,
//         ),
//       ),
//       PreferenceDialogLink(
//         'Android\'s "ListPreference" with autosave',
//         dialog: PreferenceDialog(
//           [
//             RadioPreference('Select me!', 'select_1', 'android_listpref_auto_selected'),
//             RadioPreference('Hello World!', 'select_2', 'android_listpref_auto_selected'),
//             RadioPreference('Test', 'select_3', 'android_listpref_auto_selected'),
//           ],
//           title: 'Select an option',
//           cancelText: 'Close',
//         ),
//       ),
//       PreferenceDialogLink(
//         'Android\'s "MultiSelectListPreference"',
//         dialog: PreferenceDialog(
//           [
//             CheckboxPreference('A enabled', 'android_multilistpref_a'),
//             CheckboxPreference('B enabled', 'android_multilistpref_b'),
//             CheckboxPreference('C enabled', 'android_multilistpref_c'),
//           ],
//           title: 'Select multiple options',
//           cancelText: 'Cancel',
//           submitText: 'Save',
//           onlySaveOnSubmit: true,
//         ),
//       ),

// PreferenceHider([
//         PreferenceTitle('Experimental'),
//         SwitchPreference(
//           'Show Operating System',
//           'exp_showos',
//           desc: 'This option shows the users operating system in his profile',
//         )
//       ], '!advanced_enabled'), // Use ! to get reversed boolean values
//       PreferenceTitle('Advanced'),
//       CheckboxPreference(
//         'Enable Advanced Features',
//         'advanced_enabled',
//         onChange: () {},
//         onDisable: () {
//           PrefService.setBool('exp_showos', false);
//         },
//       ),
