import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/themes/app_themes.dart';
import 'package:givnotes/services/services.dart';
import 'package:lottie/lottie.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: GiveStatusBarColor(context),
      ),
    );
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: PreferencePage([
          ProfileTileSettings(),
          PreferenceTitle('General', topPadding: 10.0),
          DropdownPreference(
            'Sort notes',
            'sort_notes',
            defaultVal: def,
            desc: "Sort your notes on one of the following filters.",
            showDesc: false,
            values: ['Date created', 'Date modified', 'Alphabetical (A-Z)', 'Alphabetical (Z-A)'],
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            // leading: Icon(
            //   CupertinoIcons.sort_down_circle,
            //   color: Theme.of(context).textTheme.bodyText1.color,
            //   size: 20.0,
            // ),
            leadingColor: Colors.red,
            leading: Icon(
              Icons.sort_rounded,
              color: Theme.of(context).textTheme.bodyText1.color,
              size: 20.0,
            ),
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
            // desc: 'Enable compact tags in notes view',
            desc: "For the minimalistic.",
            defaultVal: _prefsCubit.state.compactTags,
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            // leading: Icon(CupertinoIcons.bars, color: Colors.white, size: 20.0),
            leadingColor: Colors.blue,
            leading: Icon(
              CupertinoIcons.bars,
              color: Theme.of(context).textTheme.bodyText1.color,
              size: 20.0,
            ),
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
            // desc: "Switch between light and dark mode",
            desc: "So now the fun begins.",
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            // leading: Icon(CupertinoIcons.moon, color: Colors.white, size: 20.0),
            leadingColor: Colors.purple,
            leading: Icon(
              CupertinoIcons.moon,
              color: Theme.of(context).textTheme.bodyText1.color,
              size: 20.0,
            ),
            titleGap: 0.0,
            onChange: ((value) {
              print(value);
            }),
          ),
          DropdownPreference(
            'Dark theme',
            'dark_theme',
            disabled: true,
            desc: "Spice up your theme",
            defaultVal: 'Darkish grey',
            values: ['Darkish grey', 'Blueberry black', 'Shades of purple'],
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            // leading: Icon(CupertinoIcons.at, color: Colors.white, size: 20.0),
            leadingColor: Colors.pink,

            leading: Icon(
              CupertinoIcons.at,
              color: Theme.of(context).textTheme.bodyText1.color,
              size: 20.0,
            ),
            titleGap: 0.0,
            onChange: ((value) {
              print(value);
            }),
          ),
          PreferencePageLink(
            'Extensions',
            desc: 'Extend your experience.',
            disabled: true,
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            style: TextStyle(color: const Color(0xff32343D), fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.bolt, color: Theme.of(context).textTheme.bodyText1.color, size: 20.0),
            leadingColor: Colors.brown,
            trailing: Icon(Icons.keyboard_arrow_right),
            titleGap: 0.0,
            widgetScaffold: AboutGivnotes(),
          ),
          PreferenceTitle('Security'),
          AppLockSwitchPrefs(),
          PreferenceText(
            'Change Passcode',
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.lock_shield, color: Theme.of(context).textTheme.bodyText1.color, size: 20.0),
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
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.app, color: Theme.of(context).textTheme.bodyText1.color, size: 20.0),
            leadingColor: Colors.grey,
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            trailing: Icon(Icons.keyboard_arrow_right),
            titleGap: 0.0,
            widgetScaffold: AppDetailSection(),
          ),
          PreferencePageLink(
            'About Us',
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.person, color: Theme.of(context).textTheme.bodyText1.color, size: 20.0),
            leadingColor: Colors.brown,
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            trailing: Icon(Icons.keyboard_arrow_right),
            titleGap: 0.0,
            widgetScaffold: AboutGivnotes(),
          ),
          PreferencePageLink(
            'Contact Us',
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontWeight: FontWeight.w600),
            leading: Icon(CupertinoIcons.chat_bubble, color: Theme.of(context).textTheme.bodyText1.color, size: 20.0),
            leadingColor: Colors.blueGrey,
            titleColor: Theme.of(context).textTheme.bodyText1.color,
            trailing: Icon(Icons.keyboard_arrow_right),
            titleGap: 0.0,
            widgetScaffold: ContactGivnotes(),
          ),
          SizedBox(height: (10 / 760) * screenHeight),
          //! =============================================
        ]),
      ),
    );
  }
}

class ProfileTileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => MyProfile())),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: (10.0 / 760) * screenHeight),
        margin: EdgeInsets.symmetric(horizontal: (20.0 / 394) * screenWidth),
        child: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: (40.0 / 760) * screenHeight,
                  width: (40.0 / 394) * screenWidth,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              final String photo = snapshot.data.photoURL;
              String initials = '';
              "Gagan Yadav".split(" ").forEach((element) {
                initials = initials + element[0];
              });

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gagan Yadav",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                " ${snapshot.data.email}",
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).textTheme.bodyText2.color,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              !snapshot.data.emailVerified
                                  ? Icon(
                                      CupertinoIcons.exclamationmark_circle,
                                      color: Colors.red,
                                      size: 16.0,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(CupertinoIcons.forward, color: Colors.grey),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundColor: Colors.orange,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: (10 / 760) * screenHeight),
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
                              color: Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Click here and login to your account.",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(CupertinoIcons.forward, color: Colors.grey),
                ],
              );
            }
          },
        ),
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
        title: Text(
          "Application",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
        ),
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 25.0,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, (50 / 760) * screenHeight),
          child: Container(
            // color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: (30.0 / 394) * screenWidth),
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl(
              children: {
                0: Text(
                  "App Info",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                1: Text(
                  "Logs",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
              },
              groupValue: selectedIndex,
              onValueChanged: (value) => setState(() => selectedIndex = value),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          (30.0 / 394) * screenWidth,
          (30 / 760) * screenHeight,
          (30.0 / 394) * screenWidth,
          (50 / 760) * screenHeight,
        ),
        child: _bodyWidgets[selectedIndex],
      ),
    );
  }

  List<Widget> _bodyWidgets = [
    Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("App name: "), Text("${packageInfo.appName}")]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Package: "), Text("${packageInfo.packageName}")]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Build_no: "), Text("${packageInfo.buildNumber}")]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Release version: "), Text("v${packageInfo.version}-beta")]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Development version: "), Text("v2.0.0")]),
      ],
    ),
    Align(alignment: Alignment.topCenter, child: Text("Logs", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))),
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
          titleColor: Theme.of(context).textTheme.bodyText1.color,
          ignoreTileTap: false,
          leading: Icon(CupertinoIcons.lock, color: Theme.of(context).textTheme.bodyText1.color, size: 20.0),
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
          titleColor: Theme.of(context).textTheme.bodyText1.color,
          leading: Icon(
            Icons.fingerprint_outlined,
            color: Theme.of(context).textTheme.bodyText1.color,
            size: 20.0,
          ),
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
