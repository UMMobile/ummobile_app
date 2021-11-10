import 'dart:convert';
import 'dart:io';

import 'package:ummobile/services/storage/json_file.dart';

class UserSettingsStorage extends JsonStorage {
  static final UserSettingsStorage instance = UserSettingsStorage._internal();

  UserSettingsStorage._internal();

  factory UserSettingsStorage(Directory directory) {
    if (!instance.isCreated) {
      instance.create(withPath: '${directory.path}/user_settings.json');
    }
    return instance;
  }

  Map<String, dynamic> get contentCopy => this.contentAs<Map<String, dynamic>>(
      (json) => Map<String, dynamic>.from(json));

  bool write(Map<String, dynamic> json) => this.writeContent(jsonEncode(json));
}
