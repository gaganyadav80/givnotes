import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key key, this.trailing}) : super(key: key);

  final IconData trailing;

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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _appBarTitle[state.index],
                    style: GoogleFonts.sourceSerifPro(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      // letterSpacing: -0.7,s
                      color: const Color(0xff32343D),
                    ),
                  ),
                  state.index == 0
                      ? IconButton(
                          icon: Icon(trailing, size: 28),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
