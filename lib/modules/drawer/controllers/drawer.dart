import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/services/storage/quick_login.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';
//import 'package:ummobile_sdk/ummobile_sdk.dart';

import '../../../statics/templates/controller_template.dart';

class UmDrawerController extends ControllerTemplate with StateMixin<User> {
  /// marker to know if ht edrawer is open
  bool isOpen = false;

  /// marker to know if is going to be deleted the controller
  bool needToBeDelete = false;

  Future<UMMobileUser> get userApi async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileUser(token: accessToken);
  }

  @override
  void onInit() {
    fetchUserInfo();
    super.onInit();
  }

  /// * Mehod in charge of loading the necessary data of the page
  void fetchUserInfo() async {
    call<User>(
      httpCall: () async =>
          await (await userApi).getInformation(includePicture: true),
      onSuccess: (data) => change(data, status: RxStatus.success()),
      onCallError: (status) async {
        User? storedUser = await getUserFromStorage();
        if (storedUser != null)
          change(storedUser, status: status);
        else
          change(null, status: status);
      },
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }

  Future<User?> getUserFromStorage() async {
    LoginSession session = QuickLogins(await getApplicationDocumentsDirectory())
        .contentCopy
        .firstWhere((element) => element.credential == userId,
            orElse: () => LoginSession.empty());
    if (session.credential.isNotEmpty) {
      return User(
        id: int.parse(userId),
        image: session.image ?? '',
        name: session.name,
        surnames: session.name,
        role: userIsStudent
            ? Roles.Student
            : userIsEmployee
                ? Roles.Employee
                : Roles.Unknown,
        extras: UserExtras(
            email: "", curp: "", maritalStatus: "", birthday: DateTime.now()),
      );
    } else {
      return null;
    }
  }

  /// * goes to the selected page if it's different to the active page
  changeView(Widget view, Bindings? binding) {
    Get.to(
      () => view,
      transition: Transition.rightToLeft,
      duration: Duration(milliseconds: 700),
      curve: Curves.ease,
      binding: binding,
    );
  }

  void updateIsOpen(bool isOpen) => this.isOpen = isOpen;
  void updateNeedToBeDelete(bool needToBeDelete) =>
      this.needToBeDelete = needToBeDelete;
}
