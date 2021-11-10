import 'package:get/get.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';

/// Current user id logged in
String get userId => Get.find<LoginController>().activeUserId;

/// Return if user is an employee
bool get userIsEmployee => userId.startsWith('9');

/// Return if user is a student
bool get userIsStudent => userId.startsWith(RegExp('[0-1]'));

/*
1080810
1160023
9830438
*/
