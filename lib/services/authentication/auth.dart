import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/models/login_session.dart';
import 'package:ummobile/modules/login/utils/validate_login.dart';
import 'package:ummobile/services/onesignal/operations.dart';
import 'package:ummobile/services/storage/quick_login.dart';
import 'package:ummobile/statics/environment.dart';
import 'package:ummobile/statics/widgets/overlays/snackbar.dart';

// TODO (@jonathangomz): [Proposal] Refactor auth service to remove any state logic from here to leave the service to work only for authentication.
// Any state logic should be moved to `LoginController`.
final authorizationEndpoint = Uri.https('${environment['urls']['is']}',
    '/t/um.movil/oauth2/token', {'scope': 'openid'});

//checa la validez de las credenciales almacenadas y realiza un
//inicio de sesion automatico o una salida de sesion
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

//método utilizado para la autenticacion del usuario
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

Future<oauth2.Credentials> loginCredentials(
    String user, String password) async {
  late String messageError;
  oauth2.Client? client;

  try {
    final umEndpoint = await InternetAddress.lookup(environment['urls']['is'])
        .timeout(Duration(milliseconds: 5000))
        .onError((error, stackTrace) {
      messageError = 'check_internet_connection'.tr;
      return [];
    });

    if (umEndpoint.isNotEmpty && umEndpoint[0].rawAddress.isNotEmpty) {
      try {
        client = await loginAuthorization(user, password)
            .timeout(Duration(seconds: 4));
        if (client == null) messageError = 'wrong_credentials'.tr;
      } on TimeoutException catch (_) {
        messageError = "server_failure".tr;
      } on Exception catch (_) {
        messageError = 'error_occurred'.tr;
      }
    } else {
      await InternetAddress.lookup('yahoo.com')
          .timeout(Duration(milliseconds: 5000))
          .catchError((error, stackTrace) {
        messageError = 'check_internet_connection'.tr;
      });
    }
  } catch (e) {
    print("Something bad happened");
  }

  // Once you have a Client, you can use it just like any other HTTP client.
  //print(await client.read('http://example.com/protected-resources.txt'));

  // Once we're done with the client, save the credentials file. This ensures
  // that if the credentials were automatically refreshed while using the
  // client, the new credentials are available for the next run of the
  // program.
  if (client != null) {
    // TODO (@jonathangomz): [Proposal] Remove this and leave separated the services from the state logic. Instead use `LoginController.renewUser`.
    setUserStartInfo(user, client.credentials);
    loginTransition();
    QuickLogins storage = QuickLogins(await getApplicationDocumentsDirectory());
    if (storage.exist) await storage.inactiveAllSessions();
    return client.credentials;
  } else {
    snackbarMessage(messageError, "something_wrong".tr);
    return oauth2.Credentials('');
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
