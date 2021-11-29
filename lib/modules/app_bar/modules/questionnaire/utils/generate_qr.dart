import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';

/// Returns the right qr code url depending on the filled values of the questionnaire
String generateQuestionnaireQrCode(
    {required bool canEnter, required bool isInternal}) {
  if (canEnter) {
    if (isInternal) {
      return 'https://api.qrserver.com/v1/create-qr-code/?data=$userId&size=300x300&color=3bbeff';
    } else {
      return 'https://api.qrserver.com/v1/create-qr-code/?data=$userId&size=300x300&color=3bbe3f';
    }
  } else {
    return 'https://api.qrserver.com/v1/create-qr-code/?data=$userId&size=300x300&color=be3b3b';
  }
}
