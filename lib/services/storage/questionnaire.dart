import 'dart:convert';
import 'dart:io';

import 'package:ummobile/services/storage/json_file.dart';

class QuestionnaireStorage extends JsonStorage {
  static final QuestionnaireStorage instance = QuestionnaireStorage._internal();

  QuestionnaireStorage._internal();

  factory QuestionnaireStorage(Directory directory) {
    if (!instance.isCreated) {
      instance.create(withPath: '${directory.path}/questionnaire.json');
    }
    return instance;
  }

  Map<String, dynamic> get contentCopy => this.contentAs<Map<String, dynamic>>(
      (json) => Map<String, dynamic>.from(json));

  bool write(Map<String, dynamic> json) => this.writeContent(jsonEncode(json));
}
