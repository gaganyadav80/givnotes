import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/models/models.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/widgets.dart';

class SortNotesFloatModalSheet extends StatelessWidget {
  final TextStyle _kListItemStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    color: const Color(0xFF222222),
    fontSize: 15.w,
  );

  final double _kIconSize = 24.w;

  SortNotesFloatModalSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HydratedPrefsCubit _prefsCubit =
        BlocProvider.of<HydratedPrefsCubit>(context);

    var def = _prefsCubit.state.sortby.obs;

    return PreferenceText(
      "Sort Notes",
      style: const TextStyle(fontWeight: FontWeight.w500),
      titleGap: 0.0,
      leading: Icon(CupertinoIcons.text_alignright,
          size: _kIconSize, color: const Color(0xff606060)),
      trailing: SizedBox(
        width: 200.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Obx(
                () => Text(
                  VariableService().sortbyNames[def.value],
                  style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 15.w,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Icon(CupertinoIcons.forward,
                size: 21.w, color: const Color(0xFF0A0A0A)),
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
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222222),
                        fontSize: 18.w),
                  ),
                  trailing: IconButton(
                    icon: const Icon(CupertinoIcons.clear,
                        color: Color(0xFFA0A0A0)),
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
                        trailing: def.value == 0
                            ? const Icon(CupertinoIcons.checkmark,
                                color: Color(0xFFDD4C4F))
                            : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title:
                            Text('Modification Date', style: _kListItemStyle),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(1);
                          def.value = 1;
                        },
                        trailing: def.value == 1
                            ? const Icon(CupertinoIcons.checkmark,
                                color: Color(0xFFDD4C4F))
                            : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title:
                            Text('Alphabetical (A-Z)', style: _kListItemStyle),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(2);
                          def.value = 2;
                        },
                        trailing: def.value == 2
                            ? const Icon(CupertinoIcons.checkmark,
                                color: Color(0xFFDD4C4F))
                            : null,
                      ),
                      tilesDivider(),
                      ListTile(
                        title:
                            Text('Alphabetical (Z-A)', style: _kListItemStyle),
                        tileColor: Colors.white,
                        onTap: () {
                          _prefsCubit.updateSortBy(3);
                          def.value = 3;
                        },
                        trailing: def.value == 3
                            ? const Icon(CupertinoIcons.checkmark,
                                color: Color(0xFFDD4C4F))
                            : null,
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
  const ProfileTileSettings({Key key}) : super(key: key);

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
                    Hero(
                      tag: 'profile-pic',
                      child: CircleAvatar(
                        radius: 55.w,
                        backgroundColor: Colors.transparent,
                        child: photo != null
                            ? NetworkImage(photo)
                            : SvgPicture.asset(
                                'assets/user-imgs/user${VariableService().randomUserProfile}.svg'),
                      ).pOnly(bottom: 5.w),
                    ),
                    Text(user.name)
                        .text
                        .medium
                        .color(const Color(0xff32343d))
                        .size(22.w)
                        .make(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(" ${user.email}")
                            .text
                            .size(14.w)
                            .light
                            .gray400
                            .make(),
                        SizedBox(width: 5.w),
                        !user.verified
                            ? Icon(
                                CupertinoIcons.exclamationmark_circle,
                                color: Colors.red,
                                size: 16.w,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Edit Profile"
                            .text
                            .white
                            .size(16.w)
                            .make()
                            .pSymmetric(h: 5.w),
                        Icon(
                          CupertinoIcons.forward,
                          color: Colors.white,
                          size: 21.w,
                        ),
                      ],
                    )
                        .capsule(
                            backgroundColor: const Color(0xff006aff),
                            width: 150.w,
                            height: 45.w)
                        .py12()
                        .onTap(() => Navigator.pushNamed(
                            context, RouterName.profileRoute)),
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
                            child: Lottie.asset(
                                'assets/animations/people-portrait.json'),
                          ),
                        ),
                        // SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You are not logged in!",
                              style: TextStyle(
                                color:
                                    const Color(0xff32343D).withOpacity(0.85),
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
                    const Icon(CupertinoIcons.forward,
                        color: Color(0xFF0A0A0A)),
                  ],
                ).onTap(
                  () => Navigator.pushNamed(context, RouterName.profileRoute)),
        );
      },
    );
  }
}
