import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/utils/url_image_to_bytes.dart';
import 'package:ummobile/modules/app_bar/controllers/appbar_controller.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/models/covid_questionnaire_answer_form.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/utils/generate_qr.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/controllers/questionnaire_response_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/services/storage/questionnaire_responses/models/questionnaire_response.dart';
import 'package:ummobile/services/storage/questionnaire_responses/questionnaire_responses_box.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';
import 'package:ummobile/statics/widgets/overlays/snackbar.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class QuestionnaireController extends ControllerTemplate with StateMixin {
  Future<UMMobileSDK> get api async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileSDK(token: accessToken);
  }

  /// True if the questionnaire is ready to be sent
  var questionnaireButtonNotifier = false.obs;

  /// True if questionnaire is already answered
  var isAnswered = false.obs;

  /// True if the contact module has been answered as True
  var contact = false.obs;

  /// True if the has Travel module has been answered as True
  var hasTravel = false.obs;

  /// True if the has Travel module has been answered
  var travelWasSelected = false.obs;

  /// The class which contains the user modules answer
  CovidQuestionnaireAnswer questionnaireData = blankAnswer;

  /// The list of selectable countries in travel module
  List<Country> controllerCountries = List<Country>.empty();

  /// The class of the previous questionnaire answered by the user
  late QuestionnaireResponse currentAnswer;

  /// The storage info for the stored answers
  final QuestionnaireResponsesBox storage = QuestionnaireResponsesBox();

  /// The user info class
  User? user;

  @override
  void onInit() {
    checkAnsweredQuestionnaire();
    super.onInit();
  }

  @override
  void refreshContent() {
    change(null, status: RxStatus.loading());
    checkAnsweredQuestionnaire();
    super.refreshContent();
  }

  /// Resets the questionnaire data
  void resetData() {
    this.questionnaireData = blankAnswer;
  }

  /// Sets bad user state with a [reason].
  ///
  /// If this method is executed then the user cannot pass due to the [reason] given.
  Future<void> cannotPass({required Reasons because}) async {
    final String urlRedQr = generateQuestionnaireQrCode(
      canEnter: false,
      isInternal: false, // doesn't matter this because will be red
    );
    Uint8List imgBytes = await urlImageToBytes(Uri.parse(urlRedQr));
    this.saveLocalAnswer(qr: imgBytes, reason: because);
  }

  /// Checks if the questionnaire was answer today and redirects to the right fetch info
  Future<void> checkAnsweredQuestionnaire() async {
    isAnswered(false);
    await storage.initializeBox();
    bool shallNotPass = false;
    Reasons? reason;

    if (userIsStudent) {
      await call<CovidValidation>(
        httpCall: () async =>
            await (await api).questionnaire.covid.getValidation(),
        onSuccess: (data) {
          if (!data.allowAccess) {
            reason = data.reason;
            shallNotPass = true;
          }
        },
        onCallError: (status) => change(null, status: status),
        onError: (e) => change(null, status: RxStatus.error(e.toString())),
      );
    }

    if (shallNotPass) {
      await fetchUserInfo();
      await this.cannotPass(because: reason!);
      isAnswered(true);
    }

    if (!isAnswered.value) {
      QuestionnaireResponse? storedAnswer =
          storage.findResponseByCredential(userId);

      if (storedAnswer != null) {
        currentAnswer = storedAnswer;
        if (currentAnswer.reason == Reasons.IsSuspect ||
            currentAnswer.reason == Reasons.None) {
          isAnswered(currentAnswer.isFromToday);
        }
      } else {
        isAnswered(false);
      }

      if (!isAnswered.value) {
        await fetchUserInfo();

        // Delete previous answer
        if (storedAnswer != null) {
          storage.deleteResponse(userId);
        }
      }
    }

    change(null, status: RxStatus.success());
  }

  /// Loads the necessary user info for the unanswered page
  Future fetchUserInfo() async {
    await call<User>(
      httpCall: () async =>
          await (await api).user.getInformation(includePicture: true),
      onSuccess: (data) => user = data,
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );

    await call<List<Country>>(
      httpCall: () async => await (await api).catalogue.getCountries(),
      onSuccess: (data) => controllerCountries = data,
      onCallError: (status) => change(null, status: status),
      onError: (e) => change(null, status: RxStatus.error(e.toString())),
    );
  }

  /// Saves the [questionnaire] answers in both the api and locally
  Future<void> saveAnswer(CovidQuestionnaireAnswer questionnaire) async {
    openLoadingDialog('sending'.trParams({
      'element': 'questionnaire'.tr,
    }));

    CovidValidation? validations;

    await call<CovidValidation>(
      httpCall: () async =>
          await (await api).questionnaire.covid.saveAnswer(questionnaire),
      onSuccess: (data) => validations = data,
      onCallError: (status) {
        Get.back();
        snackbarMessage(
            'error_dialog'.trParams({
              'element': 'questionniare_error_value'.tr,
            }),
            " ");
      },
      onError: (e) {
        Get.back();
        snackbarMessage(
            'error_dialog'.trParams({
              'element': 'questionniare_error_value'.tr,
            }),
            " ");
      },
    );

    if (validations != null) {
      Uint8List imgBytes = await urlImageToBytes(validations!.qrUrl);

      // If the user can answered the questionnaire then don't `haveCovid` or `recentArrival`
      this.saveLocalAnswer(
        qr: imgBytes,
        reason: validations!.allowAccess ? Reasons.None : validations!.reason,
      );

      isAnswered(true);

      Get.find<QuestionnaireResponseController>().refreshContent();
      Get.find<AppBarController>().fetchCounters();

      resetData();

      Get.back();
    }
  }

  /// Sets the radio button [type] to the [value] passed
  void radioSetState(bool value, String type) {
    switch (type) {
      case "contact":
        questionnaireData.recentContact.yes = value;
        contact.value = value;
        break;
      case "fever":
        questionnaireData.majorSymptoms["fever"] = value;
        break;
      case "Freqcough":
        questionnaireData.majorSymptoms["frequentCoughing"] = value;
        break;
      case "headache":
        questionnaireData.majorSymptoms["headache"] = value;
        break;
      case "diffbrth":
        questionnaireData.majorSymptoms["difficultyBreathing"] = value;
        break;
      case "sorthrt":
        questionnaireData.minorSymptoms["soreThroat"] = value;
        break;
      case "runnse":
        questionnaireData.minorSymptoms["runnyNose"] = value;
        break;
      case "lssml":
        questionnaireData.minorSymptoms["looseSmell"] = value;
        break;
      case "lstst":
        questionnaireData.minorSymptoms["looseOfTaste"] = value;
        break;
      case "bdpn":
        questionnaireData.minorSymptoms["bodyPain"] = value;
        break;
      case "jntpn":
        questionnaireData.minorSymptoms["jointPain"] = value;
        break;
      case "ydschrg":
        questionnaireData.minorSymptoms["eyeDischarge"] = value;
        break;
      case "drrh":
        questionnaireData.minorSymptoms["diarrhea"] = value;
        break;
      case "vmtng":
        questionnaireData.minorSymptoms["vomiting"] = value;
        break;
      case "chstpn":
        questionnaireData.minorSymptoms["chestPain"] = value;
        break;
      default:
        print("no model given");
    }
    enableQuestionnaireButton();
  }

  /// Enables the send questionaire button if the required
  /// inputs are filled
  void enableQuestionnaireButton() {
    bool recentTravelbl = false;
    bool confirmedCasebl = false;
    bool majorSymptomsbl = false;
    bool minorSymptomsbl = false;

    Map<String, bool> majorSymptoms = questionnaireData.majorSymptoms;
    Map<String, bool> minorSymptoms = questionnaireData.minorSymptoms;

    if (this.travelWasSelected.value) {
      if (this.hasTravel.value) {
        if ((this.questionnaireData.countries.isNotEmpty &&
                (this.questionnaireData.countries.first.country != null &&
                    this.questionnaireData.countries.first.city!.isNotEmpty &&
                    this.questionnaireData.countries.first.date != null)) &&
            (this.questionnaireData.countries.length >= 2 &&
                (this.questionnaireData.countries.last.country != null &&
                    this.questionnaireData.countries.last.city!.isNotEmpty &&
                    this.questionnaireData.countries.last.date != null))) {
          recentTravelbl = true;
        }
      } else {
        recentTravelbl = true;
      }
    }

    if (questionnaireData.recentContact.yes == true) {
      if (questionnaireData.recentContact.when != null) {
        confirmedCasebl = true;
      }
    } else if (questionnaireData.recentContact.yes == false) {
      confirmedCasebl = true;
    }

    if (majorSymptoms["fever"] != null &&
        majorSymptoms["frequentCoughing"] != null &&
        majorSymptoms["headache"] != null &&
        majorSymptoms["difficultyBreathing"] != null) {
      majorSymptomsbl = true;
    }

    if (minorSymptoms["soreThroat"] != null &&
        minorSymptoms["runnyNose"] != null &&
        minorSymptoms["looseSmell"] != null &&
        minorSymptoms["looseOfTaste"] != null &&
        minorSymptoms["bodyPain"] != null &&
        minorSymptoms["jointPain"] != null &&
        minorSymptoms["eyeDischarge"] != null &&
        minorSymptoms["diarrhea"] != null &&
        minorSymptoms["vomiting"] != null &&
        minorSymptoms["chestPain"] != null) {
      minorSymptomsbl = true;
    }

    if (recentTravelbl &&
        confirmedCasebl &&
        majorSymptomsbl &&
        minorSymptomsbl) {
      questionnaireButtonNotifier.value = true;
    } else {
      questionnaireButtonNotifier.value = false;
    }
  }

  saveLocalAnswer({
    required List<int> qr,
    required Reasons reason,
  }) {
    String department = "";
    Residence residence = Residence.Unknown;

    if (user!.isEmployee)
      department = user!.employee!.positions.isNotEmpty
          ? user!.employee!.positions.first.department
          : '';

    if (user!.isStudent) residence = user!.student!.academic!.residence;

    currentAnswer = QuestionnaireResponse.forToday(
      qr: qr,
      userImage: user!.image!,
      name: user!.name + ' ' + user!.surnames,
      strRole: fromRoleTypeToString(user!.role),
      department: department,
      strResidence: fromResidenceTypeToString(residence),
      strReason: fromReasonTypeToString(reason),
    );

    this.storage.addResponse(userId, currentAnswer);
  }
}
