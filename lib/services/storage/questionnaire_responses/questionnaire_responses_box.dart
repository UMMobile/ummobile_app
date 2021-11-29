import 'package:hive/hive.dart';
import 'package:ummobile/services/storage/questionnaire_responses/models/questionnaire_response.dart';

/// Stores the user's tokens into a json file
///
/// Creates a json file if not exists in device
class QuestionnaireResponsesBox {
  /// The box key
  final String _boxId = "questionnaire_responses";

  /// Initializes the box for read/write functions
  Future<Box<QuestionnaireResponse>> initializeBox() async {
    return await Hive.openBox<QuestionnaireResponse>(this._boxId);
  }

  /// Closes the box to free memory
  void closeBox() async {
    await Hive.box(this._boxId).close();
  }

  Box<QuestionnaireResponse> get box =>
      Hive.box<QuestionnaireResponse>(this._boxId);

  /// Returns a list of stored responses in the device
  List<QuestionnaireResponse> get contentCopy =>
      Hive.box<QuestionnaireResponse>(_boxId).values.toList();

  /// Returns the last [userId] questionnaire response
  QuestionnaireResponse? findResponseByCredential(String userId) =>
      this.box.get(userId);

  /// Stores a new questionnaire [response] with the [userId]
  /// as key
  ///
  /// True if the operation completes succesfully
  bool addResponse(String userId, QuestionnaireResponse response) {
    this.box.put(userId, response);
    return true;
  }

  /// Deletes the [userId] response from device storage
  ///
  /// Returns true if the response was successfully deleted
  bool deleteResponse(String userId) {
    this.box.delete(userId);
    return true;
  }
}
