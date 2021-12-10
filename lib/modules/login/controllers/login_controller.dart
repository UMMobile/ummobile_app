import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:new_version/new_version.dart';
import 'package:oauth2/oauth2.dart';
import 'package:ummobile/modules/login/utils/validate_login.dart';
import 'package:ummobile/services/authentication/auth.dart';
import 'package:ummobile/services/onesignal/operations.dart';
import 'package:ummobile/services/storage/login_sessions/login_session_box.dart';
import 'package:ummobile/services/storage/login_sessions/models/login_session.dart';
import 'package:ummobile/statics/templates/controller_template.dart';

enum Version {
  Major,
  Minor,
  Patch,
}

class LoginController extends ControllerTemplate {
  /// The amount of user that can be saved.
  static const double max_users = 2;

  /// The context to use for new update dialog.
  final BuildContext context;

  /// True if Quick Logins view should be displayed.
  var showQuickLogins = false.obs;

  /// The saved users.
  var users = List<LoginSession>.empty(growable: true).obs;

  /// The active user id.
  String activeUserId = '';

  /// The credentials for active user.
  Credentials credentials = Credentials('');

  /// The storage service for saved users.
  final LoginSessionBox storage = LoginSessionBox();

  /// The access token of this [credentials].
  ///
  /// If access token is expired will try to refresh the credentials. Returns the expired access token if cannot refresh the credentials.
  Future<String> get token async {
    if (this.credentials.isExpired) {
      Credentials newCredentials = await refresh(this.credentials);
      if (newCredentials.accessToken.isNotEmpty) {
        // Update credentials on state (this.credentials)
        this.setUserInfo(this.activeUserId, newCredentials);
        // Save new credentials
        this.storage.refreshSession(this.activeUserId, newCredentials.toJson());
        return newCredentials.accessToken;
      }
    }
    return this.credentials.accessToken;
  }

  /// True if the storage is not full according by [max_users].
  bool get isNotFull => this.storage.contentCopy.length < max_users;

  LoginController(this.context);

  @override
  void onInit() {
    loadLoginConfiguration();
    super.onInit();
  }

  void loadLoginConfiguration() async {
    bool shouldUpdate = await checkForAppUpdates();

    await this.loadStoredUsers();
    bool lastSessionIsActive = this.tryLoadLastSession();

    if (!shouldUpdate && lastSessionIsActive) {
      loginTransition();
    }
  }

  void setUserInfo(String userId, Credentials credentials) {
    if (this.activeUserId != userId) {
      this.activeUserId = userId;
      setPushNotificationUserId(userId);
    }
    this.credentials = credentials;
  }

