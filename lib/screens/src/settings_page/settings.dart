import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/models/models.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';

import 'setting_widgets.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit _prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
        child: PreferencePage([
          PreferenceTitle('Profile', topPadding: 10.0.w),
          ProfileTileSettings(),
          PreferenceTitle('General', topPadding: 10.0.w),
          SortNotesFloatModalSheet(),
          SwitchPreference(
            'Compact tags',
            'compact_tags',
            // desc: "For the minimalistic.",
            defaultVal: _prefsCubit.state.compactTags,
            titleColor: const Color(0xff32343D),
            leading: Icon(CupertinoIcons.bars, color: Colors.black, size: 26.0.w),
            // leadingColor: Colors.blue,
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
            // desc: "So now the fun begins.",
            titleColor: const Color(0xff32343D),
            leading: Icon(CupertinoIcons.moon, color: Colors.black, size: 26.0.w),
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
            leading: Icon(CupertinoIcons.at, color: Colors.black, size: 26.0.w),
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
            style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.bolt, color: Colors.black, size: 26.0.w),
            // leadingColor: Colors.brown,
            trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xFFDD4C4F)),
            titleGap: 0.0,
            widgetScaffold: AboutUsPage(),
          ),
          PreferenceTitle('Security'),
          AppLockSwitchPrefs(),
          PreferenceText(
            'Change Passcode',
            style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.lock_shield, color: Colors.black, size: 26.0.w),
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
                Toast.show("Please enable applock first", context);
              }
            },
          ),

          // !! ========================================================

          PreferenceTitle('Details Section'),
          PreferencePageLink(
            'Application',
            style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.app, color: Colors.black, size: 26.0.w),
            // leadingColor: Colors.grey,
            trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xFFDD4C4F)),
            titleGap: 0.0,
            widgetScaffold: AppDetailSection(),
          ),
          PreferencePageLink(
            'About Us',
            style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.person, color: Colors.black, size: 26.0.w),
            // leadingColor: Colors.brown,
            trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xFFDD4C4F)),
            titleGap: 0.0,
            widgetScaffold: AboutUsPage(),
          ),
          PreferencePageLink(
            'Contact Us',
            style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.chat_bubble, color: Colors.black, size: 26.0.w),
            // leadingColor: Colors.blueGrey,
            trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xFFDD4C4F)),
            titleGap: 0.0,
            widgetScaffold: ContactUsPage(),
          ),
          SizedBox(height: 10.0.w),
          //! =============================================
        ]),
      ),
    );
  }
}

class ProfileTileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final UserModel user = BlocProvider.of<AuthenticationBloc>(context).user;
    UserModel user = UserModel.empty;
    String photo;
    String initials = '';

    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: () => Navigator.pushNamed(context, RouterName.profileRoute),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is AuthSuccess) {
            user = state.user;
          } else if (state is AuthNeedsVerification) {
            user = state.user;
          } else if (state is LogoutSuccess) {
            user = state.user;
          }

          if (user.email.isNotEmpty) {
            initials = "";
            photo = user.photo;
            user.name.split(" ").forEach((element) {
              initials = initials + element[0];
            });
          }

          return Container(
            height: 90.0.w,
            padding: EdgeInsets.symmetric(vertical: 10.0.w),
            margin: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: user.email.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35.0.w,
                            backgroundColor: Colors.black,
                            backgroundImage: photo != null ? NetworkImage(photo) : null,
                            child: photo == null
                                ? Text(
                                    initials,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 24.0.w,
                                      letterSpacing: 1.5.w,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                          SizedBox(width: 20.0.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyText1.color,
                                  fontSize: 18.0.w,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    " ${user.email}",
                                    style: TextStyle(
                                      fontSize: 13.0.w,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(width: 5.0.w),
                                  !user.verified
                                      ? Icon(
                                          CupertinoIcons.exclamationmark_circle,
                                          color: Colors.red,
                                          size: 16.0.w,
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(CupertinoIcons.forward, color: Color(0xFFDD4C4F)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35.0,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0.w),
                              child: Lottie.asset('assets/animations/people-portrait.json'),
                            ),
                          ),
                          // SizedBox(width: 10.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You are not logged in!",
                                style: TextStyle(
                                  color: const Color(0xff32343D).withOpacity(0.85),
                                  fontSize: 18.0.w,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Click here and login to your account.",
                                style: TextStyle(
                                  fontSize: 13.0.w,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(CupertinoIcons.forward, color: Color(0xFFDD4C4F)),
                    ],
                  ),
          );
        },
      ),
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
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
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
        padding: EdgeInsets.fromLTRB(30.0.w, 30.0.w, 30.0.w, 50.0.w),
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
          leading: Icon(CupertinoIcons.lock, color: Colors.black, size: 26.0.w),
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
          leading: Icon(Icons.fingerprint_outlined, color: Colors.black, size: 26.0.w),
          // leadingColor: Colors.teal,
          titleGap: 0.0,
          ondisableTap: () {
            if (reason.isNotEmpty) Toast.show(reason, context);
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
