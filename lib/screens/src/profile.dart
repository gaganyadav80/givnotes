import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:givnotes/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:givnotes/packages/TheGorgeousLogin/gorgeous_login_page.dart';
import 'package:givnotes/services/services.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class MyProfile extends StatelessWidget {
  // bool isAnonymous;
  // final UserStore _userStore = locator.get<UserStore>();

  @override
  Widget build(BuildContext context) {
    // final hm = context.percentHeight;
    // final wm = context.percentWidth;
    final wm = 3.94;
    final hm = 7.6;

    //TODO too much to rebuild... redesign
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) => SafeArea(
        //TODO use computed value for logged out user
        child: state.user.email.isEmptyOrNull == true
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.6 * wm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 48.6 * wm),
                      child: Lottie.asset(
                        'assets/animations/people-portrait.json',
                        height: 24.5 * hm,
                        width: 46.3 * wm,
                      ),
                    ),
                    SizedBox(height: 5 * hm),
                    Text(
                      'Oops!',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 7.5 * wm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.6 * hm),
                    Text(
                      'Looks like you are not logged in.',
                      style: TextStyle(
                        fontSize: 4.7 * wm,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 5 * hm),
                    Container(
                      height: 8 * hm,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(11.58 * wm),
                      ),
                      child: signInButton(isSignOut: false),
                    ),
                    SizedBox(height: 5 * hm),
                    Text(
                      'Not much here, yet. Maybe I\'ll add later.',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                        fontSize: 1.8 * hm,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                    child: Stack(
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.only(top: 8 * hm),
                          elevation: 1 * hm,
                          shadowColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.63 * wm),
                          ),
                          // *Profile Card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 14 * wm),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7 * wm),
                                child: Text(
                                  state.user.name,
                                  //TODO add arizonia font from google
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 4 * hm,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.12 * wm,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7 * wm),
                                child: Text(
                                  state.user.email,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 2.2 * hm,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.5 * hm),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3 * wm),
                                child: signInButton(context: context, isSignOut: true),
                              ),
                              SizedBox(height: 2 * hm),
                            ],
                          ),
                        ),
                        AvatarGlow(
                          glowColor: Colors.black,
                          endRadius: 17.4 * wm,
                          repeat: true,
                          showTwoGlows: true,
                          duration: Duration(seconds: 3),
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Material(
                            elevation: 5,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              radius: 10.5 * wm,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) => FaIcon(FontAwesomeIcons.unlink),
                                  placeholder: (context, url) => CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                  imageUrl: state.user.photo,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 52 * wm,
                    width: double.infinity,
                    child: Image.asset('assets/images/profile.png'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget signInButton({BuildContext context, bool isSignOut}) {
    final hm = context.percentHeight;
    final wm = context.percentWidth;

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: Colors.grey[400],
        )
      ]),
      height: 15 * wm,
      child: GFButton(
        elevation: 2,
        fullWidthButton: true,
        color: Colors.black,
        borderShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3 * wm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              FontAwesomeIcons.google,
              color: Colors.white,
              size: 2.2 * hm,
            ),
            SizedBox(width: 2.6 * wm),
            Text(
              isSignOut == false ? 'Sign in' : 'Sign out',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 3 * hm,
              ),
            ),
          ],
        ),
        onPressed: isSignOut == false
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GorgeousLoginPage(),
                  ),
                );
              }
            : () {
                _signOutAlert(context);
              },
      ),
    );
  }

  _signOutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Please confirm your sign out.'),
          actions: [
            FlatButton(
              child: Text('Cancle'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Confirm"),
              onPressed: () async {
                BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested());

                prefsBox.isAnonymous = true;
                prefsBox.save();
              },
            ),
          ],
        );
      },
    );
  }
}
