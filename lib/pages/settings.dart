import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferencePage([
      PreferenceTitle('General'),
      DropdownPreference(
        'Sort notes',
        'sort_notes',
        defaultVal: 'Date created',
        values: ['Date created', 'Date modified', 'A-Z Title', 'Z-A Title'],
        onChange: ((value) {
          print(value);
        }),
      ),
      PreferenceTitle('Personalization'),
      DropdownPreference(
        'App theme',
        'app_theme',
        defaultVal: 'Light',
        values: ['Light', 'Dark'],
        onChange: ((value) {
          print(value);
        }),
      ),
      PreferenceTitle('Security'),
      PreferenceDialogLink(
        'Content Types',
        dialog: PreferenceDialog(
          [
            CheckboxPreference('Text', 'content_show_text'),
            CheckboxPreference('Images', 'content_show_image'),
            CheckboxPreference('Music', 'content_show_audio')
          ],
          title: 'Enabled Content Types',
          cancelText: 'Cancel',
          submitText: 'Save',
          onlySaveOnSubmit: true,
        ),
      ),
      PreferenceTitle('More Dialogs'),
      PreferenceDialogLink(
        'Android\'s "ListPreference"',
        dialog: PreferenceDialog(
          [
            RadioPreference('Select me!', 'select_1', 'android_listpref_selected'),
            RadioPreference('Hello World!', 'select_2', 'android_listpref_selected'),
            RadioPreference('Test', 'select_3', 'android_listpref_selected'),
          ],
          title: 'Select an option',
          cancelText: 'Cancel',
          submitText: 'Save',
          onlySaveOnSubmit: true,
        ),
      ),
      PreferenceDialogLink(
        'Android\'s "ListPreference" with autosave',
        dialog: PreferenceDialog(
          [
            RadioPreference('Select me!', 'select_1', 'android_listpref_auto_selected'),
            RadioPreference('Hello World!', 'select_2', 'android_listpref_auto_selected'),
            RadioPreference('Test', 'select_3', 'android_listpref_auto_selected'),
          ],
          title: 'Select an option',
          cancelText: 'Close',
        ),
      ),
      PreferenceDialogLink(
        'Android\'s "MultiSelectListPreference"',
        dialog: PreferenceDialog(
          [
            CheckboxPreference('A enabled', 'android_multilistpref_a'),
            CheckboxPreference('B enabled', 'android_multilistpref_b'),
            CheckboxPreference('C enabled', 'android_multilistpref_c'),
          ],
          title: 'Select multiple options',
          cancelText: 'Cancel',
          submitText: 'Save',
          onlySaveOnSubmit: true,
        ),
      ),
      PreferenceHider([
        PreferenceTitle('Experimental'),
        SwitchPreference(
          'Show Operating System',
          'exp_showos',
          desc: 'This option shows the users operating system in his profile',
        )
      ], '!advanced_enabled'), // Use ! to get reversed boolean values
      PreferenceTitle('Advanced'),
      CheckboxPreference(
        'Enable Advanced Features',
        'advanced_enabled',
        onChange: () {},
        onDisable: () {
          PrefService.setBool('exp_showos', false);
        },
      )
    ]);
  }
}

// DropdownPreference<int>(
//   'Number of items',
//   'items_count',
//   defaultVal: 2,
//   displayValues: ['One', 'Two', 'Three', 'Four'],
//   values: [1, 2, 3, 4],
// ),

// RadioPreference(
//   'Light Theme',
//   'light',
//   'ui_theme',
//   isDefault: true,
//   onSelect: () {
//     DynamicTheme.of(context).setBrightness(Brightness.light);
//   },
// ),
// PreferenceTitle('Messaging'),
// PreferencePageLink(
//   'Notifications',
//   leading: Icon(Icons.message),
//   trailing: Icon(Icons.keyboard_arrow_right),
//   page: PreferencePage([
//     PreferenceTitle('New Posts'),
//     SwitchPreference(
//       'New Posts from Friends',
//       'notification_newpost_friend',
//       defaultVal: true,
//     ),
//     PreferenceTitle('Private Messages'),
//     SwitchPreference(
//       'Private Messages from Friends',
//       'notification_pm_friend',
//       defaultVal: true,
//     ),
//     SwitchPreference(
//       'Private Messages from Strangers',
//       'notification_pm_stranger',
//       onEnable: () async {
//         // Write something in Firestore or send a request
//         await Future.delayed(Duration(seconds: 1));

//         print('Enabled Notifications for PMs from Strangers!');
//       },
//       onDisable: () async {
//         // Write something in Firestore or send a request
//         await Future.delayed(Duration(seconds: 1));

//         // No Connection? No Problem! Just throw an Exception with your custom message...
//         throw Exception('No Connection');

//         // Disabled Notifications for PMs from Strangers!
//       },
//     ),
//   ]),
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
