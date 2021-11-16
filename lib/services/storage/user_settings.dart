import 'dart:convert';
import 'dart:io';

import 'package:ummobile/services/storage/json_file.dart';

/// Stores the user's app settings in a json file
///
/// Creates a new json file if not exists
class UserSettingsStorage extends JsonStorage {
  /// The variable in charge of retrieving existing file in user's device
  static final UserSettingsStorage instance = UserSettingsStorage._internal();

  UserSettingsStorage._internal();

  factory UserSettingsStorage(Directory directory) {
    if (!instance.isCreated) {
      instance.create(withPath: '${directory.path}/user_settings.json');
    }
    return instance;
  }

  /// Parses the file content [json] into a map
  Map<String, dynamic> get contentCopy => this.contentAs<Map<String, dynamic>>(
      (json) => Map<String, dynamic>.from(json));

  /// Writes into settings file [json] content
  bool write(Map<String, dynamic> json) => this.writeContent(jsonEncode(json));
}
