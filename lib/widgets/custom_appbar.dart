import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key key, this.title, this.icon}) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Size get preferredSize => Size.fromHeight(65.0);

  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();
    final List<String> _appBarTitle = [
      'Notes',
      'Todos',
      'Tags',
      'Settings',
      'Profile',
      'About Us',
    ];

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          // padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          padding: EdgeInsets.fromLTRB(0.050761421 * screenSize.width, 0.013157895 * screenSize.height, 0.050761421 * screenSize.width, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title != null
                  ? Text(
                      title,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.7,
                      ),
                    )
                  : BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Text(
                          _appBarTitle[state.index],
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.7,
                          ),
                        );
                      },
                    ),
              icon != null
                  ? IconButton(
                      icon: Icon(icon, size: 28),
                      splashColor: Colors.grey[300],
                      splashRadius: 25.0,
                      key: key,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                          // ConcentricPageRoute(
                          //   builder: (context) => SearchPage(),
                          //   radius: -1,
                          //   dy: 60,
                          //   dx: 170,
                          // ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
