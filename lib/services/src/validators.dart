import 'package:flutter/foundation.dart';

class Validator {
  String validateEmail(String email) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);
    if (email.isEmpty)
      return "This field cannot be empty";
    else if (!regex.hasMatch(email))
      return "Enter a valid email";
    else
      return null;
  }

  String validatePassword(String password) {
    if (password.isEmpty)
      return "This field cannot be empty";
    else if (password.length < 6)
      return "Password length is less than 6";
    else if (password.contains(" "))
      return "Password should not contain spaces";
    else
      return null;
  }

  String validateConfirmPassword({@required String confirmPassword, @required String newPassword}) {
    // final _normalValidation = validatePassword(confirmPassword);

    // if (_normalValidation != null) return _normalValidation;

    if (confirmPassword != newPassword)
      return "Passwords do not match";
    else
      return null;
  }

  String validateName(String name) {
    if (name.isEmpty)
      return "This field cannot be empty";
    else if (name.contains(RegExp(r'[0-9]')))
      return "Name should not contain numbers";
    else
      return null;
  }
}
