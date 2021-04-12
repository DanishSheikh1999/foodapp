import 'package:auth/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IAuthPageAdatper {
  void onAuthSuccess(BuildContext context, IAuthService authService);
}

class AuthPageAdapter extends IAuthPageAdatper {
  final Widget Function(IAuthService authService) onUserAuthenticated;

  AuthPageAdapter(this.onUserAuthenticated);
  @override
  void onAuthSuccess(BuildContext context, IAuthService authService) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => this.onUserAuthenticated(authService)),
        (Route<dynamic> route) => false);
  }
}
