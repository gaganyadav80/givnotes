import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';

import 'setting_widgets.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit _prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);
    final double _kIconSize = 24.w;
    final Color _kIconColor = Color(0xff606060);
    final Color _kTrailingColor = Color(0xFF0A0A0A);

    return SafeArea(
      child: PreferencePage([
        ProfileTileSettings(),
        PreferenceTitle('GENERAL'),
        SortNotesFloatModalSheet(),
        SwitchPreference(
          'Compact tags',
          'compact_tags',
          // desc: "For the minimalistic.",
          defaultVal: _prefsCubit.state.compactTags,
          titleColor: const Color(0xff32343D),
          leading: Icon(CupertinoIcons.rectangle, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.blue,
          titleGap: 0.0,
          onEnable: () => _prefsCubit.updateCompactTags(true),
          onDisable: () => _prefsCubit.updateCompactTags(false),
        ),
        PreferenceTitle('PERSONALIZATION'),
        SwitchPreference(
          'Dark mode',
          'dark_mode',
          disabled: true,
          // desc: "So now the fun begins.",
          titleColor: const Color(0xff32343D),
          leading: Icon(CupertinoIcons.moon, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.purple,
          titleGap: 0.0,
          onChange: ((value) {
            print(value);
          }),
        ),
        DropdownPreference(
          'Dark theme',
          'dark_theme',
          disabled: true,
          // desc: "Spice up your theme",
          defaultVal: 'Darkish grey',
          values: ['Darkish grey', 'Blueberry black', 'Shades of purple'],
          titleColor: const Color(0xff32343D),
          leading: Icon(CupertinoIcons.at, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.pink,
          titleGap: 0.0,
          onChange: ((value) {
            print(value);
          }),
        ),
        PreferencePageLink(
          'Extensions',
          // desc: 'Extend your experience.',
          disabled: true,
          style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w500),
          leading: Icon(CupertinoIcons.bolt, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.brown,
          trailing: Icon(CupertinoIcons.forward, color: _kTrailingColor, size: 21.0),
          titleGap: 0.0,
          widgetScaffold: AboutUsPage(),
        ),
        PreferenceTitle('SECURITY'),
        AppLockSwitchPrefs(),
        PreferenceText(
          'Change Passcode',
          style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w500),
          leading: Icon(CupertinoIcons.lock_shield, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.lightGreen,
          titleGap: 0.0,
          onTap: () {
            if (prefsBox.passcode != '') {
              Navigator.pushNamed(
                context,
                RouterName.lockscreenRoute,
                arguments: () {
                  Navigator.of(context)
                    ..pop()
                    ..pushNamed(RouterName.addlockRoute); //TODO disrupts the view with zoom effect. FIX @Gagan
                },
              );
            } else {
              Fluttertoast.showToast(msg: "Please enable applock first");
            }
          },
        ),
        PreferenceTitle('DETAILS SECTION'),
        PreferencePageLink(
          'Application',
          style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w500),
          leading: Icon(CupertinoIcons.app_badge, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.grey,
          trailing: Icon(CupertinoIcons.forward, color: _kTrailingColor, size: 21.0),
          titleGap: 0.0,
          widgetScaffold: AppDetailSection(),
        ),
        PreferencePageLink(
          'About Us',
          style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w500),
          leading: Icon(CupertinoIcons.person, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.brown,
          trailing: Icon(CupertinoIcons.forward, color: _kTrailingColor, size: 21.0),
          titleGap: 0.0,
          widgetScaffold: AboutUsPage(),
        ),
        PreferencePageLink(
          'Contact Us',
          style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w500),
          leading: Icon(CupertinoIcons.chat_bubble, color: _kIconColor, size: _kIconSize),
          // leadingColor: Colors.blueGrey,
          trailing: Icon(CupertinoIcons.forward, color: _kTrailingColor, size: 21.0),
          titleGap: 0.0,
          widgetScaffold: ContactUsPage(),
        ),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Application", style: TextStyle(color: Colors.black)),
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 25.0,
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.arrow_left, color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.0),
          child: Container(
            // color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl(
              children: {
                0: Text("App Info"),
                1: Text("Logs"),
              },
              groupValue: selectedIndex,
              onValueChanged: (value) => setState(() => selectedIndex = value),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.w, 30.w, 30.w, 50.w),
        child: _bodyWidgets[selectedIndex],
      ),
    );
  }

  List<Widget> _bodyWidgets = [
    Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("App name: "), Text("${packageInfo.appName}")]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Package: "), Text("${packageInfo.packageName}")]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Build_no: "), Text("${packageInfo.buildNumber}")]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Release version: "), Text("v${packageInfo.version}-beta")]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Development version: "), Text("v2.0.0")]),
      ],
    ),
    Align(
        alignment: Alignment.topCenter,
        child: Text("Logs", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))),
  ];
}

class AppLockSwitchPrefs extends StatefulWidget {
  AppLockSwitchPrefs({Key key}) : super(key: key);

  @override
  _AppLockSwitchPrefsState createState() => _AppLockSwitchPrefsState();
}

class _AppLockSwitchPrefsState extends State<AppLockSwitchPrefs> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  bool canUseBiometric = false;
  String reason = '';

  void setBiometricButton() async {
    canUseBiometric = (await _localAuthentication.isDeviceSupported());
    if (canUseBiometric == false) {
      reason = 'Biometrics not enabled';
      return;
    }

    canUseBiometric = (await _localAuthentication.getAvailableBiometrics()).contains(BiometricType.fingerprint);

    if (canUseBiometric == false) {
      reason = 'Biometrics are not enrolled';
    }

    reason = '';
  }

  final double _kIconSize = 26.w;

  @override
  Widget build(BuildContext context) {
    setBiometricButton();

    return Column(
      children: [
        SwitchPreference(
          'Enable app lock',
          'app_lock',
          // desc: 'Add 4 digit pin',
          defaultVal: false,
          ignoreTileTap: false,
          leading: Icon(CupertinoIcons.lock, color: Colors.black, size: _kIconSize),
          // leadingColor: Colors.orangeAccent,
          titleGap: 0.0,
          onEnable: () {
            if (prefsBox.passcode == '') {
              Navigator.pushNamed(context, RouterName.addlockRoute).then((value) {
                if (!value) {
                  PrefService.setBool('app_lock', false);
                  setState(() {});
                }
              });
            }
          },
          onDisable: () {
            if (prefsBox.passcode != '') {
              Navigator.pushNamed(
                context,
                RouterName.lockscreenRoute,
                arguments: () {
                  Navigator.pop(context, true);
                  AppLock.of(context).disable();
                  prefsBox.passcode = '';
                  prefsBox.applock = false;
                  prefsBox.save();
                },
              ).then((value) {
                if (!value) {
                  PrefService.setBool('app_lock', true);
                  setState(() {});
                }
              });
            }
            // setState(() {});
          },
        ),
        SwitchPreference(
          'Biometric authentication',
          'biometric',
          // desc: 'Enable Fingerprint/Face unlock',
          defaultVal: false,
          disabled: canUseBiometric ? !prefsBox.applock : true,
          leading: Icon(Icons.fingerprint_outlined, color: Colors.black, size: _kIconSize),
          // leadingColor: Colors.teal,
          titleGap: 0.0,
          ondisableTap: () {
            if (reason.isNotEmpty) Fluttertoast.showToast(msg: reason);
            // ScaffoldMessenger.of(context)
            //   ..removeCurrentSnackBar()
            //   ..showSnackBar(
            //     SnackBar(content: Text(reason)),
            //   );
          },
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
