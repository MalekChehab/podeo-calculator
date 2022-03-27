import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:podeo_calculator/constants/colors.dart';
import 'package:podeo_calculator/view/home/home_screen.dart';

import '../../services/database.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  late String email = '';

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
      return Future.delayed(loginTime).then((_) {
        email = data.name;
        return Database().signIn(data.name, data.password);
      });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      email = data.name.toString();
      return Database().register(data.name.toString(), data.password.toString());
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'User not exists';
      // }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        title: 'Calculator',
        logo: const AssetImage('assets/images/podeo_logo.jpg'),
        // logoTag: 'podeo-logo',
        titleTag: 'calculator-tag',
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(email: email),
            ),
            (route) => false,
          );
        },
        onRecoverPassword: _recoverPassword,
        theme: LoginTheme(
          primaryColor: Theme.of(context).scaffoldBackgroundColor,
          accentColor: Theme.of(context).accentColor,
          pageColorDark: Theme.of(context).scaffoldBackgroundColor,
          pageColorLight: Theme.of(context).scaffoldBackgroundColor,
          switchAuthTextColor: Theme.of(context).scaffoldBackgroundColor,
          cardTheme: CardTheme(
            color: Theme.of(context).accentColor,
          ),
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: Theme.of(context).primaryColor,
            focusColor: Theme.of(context).scaffoldBackgroundColor,
            iconColor: Theme.of(context).scaffoldBackgroundColor,
            prefixIconColor: Theme.of(context).scaffoldBackgroundColor,
            hintStyle: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          errorColor: Colors.deepOrange,
          titleStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            letterSpacing: 4,
          ),
        ),
        messages: LoginMessages(
          userHint: 'Email',
          passwordHint: 'Password',
          confirmPasswordHint: 'Confirm',
          loginButton: 'LOG IN',
          signupButton: 'REGISTER',
          forgotPasswordButton: 'Forgot huh?',
          recoverPasswordButton: 'HELP ME',
          goBackButton: 'GO BACK',
          confirmPasswordError: 'Not match!',
          recoverPasswordSuccess: 'Password rescued successfully',
          recoverPasswordIntro: 'Enter your email address'
        ),
      ),
    );
  }
}
