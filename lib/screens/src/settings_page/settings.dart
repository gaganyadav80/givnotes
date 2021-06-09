import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/services/services.dart';

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
            if (VariableService().prefsBox.passcode != '') {
              Navigator.pushNamed(
                context,
                RouterName.lockscreenRoute,
                arguments: () {
                  Navigator.of(context).pushReplacementNamed(RouterName.addlockRoute);
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

class AppDetailSection extends StatelessWidget {
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 25.0,
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back, color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 40.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            width: double.infinity,
            child: Obx(() => CupertinoSlidingSegmentedControl(
                  children: {
                    0: Text("App Info"),
                    1: Text("Logs"),
                  },
                  groupValue: selectedIndex.value,
                  onValueChanged: (value) => selectedIndex.value = value,
                )),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.w, 30.w, 30.w, 50.w),
        child: Obx(() => _bodyWidgets[selectedIndex.value]),
      ),
    );
  }

  final List<Widget> _bodyWidgets = [
    Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("App name: "), Text("${VariableService().packageInfo.appName}")]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Package: "), Text("${VariableService().packageInfo.packageName}")]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Build_no: "), Text("${VariableService().packageInfo.buildNumber}")]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Release version: "), Text("v${VariableService().packageInfo.version}-beta")]),
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

  RxBool canUseBiometric = false.obs;
  String reason = '';

  void setBiometricButton() async {
    canUseBiometric.value = (await _localAuthentication.isDeviceSupported());
    if (canUseBiometric.value == false) {
      reason = 'Biometrics not enabled';
      return;
    }

    canUseBiometric.value = (await _localAuthentication.getAvailableBiometrics()).contains(BiometricType.fingerprint);

    if (canUseBiometric.value == false) {
      reason = 'Biometrics are not enrolled';
    }

    reason = '';
  }

  final double _kIconSize = 26.w;
  final VariableService _variableService = VariableService();

  @override
  Widget build(BuildContext context) {
    setBiometricButton();

    return Column(
      children: [
        SwitchPreference(
          'Enable app lock',
          'app_lock',
          defaultVal: false,
          ignoreTileTap: false,
          leading: Icon(CupertinoIcons.lock, color: Colors.black, size: _kIconSize),
          // leadingColor: Colors.orangeAccent,
          titleGap: 0.0,
          isWaitSwitch: true,
          onEnable: () {
            if (_variableService.prefsBox.passcode == '') {
              Navigator.pushNamed(context, RouterName.addlockRoute).then((value) {
                if (value) {
                  setState(() {
                    PrefService.setBool('app_lock', true);
                  });
                }
              });
            }
          },
          onDisable: () {
            if (_variableService.prefsBox.passcode != '') {
              Navigator.pushNamed(
                context,
                RouterName.lockscreenRoute,
                arguments: () {
                  AppLock.of(context).disable();
                  _variableService.prefsBox.passcode = '';
                  _variableService.prefsBox.save();
                  Navigator.pop(context, true);
                },
              ).then((value) {
                if (value) {
                  setState(() {
                    PrefService.setBool('app_lock', false);
                  });
                }
              });
            }
          },
        ),
        Obx(() => SwitchPreference(
              'Biometric authentication',
              'biometric',
              defaultVal: false,
              disabled: canUseBiometric.value ? _variableService.prefsBox.passcode.isEmpty : true,
              leading: Icon(Icons.fingerprint_outlined, color: Colors.black, size: _kIconSize),
              // leadingColor: Colors.teal,
              titleGap: 0.0,
              ondisableTap: () {
                if (reason.isNotEmpty) Fluttertoast.showToast(msg: reason);
              },
              onEnable: () {
                _variableService.prefsBox.biometric = true;
                _variableService.prefsBox.save();
              },
              onDisable: () {
                _variableService.prefsBox.biometric = false;
                _variableService.prefsBox.save();
              },
            )),
      ],
    );
  }
}
