import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:givnotes/cubit/cubits.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/services/services.dart';

import 'style/theme.dart';
import 'utils/bubble_indication_painter.dart';

class GorgeousLoginPage extends StatefulWidget {
  GorgeousLoginPage({Key key}) : super(key: key);

  // static Route route() {
  //   return MaterialPageRoute<void>(builder: (_) => GorgeousLoginPage());
  // }

  @override
  _GorgeousLoginPageState createState() => _GorgeousLoginPageState();
}

class _GorgeousLoginPageState extends State<GorgeousLoginPage> with SingleTickerProviderStateMixin {
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupConfirmPasswordController = TextEditingController();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeConfirm = FocusNode();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  double _height = 0.0;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      backgroundColor: Color(0xFFf7418c),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [GorgeousLoginColors.loginGradientStart, GorgeousLoginColors.loginGradientEnd],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Image(
                      width: _height < 6.60 ? 133 : 200.0,
                      height: _height < 6.60 ? 100 : 150.0,
                      fit: BoxFit.fill,
                      image: AssetImage('assets/img/login_logo.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (i) {
                        if (i == 0) {
                          //TODO remove
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignIn(context),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignUp(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePasswordLogin?.dispose();
    myFocusNodeEmailLogin?.dispose();
    myFocusNodeConfirm?.dispose();
    myFocusNodeEmail?.dispose();
    myFocusNodeName?.dispose();
    myFocusNodePassword?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(BuildContext context, String value) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: _height < 6.60 ? 250 : 300.0,
      height: _height < 6.60 ? 40 : 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(
          pageController: _pageController,
          radius: _height < 6.60 ? 16.8 : 21.0,
          dxTarget: _height < 6.60 ? 104.2 : 125.0,
          dxEntry: _height < 6.60 ? 20.9 : 25.0,
          dy: _height < 6.60 ? 20.0 : 25.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                    color: left,
                    fontSize: _height < 6.60 ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    // fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                    color: right,
                    fontSize: _height < 6.60 ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showInSnackBar(context, "Login Failure");
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: _height < 6.60 ? 10.0 : 20.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: _height < 6.60 ? 150.0 : 180.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _height < 6.60 ? 15.0 : 20.0,
                            vertical: _height < 6.60 ? 5.0 : 10.0,
                          ),
                          child: TextField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            onSubmitted: (_) => myFocusNodePasswordLogin.requestFocus(),
                            onChanged: (email) => BlocProvider.of<AuthCubit>(context).loginEmailChanged(email),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 20.0,
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 260.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _height < 6.60 ? 15.0 : 20.0,
                            vertical: _height < 6.60 ? 5.0 : 10.0,
                          ),
                          child: BlocBuilder<AuthCubit, AuthState>(
                            // buildWhen: (previous, current) => previous.status != current.status,
                            builder: (context, state) {
                              return TextField(
                                focusNode: myFocusNodePasswordLogin,
                                controller: loginPasswordController,
                                obscureText: state.obscureTextLogin,
                                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                                onChanged: (pass) => BlocProvider.of<AuthCubit>(context).loginPasswordChanged(pass),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
                                  suffixIcon: GestureDetector(
                                    onTap: () => context.read<AuthCubit>().obscureChanged(!state.obscureTextLogin, 1),
                                    child: Icon(
                                      state.obscureTextLogin ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: _height < 6.60 ? 130.0 : 160.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: GorgeousLoginColors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: GorgeousLoginColors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        GorgeousLoginColors.loginGradientEnd,
                        GorgeousLoginColors.loginGradientStart,
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (previous, current) => previous.status != current.status,
                    builder: (context, state) {
                      return MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: GorgeousLoginColors.loginGradientEnd,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: _height < 6.60 ? 7.0 : 10.0,
                            horizontal: _height < 6.60 ? 30.0 : 42.0,
                          ),
                          child: state.status.isSubmissionInProgress
                              ? const CupertinoActivityIndicator()
                              : Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _height < 6.60 ? 22.0 : 25.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          String email = loginEmailController.text;
                          String password = loginPasswordController.text;

                          BlocProvider.of<AuthCubit>(context)
                            ..loginEmailChanged(email)
                            ..loginPasswordChanged(password);

                          if (email.isEmpty || password.isEmpty) {
                            showInSnackBar(context, "Looks like you forgot some fields.");
                          } else if (state.email.invalid) {
                            showInSnackBar(context, "Invalid email");
                          } else if (state.status.isValidated) {
                            BlocProvider.of<AuthCubit>(context).logInWithCredentials();
                          } else {
                            showInSnackBar(context, "Something went wrong :(");
                          }
                        },
                        // onLongPress: () async {
                        //   FocusScope.of(context).unfocus();

                        //   if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
                        //     showInSnackBar(context, "Please fill all the fields");
                        //   } else {
                        //     await signInWithEmail(
                        //       loginEmailController.text.trim(),
                        //       loginPasswordController.text,
                        //     ).then((value) async {
                        //       prefsBox.isAnonymous = false;
                        //       //TODO set this after introduction bubble to features ## do for all
                        //       prefsBox.firstlaunch = false;
                        //       prefsBox.save();
                        //       // _userStore.updateCurrentUser(value);

                        //       //FIXME does not show... directs to new page ## do for all,
                        //       showInSnackBar(context, "Login with email succesfull");

                        //       await HandlePermission().requestPermission();

                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => HomePage(),
                        //         ),
                        //       );
                        //     }).catchError((e) {
                        //       String error = e.toString();
                        //       print("============ ");
                        //       //TODO add more checks for all methods
                        //       if (error.contains("no user record")) {
                        //         showInSnackBar(context, "Invalid credentials");
                        //       }
                        //     });
                        //   }
                        // },
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                onPressed: () {
                  showInSnackBar(context, "If an account with that email exists, you will receive a password reset link shortly.");
                  if (loginEmailController.text.isNotEmpty) {
                    BlocProvider.of<AuthCubit>(context)
                      ..loginEmailChanged(loginEmailController.text)
                      ..resetPassword();
                  } else
                    showInSnackBar(context, "Please type your email and try again");
                },
                // onLongPress: () {
                //   if (loginEmailController.text.isEmpty) {
                //     showInSnackBar(context, "Please type your email and try again");
                //   } else {
                //     resetPassword(loginEmailController.text.trim());
                //   }
                // },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      "Or",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 40.0),
                  child: GestureDetector(
                    onTap: () => showInSnackBar(context, "Apple login coming soon"),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        FontAwesomeIcons.apple,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () => BlocProvider.of<AuthCubit>(context).logInWithGoogle(),
                    // onLongPress: () {
                    //   signInWithGoogle().then((value) async {
                    //     if (value.email.isNotEmpty) {
                    //       prefsBox.isAnonymous = false;
                    //       prefsBox.firstlaunch = false;
                    //       prefsBox.save();

                    //       // _userStore.updateCurrentUser(value);

                    //       showInSnackBar(context, "Google login successfull");
                    //       await HandlePermission().requestPermission();

                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => HomePage(),
                    //         ),
                    //       );
                    //     }
                    //   }).catchError(() {
                    //     showInSnackBar(context, "Google login failed :(");
                    //   });
                    // },
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 40.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text('You will miss the reward. Are you sure?'),
                            actions: [
                              FlatButton(
                                child: Text('Cancle'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () async {
                                  //TODO implement as per bloc authentication
                                  // Navigator.pop(context);
                                  // await anonymousSignIn().then((value) async {

                                  // }).catchError((_) {
                                  //   showInSnackBar("Login failed");
                                  // });
                                  prefsBox.isAnonymous = true;
                                  prefsBox.firstlaunch = false;
                                  prefsBox.save();

                                  // _userStore.updateCurrentUser(null);

                                  showInSnackBar(context, "Anonymous login successfull");

                                  await HandlePermission().requestPermission();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        FontAwesomeIcons.userSecret,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showInSnackBar(context, "Sign up failure");
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: _height < 6.60 ? 10.0 : 20.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: _height < 6.60 ? 270.0 : 320.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _height < 6.60 ? 15.0 : 20.0,
                            vertical: _height < 6.60 ? 5.0 : 10.0,
                          ),
                          child: TextField(
                            focusNode: myFocusNodeName,
                            controller: signupNameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            onSubmitted: (_) => myFocusNodeEmail.requestFocus(),
                            onChanged: (name) => BlocProvider.of<AuthCubit>(context).signupNameChanged(name),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                                size: 20.0,
                              ),
                              hintText: "Name",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 260.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _height < 6.60 ? 15.0 : 20.0,
                            vertical: _height < 6.60 ? 5.0 : 10.0,
                          ),
                          child: TextField(
                            focusNode: myFocusNodeEmail,
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (email) => BlocProvider.of<AuthCubit>(context).signupEmailChanged(email),
                            onSubmitted: (_) => myFocusNodePassword.requestFocus(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                size: 20.0,
                                color: Colors.black,
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 260.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _height < 6.60 ? 15.0 : 20.0,
                            vertical: _height < 6.60 ? 5.0 : 10.0,
                          ),
                          child: BlocBuilder<AuthCubit, AuthState>(
                            // buildWhen: (previous, current) => previous.status != current.status,
                            builder: (context, state) {
                              return TextField(
                                focusNode: myFocusNodePassword,
                                controller: signupPasswordController,
                                obscureText: state.obscureTextSignup,
                                onSubmitted: (_) => myFocusNodeConfirm.requestFocus(),
                                onChanged: (pass) => BlocProvider.of<AuthCubit>(context).signupPasswordChanged(pass),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                    size: 20.0,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () => BlocProvider.of<AuthCubit>(context).obscureChanged(!state.obscureTextSignup, 2),
                                    child: Icon(
                                      state.obscureTextSignup ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 260.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _height < 6.60 ? 15.0 : 20.0,
                            vertical: _height < 6.60 ? 5.0 : 10.0,
                          ),
                          child: BlocBuilder<AuthCubit, AuthState>(
                            // buildWhen: (previous, current) => previous.status != current.status,
                            builder: (context, state) {
                              return TextField(
                                focusNode: myFocusNodeConfirm,
                                controller: signupConfirmPasswordController,
                                obscureText: state.obscureTextSignupConfirm,
                                onChanged: (confirm) => BlocProvider.of<AuthCubit>(context).confirmPasswordChanged(confirm),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  hintText: "Confirmation",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () => BlocProvider.of<AuthCubit>(context).obscureChanged(!state.obscureTextSignupConfirm, 3),
                                    child: Icon(
                                      state.obscureTextSignupConfirm ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: _height < 6.60 ? 250.0 : 300.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: GorgeousLoginColors.loginGradientStart,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: GorgeousLoginColors.loginGradientEnd,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        GorgeousLoginColors.loginGradientEnd,
                        GorgeousLoginColors.loginGradientStart,
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (previous, current) => previous.status != current.status,
                    builder: (context, state) {
                      return MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: GorgeousLoginColors.loginGradientEnd,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: _height < 6.60 ? 7.0 : 10.0,
                            horizontal: _height < 6.60 ? 30.0 : 42.0,
                          ),
                          child: state.status.isSubmissionInProgress
                              ? const CupertinoActivityIndicator()
                              : Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _height < 6.60 ? 22.0 : 25.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          String email = signupEmailController.text.trim();
                          String password = signupPasswordController.text;
                          String name = signupNameController.text.trim();

                          BlocProvider.of<AuthCubit>(context)
                            ..signupPasswordChanged(password)
                            ..signupNameChanged(name)
                            ..signupEmailChanged(email);

                          print(state.email.invalid);

                          if (email.isEmpty || name.isEmpty || password.isEmpty) {
                            showInSnackBar(context, "Looks like you forget some fields.");
                          } else if (state.email.invalid) {
                            showInSnackBar(context, "That email looks invalid");
                          } else if (state.confirmedPassword.invalid) {
                            //TODO add error text below text field
                            showInSnackBar(context, "Passwords do not match");
                          } else if (state.status.isValidated) {
                            BlocProvider.of<AuthCubit>(context).signUpFormSubmitted();
                          } else {
                            showInSnackBar(context, "Something went wrong :(");
                          }
                        },
                        // onLongPress: () async {
                        //   FocusScope.of(context).unfocus();
                        //   String email = signupEmailController.text.trim();
                        //   String password = signupPasswordController.text;
                        //   String confirmPassword = signupConfirmPasswordController.text;
                        //   String name = signupNameController.text.trim();

                        //   if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty && confirmPassword.isNotEmpty) {
                        //     if (!email.isEmail) {
                        //       showInSnackBar(context, "That email looks invalid");
                        //     } else if (password != confirmPassword) {
                        //       showInSnackBar(context, "Passwords do not match");
                        //     } else {
                        //       await signUpWithEmail(email, password, name).then((value) async {
                        //         prefsBox.isAnonymous = false;
                        //         prefsBox.firstlaunch = false;
                        //         prefsBox.save();
                        //         //TODO uncomment
                        //         // _userStore.updateCurrentUser(value);

                        //         showInSnackBar(context, "Email singup successfull");

                        //         await HandlePermission().requestPermission();

                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //     builder: (context) => HomePage(),
                        //         //   ),
                        //         // );
                        //       }).catchError(() {
                        //         showInSnackBar(context, "Email signup failed :(");
                        //       });
                        //     }
                        //   } else {
                        //     showInSnackBar(context, "Looks like you forget some fields.");
                        //   }
                        // },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
