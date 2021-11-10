import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/models/questionnaire_answer.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/utils/url_image_to_bytes.dart';
import 'package:ummobile/modules/app_bar/controllers/appbar_controller.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/models/covid_questionnaire_answer_form.dart';
import 'package:ummobile/modules/app_bar/modules/questionnaire/utils/generate_qr.dart';
import 'package:ummobile/modules/login/controllers/login_controller.dart';
import 'package:ummobile/modules/login/controllers/questionnaire_response_controller.dart';
import 'package:ummobile/modules/tabs/modules/profile/models/user_credentials.dart';
import 'package:ummobile/services/storage/questionnaire.dart';
import 'package:ummobile/statics/templates/controller_template.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';
import 'package:ummobile/statics/widgets/overlays/snackbar.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class QuestionnaireController extends ControllerTemplate with StateMixin {
  Future<UMMobileSDK> get api async {
    String accessToken = await Get.find<LoginController>().token;
    return UMMobileSDK(token: accessToken);
  }

  var questionnaireButtonNotifier = false.obs;
  var isAnswered = false.obs;
  var contact = false.obs;
  var hasTravel = false.obs;
  var travelWasSelected = false.obs;

  CovidQuestionnaireAnswer questionnaireData = blankAnswer;
  List<Country> controllerCountries = List<Country>.empty();
  QuestionnaireLocalAnswer currentAnswer = QuestionnaireLocalAnswer.empty();
  late QuestionnaireStorage storage;

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

  /// * Mehod that reloads the page when the button action is clicked to load the answered page window
  void sendButtonAction() {
    isAnswered(true);
  }

  /// Reset the questionnaire data
  void resetData() {
    this.questionnaireData = blankAnswer;
  }

  /// Set bad user state with a [reason].
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

  /// * Mehod that checks if the questionnaire was answer today and redirects to the right fetch info
  Future<void> checkAnsweredQuestionnaire() async {
    isAnswered(false);
    storage = QuestionnaireStorage(await getApplicationDocumentsDirectory());
    bool shallNotPass = false;

    if (userIsStudent) {
      await call<CovidValidation>(
        httpCall: () async =>
            await (await api).questionnaire.covid.getValidation(),
        onSuccess: (data) {
          if (!data.allowAccess) {
            this.cannotPass(because: data.reason);
            shallNotPass = true;
          }
        },
        onCallError: (status) => change(null, status: status),
        onError: (e) => change(null, status: RxStatus.error(e.toString())),
      );
    }

    if (shallNotPass) {
      isAnswered(true);
    }

    if (!isAnswered.value) {
      Map<String, dynamic>? stored = storage.contentCopy[userId];

      if (stored != null) {
        currentAnswer = QuestionnaireLocalAnswer.fromJson(stored);
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
        if (stored != null) {
          Map<String, dynamic> copy = storage.contentCopy;
          copy.remove(userId);
          storage.write(copy);
        }
      }
    }

    change(null, status: RxStatus.success());
  }

  /// * Mehod in charge of loading the necessary for the unanswered page
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
      saveLocalAnswer(
        qr: imgBytes,
        reason: validations!.allowAccess ? Reasons.None : validations!.reason,
      );

      sendButtonAction();

      Get.find<QuestionnaireResponseController>().refreshContent();
      Get.find<AppBarController>().fetchCounters();

      resetData();

      Get.back();
    }
  }

  /// * Mehod in charge of saving in the right parameters the values of
  /// * the radio buttons entered by the user in the form
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

  /// * Mehod in charge of enabling the send questionaire button if the required
  /// * inputs are filled
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
    Map<String, dynamic> copyLocal = storage.contentCopy;

    if (!copyLocal.containsKey(userId)) {
      copyLocal[userId] = "";
    }

    String department = "";
    Residence residence = Residence.Unknown;

    if (user!.isEmployee)
      department = user!.employee!.positions.isNotEmpty
          ? user!.employee!.positions.first.department
          : '';

    if (user!.isStudent) residence = user!.student!.academic!.residence;

    currentAnswer = QuestionnaireLocalAnswer.forToday(
      qr: qr,
      userImage: user!.image!,
      name: user!.name + ' ' + user!.surnames,
      role: user!.role,
      department: department,
      residence: residence,
      reason: reason,
    );

    copyLocal[userId] = currentAnswer.toJson();

    this.storage.write(copyLocal);

    return copyLocal;
  }
}
