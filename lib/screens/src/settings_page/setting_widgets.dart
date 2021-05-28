import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/models/models.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/widgets.dart';
import 'package:lottie/lottie.dart';

class SortNotesFloatModalSheet extends StatelessWidget {
  final TextStyle _kListItemStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    color: Color(0xFF222222),
    fontSize: 15.w,
  );

  final double _kIconSize = 24.w;

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit _prefsCubit = BlocProvider.of<HydratedPrefsCubit>(context);

    var def = _prefsCubit.state.sortBy.obs;

    return PreferenceText(
      "Sort Notes",
      style: TextStyle(fontWeight: FontWeight.w500),
      titleGap: 0.0,
      leading: Icon(CupertinoIcons.text_alignright, size: _kIconSize, color: Color(0xff606060)),
      trailing: Container(
        width: 200.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Obx(
                () => Text(
                  sortbyNames[def.value],
                  style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 15.w, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Icon(CupertinoIcons.forward, size: 21.w, color: Color(0xFF0A0A0A)),
          ],
        ),
      ),
      onTap: () => showFloatingModalBottomSheet(
        context: context,
        builder: (context) => Material(
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoNavigationBar(
                  automaticallyImplyLeading: false,
                  padding: EdgeInsetsDirectional.zero,
                  border: Border.all(color: Colors.white, width: 0.0),
                  backgroundColor: Colors.white,
                  middle: Text(
                    "SORT NOTES",
                    style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF222222), fontSize: 18.w),
                  ),
                  trailing: IconButton(
                    icon: Icon(CupertinoIcons.clear, color: Color(0xFFA0A0A0)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Creation Date', style: _kListItemStyle),
                        tileColor: Colors.white,
                        onTap: () {
                          def.value = 0;
                          _prefsCubit.updateSortBy(0);
                        },
                        trailing: def.value == 0 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text('Modification Date', style: _kListItemStyle),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(1);
                          def.value = 1;
                        },
                        trailing: def.value == 1 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text('Alphabetical (A-Z)', style: _kListItemStyle),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(2);
                          def.value = 2;
                        },
                        trailing: def.value == 2 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title: Text('Alphabetical (Z-A)', style: _kListItemStyle),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(3);
                          def.value = 3;
                        },
                        trailing: def.value == 3 ? Icon(CupertinoIcons.checkmark, color: Color(0xFFDD4C4F)) : null,
                      ),
                      tilesDivider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider tilesDivider() {
    return Divider(
      height: 0.0,
      thickness: 1.0,
      indent: 15.w,
    );
  }
}

class ProfileTileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final UserModel user = BlocProvider.of<AuthenticationBloc>(context).user;
    UserModel user = UserModel.empty;
    String photo;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is AuthSuccess) {
          user = state.user;
        } else if (state is AuthNeedsVerification) {
          user = state.user;
        } else if (state is LogoutSuccess) {
          user = state.user;
        }

        if (user.email.isNotEmpty) photo = user.photo;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.w),
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: user.email.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 55.w,
                      backgroundColor: Colors.transparent,
                      child: photo != null
                          ? NetworkImage(photo)
                          : SvgPicture.asset('assets/user-imgs/user$randomUserProfile.svg'),
                    ).pOnly(bottom: 5.w),
                    Text(user.name).text.medium.color(Color(0xff32343d)).size(22.w).make(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(" ${user.email}").text.size(14.w).light.gray400.make(),
                        SizedBox(width: 5.w),
                        !user.verified
                            ? Icon(
                                CupertinoIcons.exclamationmark_circle,
                                color: Colors.red,
                                size: 16.w,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Edit Profile".text.white.size(16.w).make().pSymmetric(h: 5.w),
                        Icon(
                          CupertinoIcons.forward,
                          color: Colors.white,
                          size: 21.w,
                        ),
                      ],
                    )
                        .capsule(backgroundColor: Color(0xff006aff), width: 150.w, height: 45.w)
                        .py12()
                        .onTap(() => Navigator.pushNamed(context, RouterName.profileRoute)),
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
                            padding: EdgeInsets.only(bottom: 10.w),
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
                                fontSize: 18.w,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Click here and login to your account.",
                              style: TextStyle(
                                fontSize: 13.w,
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(CupertinoIcons.forward, color: Color(0xFF0A0A0A)),
                  ],
                ).onTap(() => Navigator.pushNamed(context, RouterName.profileRoute)),
        );
      },
    );
  }
}

class SettingsTileDivider extends StatelessWidget {
  const SettingsTileDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: 20.w,
      indent: 20.w,
      thickness: 0.5,
      height: 5.w,
    );
  }
}
