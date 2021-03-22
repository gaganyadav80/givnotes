import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/screens/screens.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final IconData trailing;

  const CustomAppBar({Key key, this.trailing}) : super(key: key);
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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            _appBarTitle[state.index],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              // letterSpacing: -0.7,s
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
            // style: GoogleFonts.sourceSerifPro(
            //   fontSize: 42,
            //   fontWeight: FontWeight.w700,
            //   // letterSpacing: -0.7,s
            //   color: Theme.of(context).textTheme.bodyText1.color,
            // ),
          ),
          actions: [
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
    );
  }
}