  Future<bool> checkForAppUpdates() async {
    final NewVersion newVersion = NewVersion();
    VersionStatus? appStatus;
    try {
      appStatus = await NewVersion().getVersionStatus();
    } catch (e) {}

    bool mandatoryUpdate = false;
    if (appStatus != null) {
      mandatoryUpdate = shouldUpdate(appStatus);
      if (mandatoryUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: appStatus,
          allowDismissal: false,
          dialogTitle: 'update_available_title'.tr,
          dialogText: 'update_available_description'.tr,
        );
      }
    }
    return mandatoryUpdate;
  }

  bool shouldUpdate(VersionStatus status,
      {Version minimumVersionPart: Version.Minor}) {
    // debugPrint(status.releaseNotes); // What's new
    // debugPrint(status.appStoreLink); // Link to app on Play Store
    // debugPrint(status.localVersion); // Local app version. Ex. 2.2.1
    // debugPrint(status.storeVersion); // Store app version. Ex. 2.2.2
    // debugPrint(status.canUpdate);

    // If validate patch version should validate minor too
    bool validateMinor = minimumVersionPart == Version.Minor ||
        minimumVersionPart == Version.Patch;
    bool validatePatch = minimumVersionPart == Version.Patch;

    List<String> localVersionParts = status.localVersion.split('.');
    List<String> storeVersionParts = status.storeVersion.split('.');

    int? localMajor;
    int? storeMajor;
    int? localMinor;
    int? storeMinor;
    int? localPatch;
    int? storePatch;

    bool majorIsNewer = false;
    bool minorIsNewer = false;
    bool patchIsNewer = false;

    localMajor = int.tryParse(localVersionParts[0]);
    storeMajor = int.tryParse(storeVersionParts[0]);

    if (localMajor == null || storeMajor == null) return false;

    majorIsNewer = storeMajor > localMajor;

    if (validateMinor) {
      localMinor = int.tryParse(localVersionParts[1]);
      storeMinor = int.tryParse(storeVersionParts[1]);

      if (localMinor == null || storeMinor == null) return false;

      minorIsNewer = (storeMinor > localMinor) && (storeMajor >= localMajor);

      if (validatePatch) {
        localPatch = int.tryParse(localVersionParts[2]);
        storePatch = int.tryParse(storeVersionParts[2]);

        if (localPatch == null || storePatch == null) return false;

        patchIsNewer = (storePatch > localPatch) &&
            (storeMinor >= localMinor) &&
            (storeMajor >= localMajor);
      }
    }

    return majorIsNewer ||
        (validateMinor && minorIsNewer) ||
        (validatePatch && patchIsNewer);
  }

  /// Loads the data from the Json stored file
  Future<void> loadStoredUsers() async {
    this.isLoading(true);

    // Initialize the storage instance for this class
    await this.storage.initializeBox();

    this.users(this.storage.contentCopy);
    this.showQuickLogins(this.users.isNotEmpty);

    this.isLoading(false);
  }

  /// Saves a new [session] to storage.
  void saveUser(LoginSession session) async {
    this.users.add(session);
    this.storage.add(session);
    this.showQuickLogins(true);
  }

  bool tryLoadLastSession() {
    bool lastSessionIsActive = false;
    if (this.users.isNotEmpty) {
      if (!this.storage.areAllInactive) {
        LoginSession activeSession = this.storage.activeSessionCopy;
        Credentials activeSessionCredentials =
            Credentials.fromJson(activeSession.authCredentials);
        if (!activeSessionCredentials.isExpired) {
          this.setUserInfo(activeSession.userId, activeSessionCredentials);
          lastSessionIsActive = true;
        }
      }
    }
    return lastSessionIsActive;
  }

  /// Removes the user at the specific [index].
  LoginSession removeUser(int index) {
    LoginSession deleted = this.users.removeAt(index);
    this.storage.deleteSession(index);
    showQuickLogins(this.users.isNotEmpty);
    return deleted;
  }

  /// Authenticates the [userId] and [password] and logs into the application.
  void authenticate(String userId, String password) {
    login(userId, password).then((credential) {
      if (credential != null) {
        this.setUserInfo(userId, credential);

        this.storage.inactiveAllSessions();

        if (this.contains(userId)) {
          // Save new credentials & activates the session
          storage.refreshSession(userId, credentials.toJson());
        }

        loginTransition();

        if (!this.contains(userId) && this.isNotFull) {
          // If the user is saved then activates the session
          promptStoreUser(userId, credential);
        }
      }
    });
  }

  /// Checks if the [jsonCredentials] are still valid for the user with the specified [userId], and if not try to refresh the credentials.
  ///
  /// Updates the [activeUserId] and the active [credentials] if the credentials are valid or were refreshed.
  Future<bool> checkOrRenewCredentials({
    required String userId,
    required String jsonCredentials,
  }) async {
    Credentials credentials = Credentials.fromJson(jsonCredentials);
    bool credentialsAreValid = false;

    if (credentials.isExpired) {
      try {
        credentials = await refresh(credentials);
        if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
          credentialsAreValid = true;
        }
      } catch (e) {}
    } else {
      credentialsAreValid = true;
    }

    if (credentialsAreValid) {
      // Override current userId & credentials
      this.setUserInfo(userId, credentials);
      this.storage.refreshSession(userId, credentials.toJson());
    }

    return credentialsAreValid;
  }

  /// Returns true if the [userId] is in the users list
  bool contains(String userId) => this
          .storage
          .contentCopy
          .firstWhere((session) => session.userId == userId,
              orElse: () => LoginSession.empty())
          .userId
          .isNotEmpty
      ? true
      : false;
}
