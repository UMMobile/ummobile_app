import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:new_version/new_version.dart';
import 'package:oauth2/oauth2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/services/authentication/auth.dart';
import 'package:ummobile/services/onesignal/operations.dart';
import 'package:ummobile/services/storage/quick_login.dart';
import 'package:ummobile/statics/templates/controller_template.dart';

class LoginController extends ControllerTemplate {
  static const double max_users = 2;
  final BuildContext context;

  final _newVersion = NewVersion();
  late VersionStatus? _appStatus;

  LoginController(this.context);

  var credentialsAreExpired = false.obs;
  var showQuickLogins = false.obs;
  String activeUserId = '';

  Credentials credentials = Credentials('');

  Future<String> get token async {
    if (this.credentials.isExpired) {
      Credentials newCredentials = await refresh(this.credentials);
      if (newCredentials.accessToken.isNotEmpty) {
        // Update credentials on state (this.credentials)
        setUserInfo(this.activeUserId, newCredentials);
        // Save new credentials
        QuickLogins(await getApplicationDocumentsDirectory())
            .refreshSession(this.activeUserId, credentials.toJson());
        return newCredentials.accessToken;
      }
    }
    return this.credentials.accessToken;
  }

  var users = List<LoginSession>.empty(growable: true).obs;

  late QuickLogins storage;

  // String get userToken {
  //   //this.users(this.storage.contentCopy);
  //   LoginSession? active;
  //   if (users.isNotEmpty) {
  //     active = users.firstWhere((element) => element.activeLogin);
  //     Map<String, dynamic> map = jsonDecode(active.authCredentials);
  //     print(map["accessToken"]);
  //     return map["accessToken"];
  //   } else {}
  // }

  @override
  void onInit() {
    initialFetch();
    super.onInit();
  }

  @override
  void refreshContent() {
    fetchUsers();
    super.refreshContent();
  }

  void initialFetch() async {
    await fetchAppVersion();
    fetchUsers();
  }

  void setUserInfo(String userId, Credentials credentials) {
    if (this.activeUserId != userId) {
      this.activeUserId = userId;
      setPushNotificationUserId(userId);
    }
    this.credentials = credentials;
  }

  Future<void> fetchAppVersion() async {
    _appStatus = await _newVersion.getVersionStatus();
    if (_appStatus != null) {
      // debugPrint(_appStatus!.releaseNotes);
      // debugPrint(_appStatus!.appStoreLink);
      // debugPrint(_appStatus!.localVersion);
      // debugPrint(_appStatus!.storeVersion);
      // debugPrint(_appStatus!.canUpdate.toString());
      if (_appStatus!.canUpdate)
        _newVersion.showUpdateDialog(
          context: context,
          versionStatus: _appStatus!,
          allowDismissal: false,
          dialogTitle: 'update_available_title'.tr,
          dialogText: 'update_available_description'.tr,
        );
    }
  }

  /// Load the data from the Json stored file
  void fetchUsers() async {
    this.isLoading(true);
    this.storage = QuickLogins(await getApplicationDocumentsDirectory());
    this.tryLoadLastSession();
    //* uncomment this to execute autologin on app start
    // if (!_appStatus!.canUpdate &&
    //     !this.credentialsAreExpired.value &&
    //     this.activeUserId.value.isNotEmpty) {
    //   print("Entering QuickLogin");
    //   startInfo(this.activeUserId.value);
    //   loginTransition();
    //   await Future.delayed(Duration(seconds: 1));
    // }
    this.isLoading(false);
  }

  /// * Method in charge of changing the window through a fade transition between them
  void fadeTransition() async {
    showQuickLogins(false);
  }

  /// Save a new [session] to json file
  void saveUser(LoginSession session) async {
    if (!this.storage.exist ||
        (!this.contains(session.credential) && this.isNotFull())) {
      this.users.add(session);
      this.storage.add(session);
      this.showQuickLogins(true);
    }
  }

  void tryLoadLastSession() {
    if (this.storage.exist) {
      this.users(this.storage.contentCopy);
      if (this.users.isNotEmpty) {
        this.showQuickLogins(true);
        if (!this.storage.allAreInactive) {
          bool isExpired = this.checkExpirationLastSession();
          this.credentialsAreExpired(isExpired);
          if (!isExpired) {
            this.activeUserId = this.storage.currentSessionCopy.credential;
          }
        }
      }
    }
  }

  bool checkExpirationLastSession() {
    Credentials? credentials;
    bool areExpired = false;
    try {
      credentials =
          Credentials.fromJson(this.storage.currentSessionCopy.authCredentials);
      areExpired = credentials.isExpired;
    } finally {}
    return areExpired;
  }

  ///renew user credentials when expired
  void renewUser(int userIndex, Credentials credentials) {
    if (this.storage.exist) {
      storage.renewSession(userIndex, credentials.toJson());
      this.tryLoadLastSession();
    }
  }

  /// Refresh current credentials.
  Future<Credentials> refreshCurrentUserCredentials() async {
    Credentials newCredentials = await refresh(this.credentials);
    if (newCredentials.accessToken.isNotEmpty) {
      // Save new credentials
      setUserInfo(this.activeUserId, newCredentials);
      QuickLogins(await getApplicationDocumentsDirectory())
          .refreshSession(this.activeUserId, credentials.toJson());
      return newCredentials;
    } else {
      return Credentials('');
    }
  }

  /// Remove the user at the specific [index].
  LoginSession removeUser(int index) {
    LoginSession deleted = this.users.removeAt(index);
    showQuickLogins(this.users.isNotEmpty);
    return deleted;
  }

  /// Check if the storage is not full. Max one users.
  bool isNotFull() => this.storage.contentCopy.length < max_users;

  /// Return true if the [userId] is in the users list
  bool contains(String userId) => this
          .storage
          .contentCopy
          .firstWhere((session) => session.credential == userId,
              orElse: () => LoginSession.empty())
          .credential
          .isNotEmpty
      ? true
      : false;
}
