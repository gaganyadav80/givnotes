import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/models/models.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/services/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  authInitial,
  loginInProgress,
  registerInProgress,
  googleAuthInProgress,
  authSuccess,
  authNeedsVerification,
  authFailure,
  logoutInProgress,
  logoutSuccess,
  logoutFailure,
}

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  @override
  void onInit() {
    String userModelJson = DBHelper.userModelJson;
    if (userModelJson.isNotEmpty) {
      userModel.value = UserModel.fromJson(userModelJson);
    }
    // if (firebase_auth.FirebaseAuth.instance.currentUser != null) {
    //   _userModel.value = firebase_auth.FirebaseAuth.instance.currentUser!.toUser;
    //   emailTextController.text = _userModel.value.email;
    //   nameTextController.text = _userModel.value.name ?? "";
    // } else {
    //   _userModel.value = UserModel.empty;
    // }

    ever(userModel, (_) async {
      await DBHelper.updateUserModelJson(userModel.value.toJson());
      update(['settings-profile-tile']);
    });

    ever(authStatus, (status) {
      if (status == AuthStatus.authFailure) {
        showGetSnackBar(
          "Authentication Failure. Please try after some time.",
          icon: const Icon(FluentIcons.people_error_24_regular),
        );
      } else if (status == AuthStatus.authSuccess) {
        showToast("Authentication successfull");
        Get.offAllNamed(RouterName.homeRoute);
      } else if (status == AuthStatus.authNeedsVerification) {
        Get.offAllNamed(RouterName.verificationRoute);
      } else if (status == AuthStatus.logoutSuccess) {
        Get.offAllNamed(RouterName.loginRoute);
      } else if (status == AuthStatus.logoutFailure) {
        showToast('Logout Failed.');
      }
    });

    super.onInit();
  }

  // final CacheClient _cache = CacheClient();
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();

  // static const _userCacheKey = '__user_cache_key__';

  final Rx<AuthStatus> authStatus = AuthStatus.authInitial.obs;
  // final Rx<UserVerifyStatus> userVerifyStatus = UserVerifyStatus.initial.obs;

  final Rx<UserModel> userModel = UserModel.empty.obs;
  UserModel get currentUser => userModel.value;
  set changeUser(UserModel model) => userModel.value = model;

  final RxBool isLoginObscure = false.obs;
  final RxBool isRegisterObscure = false.obs;
  final RxBool isRegisterConfirmObscure = false.obs;

  final nameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passtextController = TextEditingController();
  final confirmPassTextController = TextEditingController();

  void clearTextControllers() {
    nameTextController.clear();
    emailTextController.clear();
    passtextController.clear();
    confirmPassTextController.clear();
  }

  // Stream<UserModel> get user {
  //   return _firebaseAuth.userChanges().map((firebaseUser) {
  //     final user = firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
  //     _cache.write(key: _userCacheKey, value: user);
  //     return user;
  //   });
  // }

  // UserModel get currentUser {
  //   return _cache.read<UserModel>(key: _userCacheKey) ?? UserModel.empty;
  // }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      assert(emailTextController.text.isNotEmpty);
      assert(passtextController.text.isNotEmpty);
      assert(nameTextController.text.isNotEmpty);

      authStatus.value = AuthStatus.registerInProgress;
      update(['register-button']); //TODO: also disable text fields

      final firebase_auth.UserCredential _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passtextController.text,
      );

      await _authResult.user!.updateDisplayName(nameTextController.text);
      await _authResult.user!.reload();
      await _authResult.user!.sendEmailVerification();

      userModel.value = UserModel(
        uid: _authResult.user!.uid,
        name: nameTextController.text,
        email: emailTextController.text,
        photo: _authResult.user!.photoURL,
        createdAt: DateTime.now(),
        verified: false,
        adsPaid: false,
        fullPaid: false,
        isSocialLogin: false,
      );
      await FireDBHelper.addUserToDB(userModel.value);
      await pluginInitializer(_authResult.user!.uid, userKey: passtextController.text);

      authStatus.value = AuthStatus.authNeedsVerification;
      clearTextControllers();
    } on firebase_auth.FirebaseAuthException catch (e) {
      authStatus.value = AuthStatus.authFailure;
      if (e.code == 'weak-password') {
        showGetSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showGetSnackBar('The account already exists for that email.');
      } else {
        log(e.code);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      authStatus.value = AuthStatus.googleAuthInProgress;

      final GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _googleAuth = await _googleUser!.authentication;
      final firebase_auth.OAuthCredential _authCredential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );
      final firebase_auth.UserCredential _userCred = await _firebaseAuth.signInWithCredential(_authCredential);

      bool userExists = await FireDBHelper.checkUserExists(_userCred.user!.uid);

      if (!userExists) {
        userModel.value = UserModel(
          uid: _userCred.user!.uid,
          name: _userCred.user!.displayName,
          email: _userCred.user!.email ?? "",
          photo: _userCred.user!.photoURL,
          createdAt: DateTime.now(),
          verified: true,
          isSocialLogin: true,
          adsPaid: false,
          fullPaid: false,
        );
        await FireDBHelper.addUserToDB(userModel.value);
      } else {
        userModel.value = await FireDBHelper.getUserFromDB(_userCred.user!.uid);
      }

      authStatus.value = AuthStatus.authSuccess;
    } on firebase_auth.FirebaseAuthException catch (e) {
      authStatus.value = AuthStatus.authFailure;
      if (e.code == 'account-exists-with-different-credential') {
        showGetSnackBar('User with this email exists.');
      } else if (e.code == 'invalid-credential') {
        showGetSnackBar('Invalid credentials');
      } else if (e.code == 'user-disabled') {
        showGetSnackBar('This user is disabled. Please contact us for help.');
      } else {
        log(e.code);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logInWithEmailAndPassword() async {
    try {
      authStatus.value = AuthStatus.loginInProgress;
      update(['login-button']);

      firebase_auth.UserCredential _userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passtextController.text,
      );

      userModel.value = await FireDBHelper.getUserFromDB(_userCred.user!.uid);
      await pluginInitializer(_userCred.user!.uid, userKey: passtextController.text);

      if (_userCred.user!.emailVerified) {
        authStatus.value = AuthStatus.authSuccess;
      } else {
        authStatus.value = AuthStatus.authNeedsVerification;
      }

      clearTextControllers();
    } on firebase_auth.FirebaseAuthException catch (e) {
      authStatus.value = AuthStatus.authFailure;
      if (e.code == 'user-not-found') {
        showGetSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showGetSnackBar('Wrong password provided.');
      } else {
        log(e.code);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> reAuthenticateUser(String oldPassword) async {
    try {
      final firebase_auth.AuthCredential _authCred =
          firebase_auth.EmailAuthProvider.credential(email: currentUser.email, password: oldPassword);

      await _firebaseAuth.currentUser!.reauthenticateWithCredential(_authCred);
      //
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-mismatch' || e.code == 'invalid-credential') {
        showToast('Invalid credentials.');
      } else if (e.code == 'wrong-password') {
        showToast('Wrong password provided.');
      } else if (e.code == 'user-not-found') {
        showToast('No user found for that email.');
      } else {
        log(e.code);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    assert(!currentUser.isSocialLogin);

    await reAuthenticateUser(oldPassword);

    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
      //
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast('Weak password provided.');
      } else if (e.code == 'requires-recent-login') {
        showToast('Reauthentication of user required.');
      } else {
        log(e.code);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteUserAccount(String password) async {
    await reAuthenticateUser(password);

    try {
      await _firebaseAuth.currentUser!.delete();
      await logOut();
    } on firebase_auth.FirebaseAuthException {
      showToast("Reauthentication of user is required.");
    }
  }

  /// This will send an OTP on the user email.
  Future<void> resetPassword() async {
    // await _firebaseAuth.sendPasswordResetEmail(email: emailTextController.text);
  }

  Future<void> logOut() async {
    try {
      authStatus.value = AuthStatus.logoutInProgress;
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
      authStatus.value = AuthStatus.logoutSuccess;
      //
    } on Exception catch (e) {
      authStatus.value = AuthStatus.logoutFailure;
      log(e.toString());
    }
  }
}

// extension on firebase_auth.User {
//   UserModel get toUser {
//     UserModel user = UserModel.empty;

//     FireDBHelper.getUserFromDB(uid).then((UserModel value) => user = value);
//     return user;
//   }
// }
