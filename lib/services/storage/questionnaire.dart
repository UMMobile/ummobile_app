import 'dart:convert';
import 'dart:io';

import 'package:ummobile/services/storage/json_file.dart';

/// Stores the user questionnaire responses
///
/// Creates a json file if not exists in the user's device
class QuestionnaireStorage extends JsonStorage {
  /// The variable in charge of retrieving existing file in user's device
  static final QuestionnaireStorage instance = QuestionnaireStorage._internal();

  QuestionnaireStorage._internal();

  factory QuestionnaireStorage(Directory directory) {
    if (!instance.isCreated) {
      instance.create(withPath: '${directory.path}/questionnaire.json');
    }
    return instance;
  }

  /// Parses the responses content [json] into a map
  Map<String, dynamic> get contentCopy => this.contentAs<Map<String, dynamic>>(
      (json) => Map<String, dynamic>.from(json));

  /// Writes into responses file [json] content
  bool write(Map<String, dynamic> json) => this.writeContent(jsonEncode(json));
}
