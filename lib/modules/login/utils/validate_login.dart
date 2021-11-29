import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oauth2/oauth2.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/views/page_login.dart';
import 'package:ummobile/modules/tabs/bindings/tabs_binding.dart';
import 'package:ummobile/modules/tabs/views/tabs_view.dart';
import 'package:ummobile/services/storage/login_sessions/models/login_session.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';
import 'package:ummobile/statics/widgets/overlays/snackbar.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

import 'roles_pages.dart';

/// Validates the correct fullfilment of the [user] and the [password] input fields
bool fieldAreValid(String user, String password) {
  bool userValidate = false;
  bool passwordValidate = false;

  userValidate = (user.length >= 6) ? true : false;
  passwordValidate = (password.length > 0) ? true : false;

  if (userValidate && passwordValidate) {
    return true;
  } else {
    if (!userValidate) {
      snackbarMessage(
          'invalid'.trParams({'element': 'user'.tr}), 'invalid_user_hint'.tr);
    } else if (!passwordValidate) {
      snackbarMessage('invalid'.trParams({'element': 'password'.tr}),
          'password_invalid_hint'.tr);
    }
    return false;
  }
}

/// Displays a modal dialog to ask if should store the [userId] and the [credentials]
void promptStoreUser(String userId, Credentials credentials) async {
  openDialogWindow(
    title: 'save_dialog_title'.tr,
    message: 'save_dialog_message'.tr,
    onCancel: () => Get.back(),
    onConfirm: () async {
      openLoadingDialog('saving'.trParams({'element': 'user'.tr}));
      var userApi = UMMobileUser(token: credentials.accessToken);

      User user = await userApi.getInformation(includePicture: true);

      Get.find<LoginController>().saveUser(LoginSession(
        userId: userId,
        name: user.name + " " + user.surnames,
        image: user.image,
        authCredentials: credentials.toJson(),
      ));

      Get.back();
      Get.back();
    },
  );
}

/// Redirects the app to the main section of the app
void loginTransition() {
  Get.to(
    () => TabsView(views: viewsForCurrentUser()),
    transition: Transition.downToUp,
    duration: Duration(milliseconds: 700),
    curve: Curves.ease,
    binding: TabsBinding(),
  );
}

/// Redirects the user to the Login page
void logoutTransition() {
  Get.offAll(
    () => LoginPage(),
    transition: Transition.upToDown,
    duration: Duration(milliseconds: 700),
    curve: Curves.ease,
  );
}

/// Clear the input fields after used
void clearFields(TextEditingController user, TextEditingController password) {
  user.clear();
  password.clear();
}
