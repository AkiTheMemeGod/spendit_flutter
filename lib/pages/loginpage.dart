// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spendit/auth/auth_service.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});

  final AuthService _authService = AuthService();

  Duration get loadingtime => const Duration(milliseconds: 2000);

  Future<String?> login(BuildContext context, LoginData data) async {
    final email = data.name.toString();
    final password = data.password.toString();

    try {
      await _authService.signinwithemailpassword(email, password);
      return Future.delayed(loadingtime).then((value) => null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Error Signing you in", style: GoogleFonts.breeSerif())));
      return null;
    }
  }

  Future<String?> _recoverpassword(String data) {
    _authService.recoverPassword(data);
    return Future.delayed(loadingtime).then((value) => null);
  }

  Future<String?> _signup(SignupData data) async {
    final email = data.name.toString();
    final password = data.password.toString();

    ///final confirmpassword = data.additionalSignupData;

    await _authService.signupwithemail(email, password);
    return Future.delayed(loadingtime).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onLogin: (LoginData) => login(context, LoginData),
        onRecoverPassword: _recoverpassword,
        onSignup: _signup,
        logo: "lib/assets/logo.png",
        title: 'Spend-it',
        theme: LoginTheme(
          cardTheme: CardTheme(
            color: Colors.grey.shade200,
          ),
          primaryColor: Colors.black,
          accentColor: Colors.black,
          errorColor: Colors.red,
          textFieldStyle: GoogleFonts.breeSerif(color: Colors.black),
          titleStyle: GoogleFonts.breeSerif(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          buttonTheme: LoginButtonTheme(
            splashColor: Colors.white,
            backgroundColor: Colors.black,
            highlightColor: Colors.grey.shade200,
            elevation: 5,
            highlightElevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // add more customization as needed
          ),
        ),
      ),
    );
  }
}
