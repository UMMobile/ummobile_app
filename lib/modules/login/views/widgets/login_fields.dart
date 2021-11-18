import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/utils/validate_login.dart';
import 'package:ummobile/statics/settings/colors.dart';

/// Input Fields for login to the application
class LoginFields extends StatefulWidget {
  @override
  _LoginFieldsState createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  late TextEditingController _userController;
  late TextEditingController _passwordController;
  LinearGradient? userGradient;
  LinearGradient? passwordGradient;

  bool _showPassword = false;

  void initState() {
    super.initState();
    _userController = TextEditingController();
    _passwordController = TextEditingController();

    _userController.addListener(_getLatestValueUser);
    _passwordController.addListener(_getLatestValuePassword);
  }

  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _getLatestValueUser() {
    lineDecorationUser(_userController.text);
  }

  _getLatestValuePassword() {
    lineDecorationPassword(_passwordController.text);
  }

  _submitForm(BuildContext context) {
    String userId = _userController.text;
    if (fieldAreValid(userId, _passwordController.text)) {
      Get.find<LoginController>()
          .authenticate(userId, _passwordController.text);
    }
  }

  /// * returns the bottom color of the credential input based on its validation
  void lineDecorationUser(String value) {
    setState(() {
      if (value.isEmpty) {
        userGradient = AppColorThemes.inputGradientIdle;
      } else if (value.length < 6) {
        userGradient = AppColorThemes.inputGradientError;
      } else {
        userGradient = AppColorThemes.inputGradientCorrect;
      }
    });
  }

  /// * returns the bottom color of the password input based on its validation
  void lineDecorationPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        passwordGradient = AppColorThemes.inputGradientIdle;
      } else {
        passwordGradient = AppColorThemes.inputGradientCorrect;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// *Title
            Container(
                child: Text('login'.tr.capitalizeFirst!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold))),

            /// *Credential Field
            Container(
                margin: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
                child: Stack(
                  children: <Widget>[
                    TextField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      controller: _userController,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(7)
                      ],
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      decoration: InputDecoration(
                          hintText: 'user'.tr.capitalizeFirst!,
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.5))),
                      textInputAction: TextInputAction.next,
                    ),
                    Positioned(
                      bottom: -1,
                      child: Container(
                        height: 3,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(gradient: userGradient),
                      ),
                    ),
                  ],
                )),

            /// *Password Field
            Container(
                margin: EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
                child: Stack(
                  children: <Widget>[
                    TextField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      decoration: InputDecoration(
                          hintText: 'password'.tr.capitalizeFirst!,
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.5)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            child: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).colorScheme.secondary),
                          )),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        _submitForm(context);
                      },
                    ),
                    Positioned(
                      bottom: -1,
                      child: Container(
                        height: 3,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(gradient: passwordGradient),
                      ),
                    ),
                  ],
                )),

            /// *Login Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(170.0, 35.0),
                primary: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1.2,
                    style: BorderStyle.solid),
              ),
              onPressed: () {
                _submitForm(context); //Linea para saltar el login
              },
              child: Text(
                'access'.tr.capitalizeFirst!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      if (Get.find<LoginController>().users.isNotEmpty)
        SizedBox(
          height: 32,
          width: 256,
          child: TextButton(
            child: Text(
              'goto_quick_logins'.tr,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Get.find<LoginController>().showQuickLogins(true),
          ),
        ),
    ]);
  }
}
