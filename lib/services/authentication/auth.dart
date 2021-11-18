import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/services/onesignal/operations.dart';
import 'package:ummobile/services/storage/quick_login.dart';
import 'package:ummobile/statics/environment.dart';
import 'package:ummobile/statics/widgets/overlays/snackbar.dart';

// TODO (@jonathangomz): [Proposal] Refactor auth service to remove any state logic from here to leave the service to work only for authentication.
// Any state logic should be moved to `LoginController`.
final authorizationEndpoint = Uri.https('${environment['urls']['is']}',
    '/t/um.movil/oauth2/token', {'scope': 'openid'});

/// Returns a True value if the credentials of the user
/// are expired or doesn't exist
Future<bool> checkCredentialsExpired(LoginSession session) async {
  QuickLogins storage = QuickLogins(await getApplicationDocumentsDirectory());

  if (!storage.exist) {
    return true;
  }

  int index =
      storage.contentCopy.indexWhere((element) => element.activeLogin == true);

  if (index == -1) {
    return true;
  }

  oauth2.Credentials credentials =
      oauth2.Credentials.fromJson(session.authCredentials);

  if (credentials.isExpired) {
    return true;
  }

  return true;
}

///
Future<oauth2.Client?> loginAuthorization(String user, String password) async {
  final username = user + '@um.movil';

  try {
    oauth2.Client ouath = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint, username, password,
        identifier: environment['tokens']['identifier'],
        secret: environment['tokens']['secret']);

    return ouath;
  } catch (e) {
    return null;
  }
}

/// Obtains credentials based on the [username] and [password].
Future<oauth2.Credentials?> login(String username, String password) async {
  late String messageError;
  oauth2.Client? client;

  try {
    // Check if the device can connect to identity server
    final umEndpoint = await InternetAddress.lookup(environment['urls']['is'])
        .timeout(Duration(milliseconds: 5000))
        .onError((error, stackTrace) {
      messageError = 'check_internet_connection'.tr;
      return [];
    });

    if (umEndpoint.isNotEmpty && umEndpoint[0].rawAddress.isNotEmpty) {
      try {
        client = await loginAuthorization(username, password)
            .timeout(Duration(seconds: 4));
        if (client == null) messageError = 'wrong_credentials'.tr;
      } on TimeoutException catch (_) {
        messageError = "server_failure".tr;
      } on Exception catch (_) {
        messageError = 'error_occurred'.tr;
      }
    } else {
      // If cannot connect to identity server check internet connection by sending a request to "yahoo.com"
      await InternetAddress.lookup('yahoo.com')
          .timeout(Duration(milliseconds: 5000))
          .catchError((error, stackTrace) {
        messageError = 'check_internet_connection'.tr;
      });
    }
  } catch (e) {
    print("Something bad happened");
  }

  if (client != null) {
    return client.credentials;
  } else {
    snackbarMessage(messageError, "something_wrong".tr);
    return null;
  }
}

void setUserStartInfo(String userId, oauth2.Credentials credentials) {
  Get.find<LoginController>().activeUserId = userId;
  Get.find<LoginController>().credentials = credentials;
  setPushNotificationUserId(userId);
}

Future<bool> checkOrRenewCredentials({
  required String userId,
  required String jsonCredentials,
}) async {
  oauth2.Credentials credentials = oauth2.Credentials.fromJson(jsonCredentials);

  if (credentials.isExpired) {
    try {
      oauth2.Client client = oauth2.Client(
        credentials,
        identifier: environment['tokens']['identifier'],
        secret: environment['tokens']['secret'],
      );

      client = await client.refreshCredentials();

      // Override current credentials on Storage and for current State
      credentials = client.credentials;
    } catch (e) {
      return false;
    }
  }

  // TODO (@jonathangomz): [Proposal] Create a separated method to activate specific user and to renew token.
  // TODO (@jonathangomz): [Proposal] Add this method execution to `setUserStartInfo`.
  QuickLogins(await getApplicationDocumentsDirectory())
      .refreshSession(userId, credentials.toJson());

  setUserStartInfo(userId, credentials);

  return true;
}

Future<oauth2.Credentials> refresh(oauth2.Credentials credentials) async {
  try {
    oauth2.Client client = oauth2.Client(
      credentials,
      identifier: environment['tokens']['identifier'],
      secret: environment['tokens']['secret'],
    );

    client = await client.refreshCredentials();
    return client.credentials;
  } catch (e) {
    return oauth2.Credentials('');
  }
}
