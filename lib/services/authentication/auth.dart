import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:ummobile/statics/environment.dart';
import 'package:ummobile/statics/widgets/overlays/snackbar.dart';

/// The URI to the Identity Server.
final authorizationEndpoint = Uri.https('${environment['urls']['is']}',
    '/t/um.movil/oauth2/token', {'scope': 'openid'});

/// Obtains a new client with the credentials for the authenticated [user] & [password].
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

/// Refreshes the given [credentials].
///
/// If an error occur returns empty credentials.
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
